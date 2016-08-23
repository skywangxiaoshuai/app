class UsersController < ApplicationController
  # 前置过滤器,确保只有登录账户之后才可以访问edit和update
  before_action :logged_in_user, only:  [:index, :edit, :update, :destroy, :following, :followers]

  # 前置过滤器确保只有自己才能修改自己的信息
  before_action  :correct_user,  only:  [:edit, :update]

  before_action  :admin_user,    only:  :destroy

  def index
    @users = User.paginate(page:  params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page:  params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = '请进入您的邮箱激活账户！'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user  =  User.find(params[:id])
  end

  def update
    @user  =  User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = '信息修改成功'
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = '删除成功！'
    redirect_to users_url
  end

  def following
    @title = '我关注的人'
    @user = User.find(params[:id])
    @users = @user.following.paginate(page:  params[:page])
    render 'show_follow'
  end

  def followers
    @title = '关注我的人'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page:  params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # 前置过滤器

  # 确保是正确的用户
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # 确保是管理员
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
