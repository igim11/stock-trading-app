class AdminsController < ApplicationController

  before_action :authenticate_admin!

  def index
  end 

  def new_user
    @user = User.new
  end

  def create_user
    @user = User.new(user_params)
    if @user.save
      redirect_to admins_path, notice: 'Account was successfully created.'
    else
      render :new_user
    end
  end

  def edit_user
    @user = User.find(params[:id])
  end

  def update_user
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admins_path, notice: 'User details successfully updated.'
    else
      render :edit_user
    end
  end

  def show_user
    @user = User.all
  end

  def approve_user
    @user = User.find(params[:id])
    @user.update(status: 'Approved')
    redirect_to admins_path, notice: 'User was approved.'
  end

  def pending_trader_signups
    @pending_users = User.where(status: 'pending')
  end

  def all_transactions
    @transactions = Transaction.all.order(created_at: :desc)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :address, :username, :password, :password_confirmation)
  end
end