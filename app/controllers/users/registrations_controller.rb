# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params

  def update_cash
    additional_cash = params[:user][:cash].to_f
    new_cash_balance = current_user.cash.to_f + additional_cash

    if current_user.update(cash: new_cash_balance)
      redirect_to portfolio_path, notice: 'Cash updated successfully.'
    end
  end

  # # GET /resource/sign_up
  # def new
  #   super
  # end

  # # POST /resource
  # def create
  #   super
  # end

  # # GET /resource/edit
  # def edit
  #   super
  # end

  # # PUT /resource
  # def update
  #   super
  # end

  # # DELETE /resource
  # def destroy
  #   super
  # end

  # # GET /resource/cancel
  # # Forces the session data which is usually expired after sign
  # # in to be expired now. This is useful if the user wants to
  # # cancel oauth signing in/up in the middle of the process,
  # # removing all OAuth session data.
  # # def cancel
  # #   super
  # # end

  protected

  # # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :user_id, :email, :password, :confirm_password, :cash, :admin_approved, :status])
  end

  # # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:cash])
  end

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def after_sign_out_path_for(user)
    new_user_session_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
