import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "overlayFilter"]
  static values = {
    previousView: { type: String, default: "day" }
  }

  connect() {
    console.log("Calendar controller connected");
    const params = new URLSearchParams(window.location.search);
    const currentView = params.get('display');
    if (currentView && currentView !== 'month') {
      this.previousViewValue = currentView;
    }
  }

  open() {
    this.overlayTarget.classList.add("active");
    this.overlayFilterTarget.classList.add("active");
  }

  close() {
    this.overlayTarget.classList.remove("active");
    this.overlayFilterTarget.classList.add("hidden");

    setTimeout(() => {
      this.overlayFilterTarget.classList.remove("active", "hidden");
    }, 200);
  }

  toggleMonthView(event) {
    event.preventDefault();
    const params = new URLSearchParams(window.location.search);
    const currentDisplay = params.get('display') || 'day';

    if (currentDisplay === 'month') {
      params.set('display', this.previousViewValue);
    } else {
      this.previousViewValue = currentDisplay;
      params.set('display', 'month');
    }

    if (params.has('jd')) {
      const jd = params.get('jd');
      params.set('jd', jd);
    }

    window.location.href = window.location.pathname + '?' + params.toString();
  }
}
