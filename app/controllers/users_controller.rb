class UsersController < ApplicationController
  before_action :set_user, only:[:show, :edit, :update, :destroy]
  before_action :user_check, only: [:show,:edit, :update, :destroy]
  before_action :login_check, only:[:new]
  def new
    @user=User.new
  end
  def create
    @user=User.new(user_params)
    if @user.save
      unless current_user.admin?
      session[:user_id] = @user.id
      else
        redirect_to admin_users_path
      end
      flash[:success]="account created successfull"
    else
      flash[:danger]="something is wrong !"
      render :new
    end
  end
  def show
  end
  def edit
  end
  def update
    if @user.update(user_params)
      flash[:success]="Post update"
      redirect_to user_path(current_user.id)
    else
      render :new
    end
  end
  def destroy
    @user.destroy
    redirect_to new_user_path
  end
  private
  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end
  def set_user
    @user=User.find(params[:id])
  end
  def user_check
    redirect_to user_path(current_user.id), notice:('access deny') unless current_user == @user || current_user.admin?
  end

  def login_check
    redirect_to user_path(current_user.id), notice:('you are already logged') if logged_in?
  end
end
