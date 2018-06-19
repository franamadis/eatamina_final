require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get requests" do
    get dashboard_requests_url
    assert_response :success
  end

end
