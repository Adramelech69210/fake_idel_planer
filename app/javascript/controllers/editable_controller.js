import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field"];
  static values = { url: String, fieldName: String };

  connect() {
    this.fieldTarget.dataset.originalValue = this.fieldTarget.textContent;
  }

  edit() {
    this.fieldTarget.focus();
  }

  update() {
    if (this.fieldTarget.dataset.originalValue !== this.fieldTarget.textContent) {
      const newValue = this.fieldTarget.textContent;

      fetch(this.urlValue, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").getAttribute("content"),
        },
        body: JSON.stringify({ patient: { [this.fieldNameValue]: newValue } }),
      })
      .then(response => {
        if (response.ok) {
          console.log("Champ mis à jour avec succès !");
        } else {
          console.error("Erreur lors de la mise à jour du champ.");
          this.fieldTarget.textContent = this.fieldTarget.dataset.originalValue;
        }
      });
    }
  }
}
