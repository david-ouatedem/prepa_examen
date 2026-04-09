require "test_helper"

class ExamTest < ActiveSupport::TestCase
  test "label presence validation" do
    exam = Exam.new(description: "No label")
    refute exam.valid?
    assert_includes exam.errors[:label], "can't be blank"
  end

  test "valid with label" do
    exam = Exam.new(label: "New Exam")
    assert exam.valid?
  end

  test "has many specialities" do
    exam = exams(:bac)
    assert_equal 2, exam.specialities.count
    assert_includes exam.specialities, specialities(:math_bac)
    assert_includes exam.specialities, specialities(:physics_bac)
  end

  test "destroy cascades to specialities" do
    exam = exams(:bts)
    assert_difference "Speciality.count", -1 do
      exam.destroy
    end
  end
end
