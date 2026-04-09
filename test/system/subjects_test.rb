require "application_system_test_case"

class SubjectsTest < ApplicationSystemTestCase
  setup do
    @admin = users(:admin_user)
  end

  test "unauthenticated visit redirects to sign in" do
    visit admin_subjects_url
    assert_current_path new_user_session_path
  end

  test "admin can visit subjects index" do
    sign_in @admin
    visit admin_subjects_url
    assert_selector "h1", text: "Subjects"
    assert_selector "table#subjectsTable"
    assert_text subjects(:math_2023).label
    assert_text subjects(:math_2022).label
  end

  test "subjects index shows speciality names" do
    sign_in @admin
    visit admin_subjects_url
    assert_text specialities(:math_bac).label
  end

  test "admin can create subject with speciality via modal" do
    sign_in @admin
    visit admin_subjects_url

    click_button "New Subject"
    within "#subjectModal" do
      fill_in "subject[label]", with: "Nouveau Sujet"
      fill_in "subject[year]", with: "2024"
      select specialities(:math_bac).label, from: "subject[speciality_ids][]"
      click_button "Save"
    end

    assert_text "Nouveau Sujet"
  end

  test "admin can upload PDF file for subject" do
    sign_in @admin
    visit admin_subjects_url

    click_button "New Subject"
    within "#subjectModal" do
      fill_in "subject[label]", with: "Sujet avec PDF"
      fill_in "subject[year]", with: "2024"
      attach_file "subject[file]", Rails.root.join("test/fixtures/files/sample.pdf")
      click_button "Save"
    end

    assert_text "Sujet avec PDF"
    assert_selector "a", text: "View PDF"
  end

  test "creating subject with blank label shows error in modal" do
    sign_in @admin
    visit admin_subjects_url

    click_button "New Subject"
    within "#subjectModal" do
      fill_in "subject[label]", with: ""
      fill_in "subject[year]", with: "2024"
      click_button "Save"
      assert_selector "#subjectErrors", visible: true
    end
  end

  test "admin can delete subject via confirmation modal" do
    sign_in @admin
    visit admin_subjects_url

    find("button[onclick*=\"confirmSubjectDelete('#{subjects(:math_2022).id}\"]").click
    within "#subjectDeleteModal" do
      click_button "Delete"
    end

    assert_no_text subjects(:math_2022).label
  end

  test "regular user cannot access admin subjects" do
    sign_in users(:regular_user)
    visit admin_subjects_url
    assert_current_path root_path
  end
end
