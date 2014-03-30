class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      user.send_password_reset
      redirect_to sessions_url, flash: {success: I18n.t('password_reset.send_email')}
    else
      redirect_to sessions_url, flash: {error: I18n.t('user.incorrect_password')}
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    type = :contact
    unless @user.instance_of? Contact
      type = :mooveit_user
    end
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, flash: {error: I18n.t('password_reset.error')}
    else
      @user.assign_attributes(params[type])
      if @user.valid? and not @user.check_not_empty
        @user.save
        redirect_to sessions_url, flash: {success: I18n.t('password_reset.success')}
      else
        render 'edit'
      end
    end
  end

end
