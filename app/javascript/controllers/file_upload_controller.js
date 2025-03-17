import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  handleFiles() {
    const files = this.inputTarget.files
    this.previewTarget.innerHTML = ""

    if (files.length > 0) {
      Array.from(files).forEach(file => {
        const fileItem = document.createElement("div")
        fileItem.classList.add("file-item")

        let iconClass = "fa-file"
        if (file.type.includes("pdf")) {
          iconClass = "fa-file-pdf"
        } else if (file.type.includes("image")) {
          iconClass = "fa-file-image"
        }

        fileItem.innerHTML = `
          <i class="fas ${iconClass} file-icon"></i>
          <span class="file-name">${file.name}</span>
        `

        this.previewTarget.appendChild(fileItem)
      })
    }
  }

}
