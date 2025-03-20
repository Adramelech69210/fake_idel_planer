import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["appointment", "month", "overlayFilter"]
  static values = {
    previousView: { type: String, default: "day" }
  }

  connect() {
    console.log("Calendar controller connected");
    const params = new URLSearchParams(window.location.search);
    const currentView = params.get('display');
    if (currentView) {
      this.previousViewValue = currentView;
    }
  }

  openAppointment() {
    this.appointmentTarget.classList.add("active");
    this.overlayFilterTarget.classList.add("active");
  }

  openMonth() {
    this.monthTarget.classList.add("active");
    this.overlayFilterTarget.classList.add("active");
  }


  close() {
    this.appointmentTarget.classList.remove("active");
    this.monthTarget.classList.remove("active");
    this.overlayFilterTarget.classList.add("hidden");

    setTimeout(() => {
      this.overlayFilterTarget.classList.remove("active", "hidden");
    }, 200);
  }
}
