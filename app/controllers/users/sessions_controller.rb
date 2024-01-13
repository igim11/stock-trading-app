# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :authenticate_user!
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # # GET /resource/sign_in
  # def new
  #   super
  # end

  # # POST /resource/sign_in
  def create
    super do |user|
      user.admin_approved = false
      user.save
      UserMailer.approval_email(user).deliver_later
      redirect_to new_user_session_path
    end
  end

  # # DELETE /resource/sign_out
  def destroy
    root_path
  end

  protected

  def after_sign_in_path_for(resource)
    dashboard_path
  end


  def after_sign_up_path_for(resource)
    dashboard_path
  end

  # # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  # end
end
