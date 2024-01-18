class PortfolioController < ApplicationController
  before_action :authenticate_user!, :check_admin_approval
  
  def index
    @portfolio = current_user.portfolio_value

    @total_portfolio_value = (@portfolio&.values&.sum { |data| data[:value] } || 0) + (current_user&.cash || 0)
    @user_cash = current_user&.cash || 0
  end

  private

  def check_admin_approval
    unless current_user && current_user.admin_approved
      redirect_to root_path
    end
  end
end