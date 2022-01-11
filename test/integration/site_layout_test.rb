require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:angel)
  end

  def shared_layout_links
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", news_path
    get contact_path
    assert_select "title", full_title("Contact")
    get signup_path
    assert_select "title", full_title("Sign up")
  end
  
  test "layout links" do
    # While logged in
    log_in_as(@user)
    shared_layout_links
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", "#", class: "dropdown-toggle", text: "Account"
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
    get users_path
    assert_select "title", full_title("All users")
    get user_path(@user)
    assert_select "title", full_title(@user.name)
    get edit_user_path
    assert_select "title", full_title("Edit user")
    delete logout_path
    follow_redirect!
    assert_select "title", full_title

    # While logged out
    shared_layout_links
    assert_select "a[href=?]", login_path
    get login_path
    assert_select "title", full_title("Log in")
  end  
end
