class ApplicationController < ActionController::API
   before_action :check_login
   around_action :switch_locale

   def succeed(data = nil)
      render json: data
   end

   def fail(code = 1, message: '', errors: [])
      if errors.empty?
         render json: {code: code, message: message}, status: 400
      else
         render json: {code: code, message: message, errors: errors}, status: 400
      end
   end

   private

   def switch_locale(&action)
      locale = request.headers['X-LOCALE'] || I18n.default_locale
      I18n.with_locale(locale, &action)
   end

   def check_login
      path_info = request.path_info
      prefix = '/v1'
      exclude_paths = [
         prefix + '/login',
         prefix + '/accounts',
      ]
      @offset = request.headers['offset']
      @timezone = request.headers['timezone']
      unless exclude_paths.include? path_info
         token = request.headers['Authorization']
         token = token.split(' ')[1]
         @token = UserToken.find_by(auth_token: token)
         if @token.nil?
            render status: 401
            return
         end
         @user = User.find(@token.user_id)
         unless @user
            render status: 401
         end
      end
   end
end
