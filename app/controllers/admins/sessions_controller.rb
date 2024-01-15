class Admin::SessionsController < Devise::SessionsController
end




# class Admin::SessionsController < ApplicationController
#   before_action :require_no_admin, only: [:new, :create]
#   before_action :require_admin, only: [:destroy]
  
#   def new
#   end

#   def create
#     admin = Admin.find_by(email: params[:admin_session][:email])

#     if admin && admin.authenticate(params[:admin_session][:password])
#       session[:admin_id] = admin.id
#       redirect_to admins_index_path, notice: 'Logged in successfully!'
#     else
#       flash.now[:alert] = 'Invalid login details.'
#       render 'new'
#     end
#   end

#   def index
#     @admins = Admin.all
#   end

#   def destroy
#     session[:admin_id] = nil
#     redirect_to root_path, notice: 'Logged out successfully!'
#   end

#   private

#   def require_no_admin
#     redirect_to admins_index_path if current_admin
#   end

#   def require_admin
#     redirect_to new_admin_session_path unless current_admin
#   end

# end
