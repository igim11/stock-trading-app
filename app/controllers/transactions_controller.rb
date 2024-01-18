class TransactionsController < ApplicationController
  before_action :authenticate_user!, :check_admin_approval

  def index
  end

  def buy
    @transaction = Transaction.new
  end

  def sell
    @transaction = Transaction.new
    @portfolio = current_user.portfolio_value
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.user = current_user
    populate_price_and_amount if @transaction.valid?  # Call the method to populate price and shares

    respond_to do |format|
      if @transaction.save
        update_user_cash(@transaction)
        if request.referer == transactions_buy_url
          format.html { redirect_to transactions_buy_url, notice: "Successfully bought #{@transaction.shares} shares of #{@transaction.stock}." }
        else
          format.html { redirect_to transactions_sell_url, notice: "Successfully sold #{@transaction.shares} shares of #{@transaction.stock}." }
        end
        format.json { render :show, status: :created, location: @transaction }
      else
        if request.referer == transactions_buy_url
          format.html { render :buy, status: :unprocessable_entity }
        else
          format.html { render :sell, status: :unprocessable_entity }
        end
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_available_shares
    stock_code = params[:stock]
    available_shares = current_user.available_shares(stock_code)
    render json: { availableShares: available_shares }
  end

  private

  def check_admin_approval
    unless current_user && current_user.admin_approved
      redirect_to root_path
    end
  end

  def populate_price_and_amount
    if @transaction.shares.present?
      stock_code = params[:transaction][:stock]
      data = IEX::Api::Client.new.quote(stock_code)
  
      @transaction.price = data.latest_price
      @transaction.amount = @transaction.shares * @transaction.price
    end
  end

  def update_user_cash(transaction)
    user = transaction.user
    amount = transaction.amount
  
    if transaction.action == 'buy'
      user.update(cash: user.cash - amount)
    elsif transaction.action == 'sell'
      user.update(cash: user.cash + amount)
    end
  end

  def transaction_params
      params.require(:transaction).permit(:stock, :price, :amount, :shares, :user_id, :action)
  end
end
