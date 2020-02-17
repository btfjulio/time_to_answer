# frozen_string_literal: true

class AdminsBackoffice::AdminsController < AdminsBackofficeController
  before_action :set_admin, only: [:edit, :update, :destroy]
  before_action :params_admin, only: [:update]
  before_action :check_password, only: [:update]

  def index
    @admins = Admin.all.order(:email).page(params[:page]).per(5)
  end

  def new
    @admin = Admin.new
  end
  
  def create
    @admin = Admin.new(params_admin)
    if @admin.save
      redirect_to admins_backoffice_welcome_index_path, notice: 'Administrador criado com sucesso!'
    else
      render :new
    end
  end

  def edit
  end

  def update  
    if @admin.update(params_admin)
      AdminMailer.update_email(current_user, @admin).deliver_now
      redirect_to admins_backoffice_welcome_index_path, notice: 'Administrador atualizado com sucesso!'
    else
      render :edit
    end
  end

  def destroy  
    if @admin.destroy
      redirect_to admins_backoffice_admins_path, notice: 'Administrador deletado com sucesso!'
    else
      render :index
    end
  end

  private

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
