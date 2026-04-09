require "test_helper"

class Admin::SubjectsControllerTest < ActionDispatch::IntegrationTest
  # Unauthenticated access

  test "GET index redirects unauthenticated user to sign in" do
    get admin_subjects_url
    assert_redirected_to new_user_session_path
  end

  # Regular user access

  test "GET index redirects regular user to root with alert" do
    sign_in users(:regular_user)
    get admin_subjects_url
    assert_redirected_to root_path
    assert_equal "You are not authorized to access this area.", flash[:alert]
  end

  # Admin access

  test "GET index returns success and assigns specialities" do
    sign_in users(:admin_user)
    get admin_subjects_url
    assert_response :success
    assert_not_nil assigns(:specialities)
    assert_not_nil assigns(:subjects)
  end

  test "POST create with valid params redirects to index" do
    sign_in users(:admin_user)
    assert_difference "Subject.count", 1 do
      post admin_subjects_url, params: {
        subject: {
          label: "New Subject",
          year: 2024,
          speciality_ids: [ specialities(:math_bac).id ]
        }
      }
    end
    assert_redirected_to admin_subjects_path
    assert_equal "Subject was successfully created.", flash[:notice]
  end

  test "POST create assigns specialities via HABTM" do
    sign_in users(:admin_user)
    post admin_subjects_url, params: {
      subject: {
        label: "Multi-spec Subject",
        year: 2024,
        speciality_ids: [ specialities(:math_bac).id, specialities(:physics_bac).id ]
      }
    }, as: :json
    assert_response :created
    subject = Subject.last
    assert_equal 2, subject.specialities.count
  end

  test "POST create with PDF file attaches it" do
    sign_in users(:admin_user)
    pdf = fixture_file_upload("sample.pdf", "application/pdf")
    assert_difference "Subject.count", 1 do
      post admin_subjects_url, params: {
        subject: { label: "Subject with PDF", year: 2024, file: pdf }
      }
    end
    assert Subject.last.file.attached?
  end

  test "POST create with non-PDF returns unprocessable_entity" do
    sign_in users(:admin_user)
    fake_png = fixture_file_upload("sample.pdf", "image/png")
    post admin_subjects_url, params: {
      subject: { label: "Bad file", year: 2024, file: fake_png }
    }, as: :json
    assert_response :unprocessable_entity
  end

  test "POST create with invalid params returns unprocessable_entity" do
    sign_in users(:admin_user)
    post admin_subjects_url, params: { subject: { label: "", year: nil } }, as: :json
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert json["errors"].present?
  end

  test "PATCH update with valid params redirects to index" do
    sign_in users(:admin_user)
    patch admin_subject_url(subjects(:math_2023)), params: {
      subject: { label: "Updated Math", year: 2023 }
    }
    assert_redirected_to admin_subjects_path
    assert_equal "Updated Math", subjects(:math_2023).reload.label
  end

  test "PATCH update with valid params JSON returns updated subject" do
    sign_in users(:admin_user)
    patch admin_subject_url(subjects(:math_2023)), params: {
      subject: { label: "Updated via JSON", year: 2023 }
    }, as: :json
    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal "Updated via JSON", json["label"]
  end

  test "DELETE destroy redirects to index" do
    sign_in users(:admin_user)
    assert_difference "Subject.count", -1 do
      delete admin_subject_url(subjects(:math_2022))
    end
    assert_redirected_to admin_subjects_path
  end

  test "DELETE destroy JSON returns no_content" do
    sign_in users(:admin_user)
    delete admin_subject_url(subjects(:math_2022)), as: :json
    assert_response :no_content
    assert_raises(ActiveRecord::RecordNotFound) { subjects(:math_2022).reload }
  end
end
