require "test_helper"

class Public::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get my_page" do
    get public_users_my_page_url
    assert_response :success
  end

  test "should get edit" do
    get public_users_edit_url
    assert_response :success
  end

  test "should get index" do
    get public_users_index_url
    assert_response :success
  end

  test "should get show" do
    get public_users_show_url
    assert_response :success
  end
end
