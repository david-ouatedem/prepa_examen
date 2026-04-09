require "test_helper"

class AdminAuthenticationFlowTest < ActionDispatch::IntegrationTest
  test "unauthenticated user is redirected to sign in when hitting admin" do
    get admin_exams_url
    assert_redirected_to new_user_session_path
  end

  test "regular user cannot access admin after login" do
    post user_session_url, params: {
      user: { email: "user@example.com", password: "password123" }
    }
    follow_redirect!

    get admin_exams_url
    assert_redirected_to root_path
    assert_equal "You are not authorized to access this area.", flash[:alert]
  end

  test "admin can access admin area after login" do
    post user_session_url, params: {
      user: { email: "admin@example.com", password: "password123" }
    }
    follow_redirect!

    get admin_exams_url
    assert_response :success
  end

  test "admin loses access after sign out" do
    sign_in users(:admin_user)
    get admin_exams_url
    assert_response :success

    delete destroy_user_session_url
    follow_redirect!

    get admin_exams_url
    assert_redirected_to new_user_session_path
  end

  test "all admin resources are protected" do
    [ admin_exams_url, admin_specialities_url, admin_subjects_url ].each do |url|
      get url
      assert_redirected_to new_user_session_path,
        "Expected #{url} to redirect unauthenticated user to sign in"
    end
  end

  test "all admin resources reject regular users" do
    sign_in users(:regular_user)
    [ admin_exams_url, admin_specialities_url, admin_subjects_url ].each do |url|
      get url
      assert_redirected_to root_path,
        "Expected #{url} to redirect regular user to root"
    end
  end
end
