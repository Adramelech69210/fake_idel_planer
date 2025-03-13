import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static values = { apiKey: String, marker: Object, markerImageUrl: String }

  connect() {
    //initialise la carte
    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
      container: this.element,
      style: 'mapbox://styles/acetonemapbox/cm7x93w99016u01sb6a5q9c5u',
      center: [this.markerValue.lng, this.markerValue.lat],
      zoom: 14
    })

    this.map.addControl(new mapboxgl.NavigationControl())

    //attends que la carte soit chargée
    this.map.on('load', () => {
      this.addMarker()
      this.setupGeolocation()
      this.addRouteLayer() //layer itineraire
    })

    //double clic pour fullscreen
    this.element.addEventListener('dblclick', this.toggleFullscreen.bind(this))
  }

  disconnect() {
    //nettoyage
    if (this.watchId) navigator.geolocation.clearWatch(this.watchId)
    if (this.map) this.map.remove()
  }

  //marqueur bruno
  addMarker() {
    const el = document.createElement('div')
    el.className = 'marker'
    el.style.backgroundImage = `url(${this.markerImageUrlValue})`
    el.style.width = '35px'
    el.style.height = '35px'
    el.style.backgroundSize = 'cover'

    new mapboxgl.Marker(el)
      .setLngLat([this.markerValue.lng, this.markerValue.lat])
      .setPopup(new mapboxgl.Popup().setHTML(this.markerValue.info_window))
      .addTo(this.map)

    //marqueur idel
    const userEl = document.createElement('div')
    userEl.className = 'user-position-marker'
    userEl.style.width = '15px'
    userEl.style.height = '15px'
    userEl.style.backgroundColor = '#007cbf'
    userEl.style.borderRadius = '50%'

    this.userMarker = new mapboxgl.Marker(userEl)
      .setLngLat([0, 0])
      .addTo(this.map)
  }

  //layer itineraire
  addRouteLayer() {
    this.map.addSource('route', {
      type: 'geojson',
      data: {
        type: 'Feature',
        properties: {},
        geometry: { type: 'LineString', coordinates: [] }
      }
    })

    this.map.addLayer({
      id: 'route-layer',
      type: 'line',
      source: 'route',
      layout: { 'line-join': 'round', 'line-cap': 'round' },
      paint: { 'line-color': '#3887be', 'line-width': 5, 'line-opacity': 0.75 }
    })
  }

  //config geoloc
  setupGeolocation() {
    if (!navigator.geolocation) return alert("Géolocalisation non supportée.")

    //obtenir position initiale
    navigator.geolocation.getCurrentPosition(
      position => {
        const userLocation = [position.coords.longitude, position.coords.latitude]
        this.updatePosition(userLocation)
        this.map.flyTo({ center: userLocation, zoom: 16 })
        this.getDirections(userLocation)
      },
      error => alert(`Erreur de géolocalisation: ${error.message}`)
    )

    //check changement de position
    this.lastUpdate = 0
    this.watchId = navigator.geolocation.watchPosition(
      position => {
        //mise a jour 2 fois par seconde
        if (Date.now() - this.lastUpdate < 500) return

        this.lastUpdate = Date.now()
        const userLocation = [position.coords.longitude, position.coords.latitude]
        this.updatePosition(userLocation)

        //mise a jour itineraire toutes les 10 secondes
        if (!this.lastRouteUpdate || Date.now() - this.lastRouteUpdate > 10000) {
          this.getDirections(userLocation)
          this.lastRouteUpdate = Date.now()
        }
      },
      error => console.error("Erreur de géolocalisation:", error)
    )
  }

  //maj position idel
  updatePosition(location) {
    this.userLocation = location
    this.userMarker.setLngLat(location)

    //centre la carte
    if (!this.isFullscreen && Math.random() > 0.8) {
      this.map.easeTo({ center: location, duration: 1000 })
    }
  }

  //calcul et affichage itineraire
  getDirections(userLocation) {
    const destination = [this.markerValue.lng, this.markerValue.lat]
    const url = `https://api.mapbox.com/directions/v5/mapbox/driving/${userLocation[0]},${userLocation[1]};${destination[0]},${destination[1]}?steps=true&geometries=geojson&language=fr&access_token=${mapboxgl.accessToken}`

    fetch(url)
      .then(response => response.json())
      .then(data => {
        if (data.routes && data.routes.length > 0) {
          const route = data.routes[0]

          //affiche l'itineraire sur la carte
          this.map.getSource('route').setData({
            type: 'Feature',
            properties: {},
            geometry: { type: 'LineString', coordinates: route.geometry.coordinates }
          })

          //affiche les instructions et la duree
          this.displayInstructions(route.legs[0].steps)
          this.displayDuration(route.duration)
        }
      })
      .catch(error => console.error("Erreur lors de la récupération de l'itinéraire:", error))
  }

  //affiche les etapes de l'itineraire
  displayInstructions(steps) {
    let container = document.getElementById('route-instructions')
    if (!container) {
      container = document.createElement('div')
      container.id = 'route-instructions'
      container.className = 'container p-3 mt-3 border rounded'
      this.element.parentNode.insertBefore(container, this.element.nextSibling)
    }

    //genere le html pour affichage
    let html = '<h5>Instructions de navigation:</h5><ol>'
    steps.forEach(step => {
      const distance = step.distance >= 1000 ?
        `${(step.distance / 1000).toFixed(1)} km` :
        `${Math.round(step.distance)} m`
      html += `<li>${step.maneuver.instruction} (${distance})</li>`
    })
    html += '</ol>'
    container.innerHTML = html
  }

  //affiche la duree du trajet
  displayDuration(seconds) {
    let container = document.getElementById('route-duration')
    if (!container) {
      container = document.createElement('div')
      container.id = 'route-duration'
      container.className = 'container p-3 mt-3 border rounded'
      this.element.parentNode.insertBefore(container, this.element.nextSibling)
    }

    const minutes = Math.floor(seconds / 60)
    const remainingSeconds = Math.floor(seconds % 60)
    container.innerHTML = `<h5>Durée du trajet : ${minutes} min ${(remainingSeconds < 10 ? '0' : '') + remainingSeconds} sec</h5>`
  }

  //plein ecran
  toggleFullscreen(event) {
    event.preventDefault()
    event.stopPropagation()

    this.isFullscreen = !this.isFullscreen

    if (this.isFullscreen) {
      this.originalStyle = {
        width: this.element.style.width,
        height: this.element.style.height,
        position: this.element.style.position
      }

      this.element.style.position = 'fixed'
      this.element.style.top = '0'
      this.element.style.left = '0'
      this.element.style.width = '100vw'
      this.element.style.height = '100vh'
      this.element.style.zIndex = '9999'

      document.getElementById('route-instructions')?.classList.add('d-none')
      document.getElementById('route-duration')?.classList.add('d-none')
    } else {
      Object.assign(this.element.style, this.originalStyle)

      document.getElementById('route-instructions')?.classList.remove('d-none')
      document.getElementById('route-duration')?.classList.remove('d-none')
    }

    this.map.resize()
    if (this.userLocation) {
      this.map.flyTo({ center: this.userLocation, duration: 1000 })
    }
  }
}
