require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get log_in" do
    get :log_in
    assert_response :success
  end

end
