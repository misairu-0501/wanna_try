require "test_helper"

class Public::SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get search_input" do
    get public_search_search_input_url
    assert_response :success
  end

  test "should get search_result" do
    get public_search_search_result_url
    assert_response :success
  end
end
