require "test_helper"

class SpecialityTest < ActiveSupport::TestCase
  test "label presence validation" do
    speciality = Speciality.new(exam: exams(:bac))
    refute speciality.valid?
    assert_includes speciality.errors[:label], "can't be blank"
  end

  test "exam required" do
    speciality = Speciality.new(label: "No Exam")
    refute speciality.valid?
    assert speciality.errors[:exam].any?
  end

  test "belongs to exam" do
    speciality = specialities(:math_bac)
    assert_equal exams(:bac), speciality.exam
  end

  test "habtm subjects" do
    speciality = specialities(:math_bac)
    assert_includes speciality.subjects, subjects(:math_2023)
    assert_includes speciality.subjects, subjects(:math_2022)
    refute_includes speciality.subjects, subjects(:physics_2023)
    refute_includes speciality.subjects, subjects(:info_2023)
  end
end
