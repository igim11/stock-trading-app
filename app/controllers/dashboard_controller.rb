class DashboardController < ApplicationController
  def show
    user = User.find(1)
    @portfolio = user.portfolio_value

    @total_portfolio_value = @portfolio.values.sum { |data| data[:value] } + user.cash
    @user_cash = user.cash
  end
end
