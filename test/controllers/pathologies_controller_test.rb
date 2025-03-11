require "test_helper"

class PathologiesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get pathologies_create_url
    assert_response :success
  end

  test "should get destroy" do
    get pathologies_destroy_url
    assert_response :success
  end
end
