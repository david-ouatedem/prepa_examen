import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="subjects"
export default class extends Controller {
    static targets = ["exam", "speciality", "year", "list"]

    async loadSpecialities() {
        const examId = this.examTarget.value;
        this.specialityTarget.innerHTML = '<option value="">-- Choisir une spécialité --</option>';
        this.specialityTarget.disabled = true;

        if (!examId) return;

        try {
            const res = await fetch(`/api/specialities.json?exam_id=${examId}`);
            const data = await res.json();

            if (data.length) {
                data.forEach(s => {
                    this.specialityTarget.innerHTML += `<option value="${s.id}">${s.label}</option>`;
                });
                this.specialityTarget.disabled = false;
            }
        } catch (err) {
            console.error("Erreur chargement spécialités:", err);
        }
    }

    async fetchSubjects() {
        const examId = this.examTarget.value;
        const specialityId = this.specialityTarget.value;
        const year = this.yearTarget.value;

        if (!examId || !specialityId) {
            alert("Veuillez choisir un examen et une spécialité.");
            return;
        }

        const params = new URLSearchParams();
        if (examId) params.append("exam_id", examId);
        if (specialityId) params.append("speciality_id", specialityId);
        if (year) params.append("year", year);

        try {
            const res = await fetch(`/api/subjects.json?${params.toString()}`);
            const subjects = await res.json();

            if (!subjects.length) {
                this.listTarget.innerHTML = `<div class="alert alert-info mt-4 text-center">Aucun sujet trouvé.</div>`;
                return;
            }

            this.listTarget.innerHTML = `
        <div class="row g-3 mt-4">
          ${subjects.map(subject => `
            <div class="col-md-6 col-lg-4">
              <div class="card shadow-sm h-100">
                <div class="card-body">
                  <h5 class="card-title">${subject.label}</h5>
                  <p class="card-text text-muted">${subject.description || 'Aucune description.'}</p>
                  <p class="text-muted"><strong>Année:</strong> ${subject.year || 'Non spécifiée'}</p>
                  ${subject.file_url ?
                `<a href="${subject.file_url}" target="_blank" class="btn btn-outline-secondary btn-sm">Voir PDF</a>
                     <a href="${subject.file_url}" download class="btn btn-primary btn-sm ms-2">Télécharger</a>` :
                `<span class="text-muted">Aucun fichier disponible</span>`}
                </div>
              </div>
            </div>
          `).join('')}
        </div>
      `;
        } catch (err) {
            console.error("Erreur recherche:", err);
            alert("Une erreur est survenue.");
        }
    }
}
