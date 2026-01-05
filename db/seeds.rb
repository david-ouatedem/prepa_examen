# Create admin user
puts "Creating admin user..."
admin = User.find_or_initialize_by(email: "admin@admin.com")
if admin.new_record?
  admin.password = "Password@1234"
  admin.password_confirmation = "Password@1234"
  admin.role = :admin
  admin.save!
  puts "Admin user created: admin@admin.com (role: admin)"
else
  # Update existing admin user to have admin role
  unless admin.admin?
    admin.update(role: :admin)
    puts "Admin user role updated to admin: admin@admin.com"
  else
    puts "Admin user already exists: admin@admin.com (role: admin)"
  end
end

# Helper to create a simple PDF file
def create_dummy_pdf(title, year)
  require 'stringio'

  # Simple PDF content (minimal valid PDF)
  pdf_content = <<~PDF
    %PDF-1.4
    1 0 obj
    << /Type /Catalog /Pages 2 0 R >>
    endobj
    2 0 obj
    << /Type /Pages /Kids [3 0 R] /Count 1 >>
    endobj
    3 0 obj
    << /Type /Page /Parent 2 0 R /Resources 4 0 R /MediaBox [0 0 612 792] /Contents 5 0 R >>
    endobj
    4 0 obj
    << /Font << /F1 << /Type /Font /Subtype /Type1 /BaseFont /Helvetica >> >> >>
    endobj
    5 0 obj
    << /Length 80 >>
    stream
    BT
    /F1 24 Tf
    100 700 Td
    (#{title} - #{year}) Tj
    ET
    endstream
    endobj
    xref
    0 6
    0000000000 65535 f
    0000000009 00000 n
    0000000058 00000 n
    0000000115 00000 n
    0000000214 00000 n
    0000000304 00000 n
    trailer
    << /Size 6 /Root 1 0 R >>
    startxref
    433
    %%EOF
  PDF

  StringIO.new(pdf_content)
end

puts "\n=== Creating Exams ==="

# Create Exams
exams_data = [
  { label: "Baccalauréat", description: "Examen national de fin d'études secondaires" },
  { label: "Licence", description: "Diplôme universitaire de premier cycle (Bac+3)" },
  { label: "Master", description: "Diplôme universitaire de second cycle (Bac+5)" },
  { label: "Concours d'entrée", description: "Concours d'admission aux grandes écoles" }
]

exams = {}
exams_data.each do |exam_data|
  exam = Exam.find_or_create_by!(label: exam_data[:label]) do |e|
    e.description = exam_data[:description]
  end
  exams[exam.label] = exam
  puts "  ✓ #{exam.label}"
end

puts "\n=== Creating Specialities ==="

# Create Specialities for each exam
specialities_data = {
  "Baccalauréat" => [
    { label: "Série S (Sciences)", description: "Baccalauréat scientifique" },
    { label: "Série L (Littéraire)", description: "Baccalauréat littéraire" },
    { label: "Série ES (Économique et Social)", description: "Baccalauréat économique et social" },
    { label: "Série STMG", description: "Sciences et Technologies du Management et de la Gestion" }
  ],
  "Licence" => [
    { label: "Informatique", description: "Licence en sciences informatiques" },
    { label: "Mathématiques", description: "Licence en mathématiques" },
    { label: "Physique", description: "Licence en physique" },
    { label: "Économie", description: "Licence en sciences économiques" },
    { label: "Droit", description: "Licence en droit" }
  ],
  "Master" => [
    { label: "Intelligence Artificielle", description: "Master en IA et Machine Learning" },
    { label: "Génie Logiciel", description: "Master en génie logiciel" },
    { label: "Cybersécurité", description: "Master en sécurité informatique" },
    { label: "Data Science", description: "Master en science des données" },
    { label: "Finance", description: "Master en finance" }
  ],
  "Concours d'entrée" => [
    { label: "École Polytechnique", description: "Concours X" },
    { label: "Centrale-Supélec", description: "Concours Centrale" },
    { label: "Mines-Ponts", description: "Concours Mines-Ponts" },
    { label: "ENS", description: "Concours École Normale Supérieure" }
  ]
}

specialities = {}
specialities_data.each do |exam_label, specs|
  exam = exams[exam_label]
  specialities[exam_label] = []

  specs.each do |spec_data|
    spec = Speciality.find_or_create_by!(label: spec_data[:label], exam: exam) do |s|
      s.description = spec_data[:description]
    end
    specialities[exam_label] << spec
    puts "  ✓ #{exam_label} - #{spec.label}"
  end
end

puts "\n=== Creating Subjects (Exam Papers) ==="

# Create subjects for each speciality
years = [2020, 2021, 2022, 2023, 2024]
subjects_created = 0

specialities.each do |exam_label, specs|
  specs.each do |speciality|
    # Create 2-3 subjects per speciality with different years
    sample_years = years.sample(rand(2..3))

    sample_years.each do |year|
      subject_label = "#{speciality.label} - Session #{year}"

      subject = Subject.find_or_initialize_by(
        label: subject_label,
        year: year
      )

      if subject.new_record?
        subject.description = "Sujet d'examen #{speciality.label} pour l'année #{year}"

        # Attach a dummy PDF
        pdf_file = create_dummy_pdf(subject_label, year)
        subject.file.attach(
          io: pdf_file,
          filename: "#{subject_label.parameterize}-#{year}.pdf",
          content_type: 'application/pdf'
        )

        subject.save!
        subject.specialities << speciality unless subject.specialities.include?(speciality)
        subjects_created += 1
        puts "  ✓ #{subject_label}"
      end
    end
  end
end

puts "\n=== Seed Summary ==="
puts "Exams: #{Exam.count}"
puts "Specialities: #{Speciality.count}"
puts "Subjects: #{Subject.count}"
puts "Admin Users: #{User.count}"
puts "\n✓ Seed completed successfully!"
