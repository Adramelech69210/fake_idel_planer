// file_upload_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button", "info"]

  connect() {
    console.log("File upload controller connected")
  }

  triggerFileInput() {
    this.inputTarget.click()
  }

  updateFileInfo() {
    if (this.inputTarget.files.length > 0) {
      this.infoTarget.textContent = `${this.inputTarget.files.length} fichier(s) sélectionné(s)`
    } else {
      this.infoTarget.textContent = 'Aucun fichier sélectionné'
    }
  }
}
