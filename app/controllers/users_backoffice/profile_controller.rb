# frozen_string_literal: true

class UsersBackoffice::ProfileController < UsersBackofficeController
  before_action :check_password, only: %i[update]
  before_action :set_user, only: %i[edit update]

  def edit
    @user.build_user_profile if @user.user_profile.blank?
  end

  def update
    if @user.update(user_params)
      bypass_sign_in(@user)
      unless user_params[:user_profile_attributes][:avatar]
        redirect_to users_backoffice_welcome_index_path, notice: 'Avatar atualizado'
      end
    else
      render :edit
    end
  end

  private

  def check_password
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      # remove password params to be able to save without those informations
      params[:user].extract!(:password, :password_confirmation)
    end
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password,
                                 :password_confirmation,
                                 user_profile_attributes: %i[id address birthday gender avatar])
  end

  def set_user
    @user = User.find(current_user.id)
  end
end
