require "test_helper"

class Admin::ExamsControllerTest < ActionDispatch::IntegrationTest
  # Unauthenticated access

  test "GET index redirects unauthenticated user to sign in" do
    get admin_exams_url
    assert_redirected_to new_user_session_path
  end

  test "POST create redirects unauthenticated user to sign in" do
    post admin_exams_url, params: { exam: { label: "New" } }
    assert_redirected_to new_user_session_path
  end

  # Regular user (non-admin) access

  test "GET index redirects regular user to root with alert" do
    sign_in users(:regular_user)
    get admin_exams_url
    assert_redirected_to root_path
    assert_equal "You are not authorized to access this area.", flash[:alert]
  end

  test "POST create redirects regular user to root" do
    sign_in users(:regular_user)
    post admin_exams_url, params: { exam: { label: "New" } }
    assert_redirected_to root_path
  end

  # Admin access

  test "GET index returns success for admin" do
    sign_in users(:admin_user)
    get admin_exams_url
    assert_response :success
  end

  test "POST create with valid params redirects to index" do
    sign_in users(:admin_user)
    assert_difference "Exam.count", 1 do
      post admin_exams_url, params: { exam: { label: "New Exam", description: "Desc" } }
    end
    assert_redirected_to admin_exams_path
    assert_equal "Exam was successfully created.", flash[:notice]
  end

  test "POST create with valid params JSON returns created exam" do
    sign_in users(:admin_user)
    post admin_exams_url,
      params: { exam: { label: "JSON Exam" } },
      as: :json
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "JSON Exam", json["label"]
  end

  test "POST create with invalid params returns unprocessable_entity HTML" do
    sign_in users(:admin_user)
    post admin_exams_url, params: { exam: { label: "" } }
    assert_response :unprocessable_entity
  end

  test "POST create with invalid params JSON returns errors hash" do
    sign_in users(:admin_user)
    post admin_exams_url,
      params: { exam: { label: "" } },
      as: :json
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert json["errors"]["label"].present?
  end

  test "PATCH update with valid params redirects to index" do
    sign_in users(:admin_user)
    patch admin_exam_url(exams(:bac)),
      params: { exam: { label: "Updated Label" } }
    assert_redirected_to admin_exams_path
    assert_equal "Updated Label", exams(:bac).reload.label
  end

  test "PATCH update with valid params JSON returns updated exam" do
    sign_in users(:admin_user)
    patch admin_exam_url(exams(:bac)),
      params: { exam: { label: "Updated JSON" } },
      as: :json
    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal "Updated JSON", json["label"]
  end

  test "PATCH update with invalid params returns unprocessable_entity" do
    sign_in users(:admin_user)
    patch admin_exam_url(exams(:bac)),
      params: { exam: { label: "" } },
      as: :json
    assert_response :unprocessable_entity
  end

  test "DELETE destroy redirects to index with notice" do
    sign_in users(:admin_user)
    assert_difference "Exam.count", -1 do
      delete admin_exam_url(exams(:bts))
    end
    assert_redirected_to admin_exams_path
    assert_equal "Exam was successfully destroyed.", flash[:notice]
  end

  test "DELETE destroy JSON returns no_content" do
    sign_in users(:admin_user)
    delete admin_exam_url(exams(:bts)), as: :json
    assert_response :no_content
    assert_raises(ActiveRecord::RecordNotFound) { exams(:bts).reload }
  end
end
