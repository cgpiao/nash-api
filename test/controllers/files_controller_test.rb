require "test_helper"

class FilesControllerTest < ActionDispatch::IntegrationTest
   setup do
      params = {
         username: 'user1',
         password: 'secret'
      }
      post login_url, params: params
      assert_response :success
      @headers = {
         'Authorization': 'Bearer ' + @response.body
      }
   end

   test "the truth" do
      assert true
   end
end
