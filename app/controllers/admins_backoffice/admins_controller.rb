# frozen_string_literal: true

class AdminsBackoffice::AdminsController < AdminsBackofficeController
  before_action :check_password, only: [:update]
  before_action :set_admin, only: [:edit, :update]
  before_action :params_admin, only: [:update]

  def index
    @admins = Admin.all
  end

  def edit
  end

  def update  
    if @admin.update(params_admin)
      redirect_to admins_backoffice_welcome_index_path, notice: 'Administrador atualizado com sucesso!'
    else
      render :edit
    end
  end

  def check_password
    if params[:admin][:password].blank? && params[:admin][:password_confirmation].blank?
      params[:admin].extract!(:password, :password_confirmation)
    end    
  end

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def params_admin
    params_admin = params.require(:admin).permit(:email, :password, :password_confirmation)
  end
end
