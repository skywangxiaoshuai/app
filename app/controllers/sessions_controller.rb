class SessionsController < ApplicationController

  def new

  end

  def create
      user  =  User.find_by(email:  params[:session][:email].downcase)
      if  user  &&  user.authenticate(params[:session][:password])
        #登陆用户。然后重定向到用户的资料页面
        if  user.activated?
          log_in  user  #自定义的辅助方法
          params[:session][:remember_me]  ==  "1"  ?  remember(user)  :  forget(user)

          redirect_back_to  user  #redirect_to  user_url(user)
        else
          message  =  "账号没有激活！"
          message  +=  "请进入您的注册邮箱激活账号！"
          flash[:warning]  =  message
          redirect_to  root_url
        end

      else
          #创建一个错误消息
          flash.now[:danger]  =  '账号或密码错误！'
          render  'new'
      end
  end

  def destroy
        log_out  if  logged_in?
        redirect_to  root_url
  end
end
