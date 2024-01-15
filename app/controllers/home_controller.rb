class HomeController < ApplicationController
  before_action :redirect_signed_in_user

  def index
  end

  private
  
  def redirect_signed_in_user
    if user_signed_in? || admin_signed_in?
      redirect_to dashboard_path
    end
  end
end
