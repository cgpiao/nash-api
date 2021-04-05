class AccountsController < ApplicationController
   before_action :check_account_params, :only => :create

   def show
      result = {
         file_amount: @user.file_amount,
         plan: @user.storage
      }
      succeed result
   end

   def create
      begin
         username = params[:username]
         password = params[:password]

         User.transaction do
            user = User.create!(username: username, password: password, password_confirmation: password)
            @token = UserToken.create!(user_id: user.id)
         end
         succeed @token.auth_token
      rescue => e
         fail 1, message: (I18n.t 'msg_1_1' + e.message)
      end

   end

   def login
      username = params[:username]
      password = params[:password]
      user = User.find_by(username: username)
      unless user
         fail 1, message: (I18n.t 'msg_2_1')
      else
         if user.authenticate(password)
            token = UserToken.create(user_id: user.id)
            succeed token.auth_token
         else
            fail 1, message: (I18n.t 'msg_2_1')
         end
      end
   end

   def logout
      @token.destroy
      succeed
   end

   def captcha
      no = rand(1111...9999)
      token = SecureRandom.base64(24)
      svg = Victor::SVG.new viewBox: "0 0 150 70"
      svg.rect x: 0, y: 0, width: 150, height: 70, fill: 'transparent'
      svg.text no.to_s, x: 20, y: 50, font_family: 'arial', font_weight: 'bold', font_size: 40, fill: 'lightblue'
      svg.save("./storage/captcha/" + token)
      succeed token
   end

   private

   def check_account_params
      username = params[:username]
      password = params[:password]
      user = User.new(username: username, password: password)
      unless user.valid?
         if user.errors[:username].any?
            fail 1, message: (I18n.t 'msg_1_2')
         elsif user.errors[:password].any?
            fail 1, message: (I18n.t 'msg_1_3')
         end
      end
   end

end
