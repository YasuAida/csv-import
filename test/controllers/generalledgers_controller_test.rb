require 'test_helper'

class GeneralledgersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
