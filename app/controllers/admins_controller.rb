class AdminsController < ApplicationController

  before_action :authenticate_admin!

  def index
  end 

  def new_user
    @user = User.new
  end

  def create_user
    @user = User.new(user_params)
    @user.admin_approved = true
    @user.status = 'Approved'
    @user.cash = 0
    if @user.save
      redirect_to show_user_admins_path, notice: 'Account was successfully created.'
    else
      puts @user.errors.full_messages
      render :new_user
    end
  end

  def edit_user
    @user = User.find(params[:id])
  end

  def update_user
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to show_user_admins_path, notice: 'User details successfully updated.'
    else
      render :edit_user
    end
  end

  def show_user
    @user = User.all
  end

  def approve_user
    @user = User.find(params[:id])
    @user.update(admin_approved: true, status: 'approved')
    redirect_to admins_show_user_path, notice: 'User was approved.'
  end

  def pending_trader_signups
    @pending_users = User.where(status: 'Pending')
  end

  def all_transactions
    @transactions = Transaction.all.order(created_at: :desc)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :user_id, :email, :password, :password_confirmation)
  end
  
end