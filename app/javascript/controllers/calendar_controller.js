import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calendar"
export default class extends Controller {
  static targets = ["overlay"]

  open() {
    this.overlayTarget.classList.add("active")
  }
  close() {
    this.overlayTarget.classList.remove("active")
  }
}
