require "test_helper"

class SubjectFilteringWorkflowTest < ActionDispatch::IntegrationTest
  test "home controller and API agree on subjects for same speciality filter" do
    get root_url, params: { speciality_id: specialities(:math_bac).id }
    html_subject_ids = assigns(:subjects).map(&:id).sort

    get api_subjects_url, params: { speciality_id: specialities(:math_bac).id }
    api_subject_ids = JSON.parse(response.body).map { |s| s["id"] }.sort

    assert_equal html_subject_ids, api_subject_ids,
      "Home controller and API should return the same subjects for the same speciality_id filter"
  end

  test "API year filter narrows results correctly" do
    get api_subjects_url, params: { year: "2023" }
    year_2023_ids = JSON.parse(response.body).map { |s| s["id"] }

    get api_subjects_url, params: { year: "2022" }
    year_2022_ids = JSON.parse(response.body).map { |s| s["id"] }

    assert_empty year_2023_ids & year_2022_ids,
      "No subject should appear in both 2023 and 2022 filter results"
  end

  test "API exam filter followed by speciality filter narrows results" do
    get api_specialities_url, params: { exam_id: exams(:bac).id }
    bac_speciality_ids = JSON.parse(response.body).map { |s| s["id"] }

    bac_speciality_ids.each do |spec_id|
      get api_subjects_url, params: { speciality_id: spec_id }
      subjects_json = JSON.parse(response.body)
      subjects_json.each do |subject|
        db_subject = Subject.find(subject["id"])
        belongs_to_bac = db_subject.specialities.any? { |sp| sp.exam_id == exams(:bac).id }
        assert belongs_to_bac,
          "Subject #{subject['label']} should belong to a bac speciality"
      end
    end
  end
end
