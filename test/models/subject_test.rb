require "test_helper"

class SubjectTest < ActiveSupport::TestCase
  # Validations

  test "label presence validation" do
    subject = Subject.new(year: 2023)
    refute subject.valid?
    assert_includes subject.errors[:label], "can't be blank"
  end

  test "year presence validation" do
    subject = Subject.new(label: "Test Subject")
    refute subject.valid?
    assert_includes subject.errors[:year], "can't be blank"
  end

  test "valid without attached file" do
    subject = Subject.new(label: "Test Subject", year: 2023)
    assert subject.valid?
  end

  test "file content type rejects non-pdf" do
    subject = subjects(:math_2023)
    subject.file.attach(
      io: StringIO.new("fake content"),
      filename: "test.png",
      content_type: "image/png"
    )
    refute subject.valid?
    assert subject.errors[:file].any?
  end

  test "file content type accepts pdf" do
    subject = subjects(:math_2023)
    subject.file.attach(
      io: File.open(Rails.root.join("test/fixtures/files/sample.pdf")),
      filename: "sample.pdf",
      content_type: "application/pdf"
    )
    assert subject.valid?
  end

  # Subject.filter

  test "filter by speciality_id returns matching subjects" do
    results = Subject.filter(speciality_id: specialities(:math_bac).id)
    assert_includes results, subjects(:math_2023)
    assert_includes results, subjects(:math_2022)
    refute_includes results, subjects(:physics_2023)
    refute_includes results, subjects(:info_2023)
  end

  test "filter by exam_id returns all subjects under that exam" do
    results = Subject.filter(exam_id: exams(:bac).id)
    assert_includes results, subjects(:math_2023)
    assert_includes results, subjects(:math_2022)
    assert_includes results, subjects(:physics_2023)
    refute_includes results, subjects(:info_2023)
  end

  test "filter by year returns only matching year" do
    results = Subject.filter(year: "2023")
    assert_includes results, subjects(:math_2023)
    assert_includes results, subjects(:physics_2023)
    assert_includes results, subjects(:info_2023)
    refute_includes results, subjects(:math_2022)
  end

  test "filter combined speciality_id and year returns exactly one result" do
    results = Subject.filter(
      speciality_id: specialities(:math_bac).id,
      year: "2023"
    )
    assert_equal 1, results.count
    assert_includes results, subjects(:math_2023)
  end

  test "filter combined exam_id and year" do
    results = Subject.filter(exam_id: exams(:bac).id, year: "2022")
    assert_equal 1, results.count
    assert_includes results, subjects(:math_2022)
  end

  test "filter with no params returns all subjects" do
    results = Subject.filter({})
    assert_equal Subject.count, results.count
  end

  test "filter returns distinct results" do
    # math_2023 belongs to math_bac; filtering by bac exam should not duplicate it
    results = Subject.filter(exam_id: exams(:bac).id)
    assert_equal results.count, results.map(&:id).uniq.count
  end

  test "filter with nonexistent speciality_id returns empty" do
    results = Subject.filter(speciality_id: SecureRandom.uuid)
    assert_empty results
  end

  test "filter with nonexistent exam_id returns empty" do
    results = Subject.filter(exam_id: SecureRandom.uuid)
    assert_empty results
  end
end
