require 'test_helper'

class AdditivesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get additive_show_url
    assert_response :success
  end

end
