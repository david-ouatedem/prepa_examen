require "test_helper"

class Admin::SpecialitiesControllerTest < ActionDispatch::IntegrationTest
  # Unauthenticated access

  test "GET index redirects unauthenticated user to sign in" do
    get admin_specialities_url
    assert_redirected_to new_user_session_path
  end

  # Regular user access

  test "GET index redirects regular user to root with alert" do
    sign_in users(:regular_user)
    get admin_specialities_url
    assert_redirected_to root_path
    assert_equal "You are not authorized to access this area.", flash[:alert]
  end

  # Admin access

  test "GET index returns success and assigns exams and specialities" do
    sign_in users(:admin_user)
    get admin_specialities_url
    assert_response :success
    assert_not_nil assigns(:specialities)
    assert_not_nil assigns(:exams)
  end

  test "POST create with valid params redirects to index" do
    sign_in users(:admin_user)
    assert_difference "Speciality.count", 1 do
      post admin_specialities_url, params: {
        speciality: { label: "Chimie", exam_id: exams(:bac).id }
      }
    end
    assert_redirected_to admin_specialities_path
    assert_equal "Speciality was successfully created.", flash[:notice]
  end

  test "POST create with valid params JSON returns created speciality" do
    sign_in users(:admin_user)
    post admin_specialities_url, params: {
      speciality: { label: "Chimie JSON", exam_id: exams(:bac).id }
    }, as: :json
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "Chimie JSON", json["label"]
  end

  test "POST create without exam_id returns unprocessable_entity" do
    sign_in users(:admin_user)
    post admin_specialities_url, params: {
      speciality: { label: "No Exam" }
    }, as: :json
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert json["errors"]["exam"].present?
  end

  test "POST create without label returns unprocessable_entity" do
    sign_in users(:admin_user)
    post admin_specialities_url, params: {
      speciality: { exam_id: exams(:bac).id }
    }, as: :json
    assert_response :unprocessable_entity
  end

  test "PATCH update with valid params redirects to index" do
    sign_in users(:admin_user)
    patch admin_speciality_url(specialities(:math_bac)), params: {
      speciality: { label: "Updated Math" }
    }
    assert_redirected_to admin_specialities_path
    assert_equal "Updated Math", specialities(:math_bac).reload.label
  end

  test "PATCH update JSON returns updated speciality" do
    sign_in users(:admin_user)
    patch admin_speciality_url(specialities(:math_bac)), params: {
      speciality: { label: "Updated JSON" }
    }, as: :json
    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal "Updated JSON", json["label"]
  end

  test "DELETE destroy redirects to index" do
    sign_in users(:admin_user)
    assert_difference "Speciality.count", -1 do
      delete admin_speciality_url(specialities(:info_bts))
    end
    assert_redirected_to admin_specialities_path
    assert_equal "Speciality was successfully destroyed.", flash[:notice]
  end

  test "DELETE destroy JSON returns no_content" do
    sign_in users(:admin_user)
    delete admin_speciality_url(specialities(:info_bts)), as: :json
    assert_response :no_content
    assert_raises(ActiveRecord::RecordNotFound) { specialities(:info_bts).reload }
  end
end
