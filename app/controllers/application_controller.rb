class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception


        include  SessionsHelper
    private
        #确保用户已经登录
        def  logged_in_user
            unless logged_in?
                store_location
                flash[:danger]  =  "请登录账号"
                redirect_to  login_url
            end
        end

end
