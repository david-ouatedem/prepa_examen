require "application_system_test_case"

class SpecialitiesTest < ApplicationSystemTestCase
  setup do
    @admin = users(:admin_user)
  end

  test "unauthenticated visit redirects to sign in" do
    visit admin_specialities_url
    assert_current_path new_user_session_path
  end

  test "admin can visit specialities index" do
    sign_in @admin
    visit admin_specialities_url
    assert_selector "h1", text: "Specialities Management"
    assert_text specialities(:math_bac).label
    assert_text specialities(:info_bts).label
  end

  test "specialities index shows exam column" do
    sign_in @admin
    visit admin_specialities_url
    assert_text exams(:bac).label
    assert_text exams(:bts).label
  end

  test "admin can create speciality via modal" do
    sign_in @admin
    visit admin_specialities_url

    click_button "New Speciality"
    within "#specialityModal" do
      fill_in "speciality[label]", with: "Chimie"
      select exams(:bac).label, from: "speciality[exam_id]"
      click_button "Save Speciality"
    end

    assert_text "Chimie"
  end

  test "creating speciality without exam shows error in modal" do
    sign_in @admin
    visit admin_specialities_url

    click_button "New Speciality"
    within "#specialityModal" do
      fill_in "speciality[label]", with: "No Exam"
      click_button "Save Speciality"
      assert_selector "#specialityErrors", visible: true
    end
  end
end
