class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :logged_in_user, only: [:edit, :update]
  before_action :admin_user,     only: :destroy



  def index
    # インスタンス変数@usersに以下を代入
    # Userテーブルからactivated:がtrueのデータをすべて取り出してpaginate(page: params[:page])する
    #@users = User.where(activated: true).paginate(page: params[:page])
    @users = User.paginate(page: params[:page])

  end

  def show
    # @userにUserテーブルから(params[:id])のデータを取り出して代入
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])

    #redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  # def create
  #   @user = User.new(user_params)
  #   if @user.save
  #     @user.send_activation_email
  #     flash[:info] = "Please check your email to activate your account."
  #     redirect_to root_url
  #   else
  #     render 'new'
  #   end
  # end

  def create
    @user = User.new(user_params)
    if @user.save
    log_in @user
    flash[:success] = "Welcome to the Sample App!"
    redirect_to @user
    else
    render 'new'
    end
    end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # beforeアクション


    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
end
