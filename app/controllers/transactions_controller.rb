class TransactionsController < ApplicationController
  def index
  end

  def buy
    @transaction = Transaction.new
  end

  def sell
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)
    populate_price_and_amount if @transaction.valid?  # Call the method to populate price and shares

    respond_to do |format|
      if @transaction.save
        if request.referer == transactions_buy_url
          format.html { redirect_to transactions_buy_url, notice: "transaction was successfully created." }
        else
          format.html { redirect_to transactions_sell_url, notice: "transaction was successfully created." }
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

  private

  def populate_price_and_amount
    if @transaction.shares.present?
      stock_code = params[:transaction][:stock]
      data = IEX::Api::Client.new.quote(stock_code)
  
      @transaction.price = data.latest_price
      @transaction.amount = @transaction.shares * @transaction.price
    end
  end

  def transaction_params
      params.require(:transaction).permit(:stock, :price, :amount, :shares, :user_id, :action)
  end
end
