import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["line"]

  connect() {
    if (this.hasLineTarget) {
      this.updateTimeIndicator()
      this.interval = setInterval(() => this.updateTimeIndicator(), 60000)
    }
  }

  disconnect() {
    if (this.interval) clearInterval(this.interval)
  }

  updateTimeIndicator() {
    if (!this.hasLineTarget) return
    const now = new Date()
    const hours = now.getHours()
    const minutes = now.getMinutes()

    if (hours >= 6 && hours < 20) {
      const minutesSince6h = (hours - 6) * 60 + minutes - 58
      this.lineTarget.style.top = `calc(${minutesSince6h}px + 9.5rem)`
      this.lineTarget.style.display = "block"
    } else {
      this.lineTarget.style.display = "none"
    }
  }
}
