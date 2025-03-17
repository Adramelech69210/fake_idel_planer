import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["startDate", "endDate", "textArea"];

  generateReport() {
    const startDate = this.startDateTarget.value;
    const endDate = this.endDateTarget.value;

    if (!startDate || !endDate) {
      alert("Veuillez sélectionner une période valide.");
      return;
    }

    fetch(`/reports/generate?start_date=${startDate}&end_date=${endDate}`)
      .then(response => response.json())
      .then(data => {
        this.textAreaTarget.value = data.text;
      })
      .catch(error => console.error("Erreur:", error));
  }
}
