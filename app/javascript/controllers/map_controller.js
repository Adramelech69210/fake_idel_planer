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

    //overlay map
    this.directionsPanel = this.element.querySelector('.map-directions-panel')
    this.directionsSteps = this.element.querySelector('.directions-steps')
    this.durationInfo = this.element.querySelector('.duration-info')

    //attends que la map soit chargee
    this.map.on('load', () => {
      this.addMarker()
      this.setupGeolocation()
      this.addRouteLayer()
    })
  }

  disconnect() {
    if (this.watchId) navigator.geolocation.clearWatch(this.watchId)
    if (this.map) this.map.remove()
  }

  //vue plein ecran
  toggleFullscreenDirections(event) {
    event.preventDefault()

    this.element.classList.toggle('fullscreen')

    const isFullscreen = this.element.classList.contains('fullscreen')

    if (isFullscreen) {
      //empeche le scroll du body quand on est en fullscreen
      document.body.style.overflow = 'hidden'

      this.element.style.width = '100vw !important'
      this.element.style.height = '100vh !important'
      this.element.style.margin = '0 !important'
      this.element.style.position = 'fixed'
      this.element.style.top = '0'
      this.element.style.left = '0'
      this.element.style.zIndex = '9999'

      if (this.userLocation) {
        this.getDirections(this.userLocation)
      }
    } else {

      document.body.style.overflow = ''

      this.element.style = ""
      this.element.style.width = '100%'
      this.element.style.height = '350px'
    }

    setTimeout(() => {
      this.map.resize()
      if (this.userLocation) {
        this.map.flyTo({ center: this.userLocation, duration: 1000 })
      }
    }, 100)
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

    //centre la carte si nécessaire
    if (!this.element.classList.contains('fullscreen') && Math.random() > 0.8) {
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

  //maj de displayInstructions
  displayInstructions(steps) {
    let html = ''

    steps.forEach(step => {
      const distance = step.distance >= 1000 ?
        `${(step.distance / 1000).toFixed(1)} km` :
        `${Math.round(step.distance)} m`

      //détermine 'icône à utiliser en fonction du type de direction
      let icon = 'arrow-right'
      if (step.maneuver.type.includes('turn')) {
        if (step.maneuver.modifier.includes('right')) icon = 'arrow-right'
        if (step.maneuver.modifier.includes('left')) icon = 'arrow-left'
      }
      if (step.maneuver.type === 'depart') icon = 'play'
      if (step.maneuver.type === 'arrive') icon = 'location-dot'

      html += `
        <div class="step">
          <span class="step-icon"><i class="fas fa-${icon}"></i></span>
          <span class="step-instruction">${step.maneuver.instruction}</span>
          <span class="step-distance">${distance}</span>
        </div>
      `
    })

    this.directionsSteps.innerHTML = html
  }

//maj de displayDuration
displayDuration(seconds) {
  //arrondir au supérieur
  const minutes = Math.ceil(seconds / 60);

  //afficher seulement les minutes
  if (minutes < 60) {
    this.durationInfo.textContent = `${minutes} min`;
  } else {
    //pour les trajets de plus d'une heure
    const hours = Math.floor(minutes / 60);
    const remainingMinutes = minutes % 60;
    this.durationInfo.textContent = `${hours} h ${remainingMinutes > 0 ? remainingMinutes + ' min' : ''}`;
  }
}

}
