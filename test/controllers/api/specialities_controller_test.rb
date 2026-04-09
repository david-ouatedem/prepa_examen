require "test_helper"

class Api::SpecialitiesControllerTest < ActionDispatch::IntegrationTest
  test "returns all specialities with no params" do
    get api_specialities_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal Speciality.count, json.length
  end

  test "filters by exam_id" do
    get api_specialities_url, params: { exam_id: exams(:bac).id }
    json = JSON.parse(response.body)
    assert_equal 2, json.length
    labels = json.map { |s| s["label"] }
    assert_includes labels, "Mathématiques"
    assert_includes labels, "Physique"
    refute_includes labels, "Informatique"
  end

  test "response only includes id and label keys" do
    get api_specialities_url
    json = JSON.parse(response.body)
    first = json.first
    assert first.key?("id")
    assert first.key?("label")
    refute first.key?("description")
    refute first.key?("exam_id")
  end

  test "nonexistent exam_id returns empty array" do
    get api_specialities_url, params: { exam_id: SecureRandom.uuid }
    json = JSON.parse(response.body)
    assert_empty json
  end
end
