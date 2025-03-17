import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]
  static values = {
    delay: { type: Number, default: 50 }
  }

  connect() {
    this.itemTargets.forEach((item, index) => {
      item.style.opacity = '0'
      item.style.transform = 'translateY(10px)'
      item.style.transition = 'opacity 0.3s, transform 0.3s'

      setTimeout(() => {
        item.style.opacity = '1'
        item.style.transform = 'translateY(0)'
      }, this.delayValue * index)
    })
  }
}
