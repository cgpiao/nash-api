require "test_helper"

class AccountControllerTest < ActionDispatch::IntegrationTest
   def setup
      super
      @params1 = {
         username: 'user1',
         password: 'secret'
      }
   end
   test "create user" do
      params = {
         username: 'user3',
         password: 'qwer1234'
      }
      post accounts_url, params: params
      assert_response :success
      #
   end

   test "login" do
      post login_url, params: @params1
      assert_response :success
   end


   test "logout" do

      post login_url, params: @params1
      assert_response :success
      delete logout_url, headers: {
         'Authorization': 'Bearer ' + @response.body
      }
      assert_response 200
      delete logout_url, headers: {
         'Authorization': 'Bearer ' + @response.body
      }
      assert_response 401
   end

   test "show" do
      post login_url, params: @params1
      get account_url, headers: {
         'Authorization': 'Bearer ' + @response.body
      }
      body = @response.parsed_body
      assert_equal 'user1', body['username']
   end
end
