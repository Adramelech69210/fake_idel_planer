import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon"]

  connect() {
    if (this.hasContentTarget && this.hasIconTarget) {
      this.contentTarget.classList.add('expanded')
      this.iconTarget.style.transform = 'rotate(-180deg)'
    }
  }

  toggle() {
    if (this.hasContentTarget) {
      this.contentTarget.classList.toggle('expanded')
    }

    if (this.hasIconTarget) {
      if (this.contentTarget.classList.contains('expanded')) {
        this.iconTarget.style.transform = 'rotate(-180deg)'
      } else {
        this.iconTarget.style.transform = 'rotate(0deg)'
      }
    }
  }
}
