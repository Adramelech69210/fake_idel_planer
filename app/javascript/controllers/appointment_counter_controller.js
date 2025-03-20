import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["counter"]

  connect() {
    this.updateCounter()
  }

  updateCounter(event) {
    const newDate = event?.detail?.day || this.element.dataset.currentDay

    fetch(`/appointments/count?day=${newDate}`)
      .then(response => response.json())
      .then(data => {
        this.counterTarget.innerHTML = `
          <span class="count-number">${data.count}</span>
          rendez-vous ${data.count > 0 ? "prévus" : "prévu"} ce jour
        `
      })
  }
}
