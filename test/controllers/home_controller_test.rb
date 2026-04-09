require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "GET root returns success" do
    get root_url
    assert_response :success
  end

  test "no params loads all exams specialities and subjects" do
    get root_url
    assert_equal Exam.count, assigns(:exams).count
    assert_equal Speciality.count, assigns(:specialities).count
    assert_equal Subject.count, assigns(:subjects).count
  end

  test "exam_id filter scopes specialities to that exam" do
    get root_url, params: { exam_id: exams(:bac).id }
    assert_response :success
    speciality_ids = assigns(:specialities).map(&:id)
    assert_includes speciality_ids, specialities(:math_bac).id
    assert_includes speciality_ids, specialities(:physics_bac).id
    refute_includes speciality_ids, specialities(:info_bts).id
  end

  test "exam_id filter does not scope subjects" do
    get root_url, params: { exam_id: exams(:bac).id }
    assert_equal Subject.count, assigns(:subjects).count
  end

  test "speciality_id filter scopes subjects" do
    get root_url, params: { speciality_id: specialities(:math_bac).id }
    subject_ids = assigns(:subjects).map(&:id)
    assert_includes subject_ids, subjects(:math_2023).id
    assert_includes subject_ids, subjects(:math_2022).id
    refute_includes subject_ids, subjects(:physics_2023).id
    refute_includes subject_ids, subjects(:info_2023).id
  end

  test "nonexistent speciality_id returns empty subjects" do
    get root_url, params: { speciality_id: SecureRandom.uuid }
    assert_empty assigns(:subjects)
  end
end
