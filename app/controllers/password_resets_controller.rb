class PasswordResetsController < ApplicationController
    before_action  :get_user,     only:[:edit,  :update]
    before_action  :valid_user,     only:[:edit,  :update]
    before_action  :check_expiration,  only:  [:edit,  :update]

  def new
  end

  def edit
  end

  def  create
    @user  =  User.find_by(email:  params[:password_reset][:email].downcase)
    if  @user
        @user.create_reset_digest
        @user.send_password_reset_email
        flash[:info]  =  "请到邮件中修改密码！"
        redirect_to  root_url
    else
        flash.now[:danger]  =  "该邮箱未被注册！"
        render  'new'
    end
  end

  def  update
    if params[:user][:password] != params[:user][:password_confirmation]
      @user.errors.add(:password,  "密码不一致！")
      render 'edit'
    elsif  params[:user][:password].empty?
      @user.errors.add(:password,  "密码不能为空！")
      render 'edit'
    elsif  @user.update_attributes(user_params)
      log_in  @user
      flash[:success]  =  "密码重置成功！"
      redirect_to  @user
    else
      render  'edit'
    end
  end

  private

  def  user_params
    params.require(:user).permit(:pasword,  :password_confirmation)

  end

    def  get_user
        @user  =  User.find_by(email:  params[:email])
    end

    #确保是正确用户
    def  valid_user
        unless  (@user  &&  @user.activated?  &&  @user.authenticated?(:reset,  params[:id]))
            redirect_to  root_url
        end
    end

    #检查令牌是否过期
    def  check_expiration
      if  @user.password_reset_expired?
        flash[:danger]  =  "密码重置链接已过期！"
        redirect_to  new_password_reset_url
      end
    end

end
