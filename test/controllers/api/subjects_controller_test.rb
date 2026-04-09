require "test_helper"

class Api::SubjectsControllerTest < ActionDispatch::IntegrationTest
  test "returns JSON array" do
    get api_subjects_url
    assert_response :success
    assert_equal "application/json", response.media_type
    json = JSON.parse(response.body)
    assert json.is_a?(Array)
  end

  test "sets X-Api-Subjects header to v2" do
    get api_subjects_url
    assert_equal "v2", response.headers["X-Api-Subjects"]
  end

  test "returns all subjects with no params" do
    get api_subjects_url
    json = JSON.parse(response.body)
    assert_equal Subject.count, json.length
  end

  test "filters by speciality_id" do
    get api_subjects_url, params: { speciality_id: specialities(:math_bac).id }
    json = JSON.parse(response.body)
    ids = json.map { |s| s["id"] }
    assert_includes ids, subjects(:math_2023).id
    assert_includes ids, subjects(:math_2022).id
    refute_includes ids, subjects(:physics_2023).id
    refute_includes ids, subjects(:info_2023).id
  end

  test "filters by exam_id" do
    get api_subjects_url, params: { exam_id: exams(:bac).id }
    json = JSON.parse(response.body)
    ids = json.map { |s| s["id"] }
    assert_includes ids, subjects(:math_2023).id
    assert_includes ids, subjects(:math_2022).id
    assert_includes ids, subjects(:physics_2023).id
    refute_includes ids, subjects(:info_2023).id
  end

  test "filters by year" do
    get api_subjects_url, params: { year: "2023" }
    json = JSON.parse(response.body)
    assert json.all? { |s| s["year"] == 2023 }
    ids = json.map { |s| s["id"] }
    refute_includes ids, subjects(:math_2022).id
  end

  test "response shape includes expected keys" do
    get api_subjects_url
    json = JSON.parse(response.body)
    first = json.first
    assert first.key?("id")
    assert first.key?("label")
    assert first.key?("description")
    assert first.key?("year")
    assert first.key?("file_url")
  end

  test "file_url is nil when no file attached" do
    get api_subjects_url, params: { speciality_id: specialities(:math_bac).id }
    json = JSON.parse(response.body)
    subject_json = json.find { |s| s["id"] == subjects(:math_2023).id }
    assert_not_nil subject_json
    assert_nil subject_json["file_url"]
  end

  test "nonexistent speciality_id returns empty array" do
    get api_subjects_url, params: { speciality_id: SecureRandom.uuid }
    json = JSON.parse(response.body)
    assert_empty json
  end

  test "nonexistent exam_id returns empty array" do
    get api_subjects_url, params: { exam_id: SecureRandom.uuid }
    json = JSON.parse(response.body)
    assert_empty json
  end
end
