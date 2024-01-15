class PortfolioController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @portfolio = current_user.portfolio_value

    @total_portfolio_value = (@portfolio&.values&.sum { |data| data[:value] } || 0) + (current_user&.cash || 0)
    @user_cash = current_user&.cash || 0
  end
end