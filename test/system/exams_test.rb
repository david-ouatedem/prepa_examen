require "application_system_test_case"

class ExamsTest < ApplicationSystemTestCase
  setup do
    @admin = users(:admin_user)
  end

  test "unauthenticated visit redirects to sign in" do
    visit admin_exams_url
    assert_current_path new_user_session_path
  end

  test "admin can visit exams index" do
    sign_in @admin
    visit admin_exams_url
    assert_selector "h1", text: "Exams Management"
    assert_selector "table#examsTable"
    assert_text exams(:bac).label
    assert_text exams(:bts).label
  end

  test "admin can create exam via modal" do
    sign_in @admin
    visit admin_exams_url

    click_button "New Exam"
    within "#examModal" do
      fill_in "exam[label]", with: "Licence"
      fill_in "exam[description]", with: "University degree exam"
      click_button "Save Exam"
    end

    assert_text "Licence"
  end

  test "creating exam with blank label shows error in modal" do
    sign_in @admin
    visit admin_exams_url

    click_button "New Exam"
    within "#examModal" do
      fill_in "exam[label]", with: ""
      click_button "Save Exam"
      assert_selector "#examErrors", visible: true
    end

    assert_equal Subject.count, Subject.count
  end

  test "admin can edit exam via modal" do
    sign_in @admin
    visit admin_exams_url

    find("button[data-exam-label='#{exams(:bts).label}']").click
    within "#examModal" do
      fill_in "exam[label]", with: "Updated Certificate"
      click_button "Save Exam"
    end

    assert_text "Updated Certificate"
    assert_no_text exams(:bts).label
  end

  test "admin can delete exam via confirmation modal" do
    sign_in @admin
    visit admin_exams_url

    find("button[onclick*=\"confirmDelete('#{exams(:bts).id}\"]").click
    within "#deleteModal" do
      click_button "Delete"
    end

    assert_no_text exams(:bts).label
  end

  test "regular user cannot access admin exams" do
    sign_in users(:regular_user)
    visit admin_exams_url
    assert_current_path root_path
  end
end
