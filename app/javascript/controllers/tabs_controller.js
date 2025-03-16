import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tabpane"]

  connect() {
    if (this.tabpaneTargets.length > 0) {
      this.tabpaneTargets[0].classList.add('active')
    }
  }

  switch(event) {
    const tabId = event.currentTarget.dataset.tabsParam

    const allButtons = this.element.querySelectorAll('.tab-btn')
    allButtons.forEach(btn => btn.classList.remove('active'))
    event.currentTarget.classList.add('active')

    this.tabpaneTargets.forEach(pane => {
      if (pane.dataset.tabId === tabId) {
        pane.classList.add('active')
      } else {
        pane.classList.remove('active')
      }
    })
  }
}
