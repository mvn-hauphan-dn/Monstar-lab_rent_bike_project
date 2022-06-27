require "test_helper"

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should get error" do
    get errors_error_url
    assert_response :success
  end
end
