document.addEventListener("DOMContentLoaded", function() {
  const editableFields = document.querySelectorAll("[contenteditable=true]");

  editableFields.forEach(field => {
    field.addEventListener("blur", function() {
      const patientId = this.dataset.patientId;
      const fieldName = this.dataset.field;
      const newValue = this.textContent;

      fetch(`/patients/${patientId}`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({ patient: { [fieldName]: newValue } })
      })
      .then(response => {
        if (response.ok) {
          console.log("Modification enregistrée !");
        } else {
          console.error("Erreur lors de la modification.");
        }
      })
      .catch(error => {
        console.error("Erreur :", error);
      });
    });
  });
});
