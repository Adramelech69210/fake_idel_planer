import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calendar"
export default class extends Controller {
  static targets = ["overlay", "overlayFilter"]

  open() {
    this.overlayTarget.classList.add("active")
    this.overlayFilterTarget.classList.add("active")

  }

  close() {

    this.overlayTarget.classList.remove("active")
    this.overlayFilterTarget.classList.add("hidden")

    setTimeout(() => {
      this.overlayFilterTarget.classList.remove("active", "hidden")
    }, 200);    t


  }
}
