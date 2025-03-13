import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static values = {
    apiKey: String,
    marker: Object,
    markerImageUrl: String
  }

  constructor(...args) {
    super(...args)
    this.lastLocation = null
    this.locationFilter = { weight: 0.3 } // fluidness
    this.accuracyCircleVisible = true
    this.lastRouteUpdate = 0
    this.isCenteringMap = false
    this.positionBuffer = [] // buffer pour lisser la position
    this.lastUpdateTime = 0
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue;

    this.map = new mapboxgl.Map({
      container: this.element,
      style: 'mapbox://styles/mapbox/streets-v11',
      center: [this.markerValue.lng, this.markerValue.lat],
      zoom: 14
    });

    this.map.addControl(new mapboxgl.NavigationControl());

    this.map.on('load', () => {
      this.#addPatientMarker();
      this.#startRealTimeNavigation();
    });
  }

  disconnect() {
    if (this.watchId) {
      navigator.geolocation.clearWatch(this.watchId);
    }

    if (this.map) {
      this.map.remove();
    }
  }

  #addPatientMarker() {
    const el = document.createElement('div');
    el.className = 'marker';
    el.style.backgroundImage = `url(${this.markerImageUrlValue})`;
    el.style.width = '35px';
    el.style.height = '35px';
    el.style.backgroundSize = 'cover';

    new mapboxgl.Marker(el)
      .setLngLat([this.markerValue.lng, this.markerValue.lat])
      .setPopup(new mapboxgl.Popup().setHTML(this.markerValue.info_window))
      .addTo(this.map);
  }

  #startRealTimeNavigation() {
    // sources
    this.map.addSource('user-position', {
      type: 'geojson',
      data: {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [0, 0]
        }
      }
    });

    // cercle de precision
    this.map.addSource('accuracy-circle', {
      type: 'geojson',
      data: {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [0, 0]
        },
        properties: {
          radiusInMeters: 0
        }
      }
    });

    this.map.addLayer({
      id: 'accuracy-circle-layer',
      type: 'circle',
      source: 'accuracy-circle',
      paint: {
        'circle-radius': [
          'interpolate', ['linear'], ['zoom'],
          10, ['/', ['get', 'radiusInMeters'], 100],
          20, ['/', ['get', 'radiusInMeters'], 2]
        ],
        'circle-color': 'rgba(0, 124, 191, 0.2)',
        'circle-stroke-width': 1,
        'circle-stroke-color': 'rgba(0, 124, 191, 0.6)'
      }
    });

    this.map.addLayer({
      id: 'user-position-layer',
      type: 'circle',
      source: 'user-position',
      paint: {
        'circle-radius': 8,
        'circle-color': '#007cbf',
        'circle-stroke-width': 2,
        'circle-stroke-color': '#ffffff'
      }
    });

    // itineraire
    this.map.addSource('route', {
      type: 'geojson',
      data: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'LineString',
          coordinates: []
        }
      }
    });

    this.map.addLayer({
      id: 'route-layer',
      type: 'line',
      source: 'route',
      layout: {
        'line-join': 'round',
        'line-cap': 'round'
      },
      paint: {
        'line-color': '#3887be',
        'line-width': 5,
        'line-opacity': 0.75
      }
    });

    if (navigator.geolocation) {
      // premiere loc precise rapide
      navigator.geolocation.getCurrentPosition(
        position => {
          const initialLocation = [position.coords.longitude, position.coords.latitude];
          this.lastLocation = initialLocation;
          this.positionBuffer = Array(5).fill(initialLocation);
          this.#updateUserPosition(initialLocation, position.coords.accuracy);
          this.map.flyTo({
            center: initialLocation,
            zoom: 16,
            duration: 1000
          });
        },
        error => console.error("Erreur de géolocalisation initiale:", error),
        { enableHighAccuracy: true, timeout: 5000, maximumAge: 0 }
      );

      // temps reel
      this.watchId = navigator.geolocation.watchPosition(
        position => {
          const userLocation = [position.coords.longitude, position.coords.latitude];
          const accuracy = position.coords.accuracy;

        // ignorer si maj trop rapide
          if (this.lastUpdateTime && Date.now() - this.lastUpdateTime < 500) {
            return;
          }
          this.lastUpdateTime = Date.now();

          //filtre de lissage
          const filteredLocation = this.#filterLocation(userLocation);

          // adapter avec rafraichissement ecran
          window.requestAnimationFrame(() => {
            this.#updateUserPosition(filteredLocation, accuracy);
          });
        },
        error => {
          console.error("Erreur de géolocalisation:", error);
          alert(`Erreur de géolocalisation: ${error.message}`);
        },
        {
          enableHighAccuracy: true,
          maximumAge: 1000,
          timeout: 15000
        }
      );
    } else {
      alert("La géolocalisation n'est pas prise en charge par votre navigateur.");
    }
  }

  #filterLocation(newLocation) {
    if (!this.lastLocation) {
      this.lastLocation = newLocation;
      this.positionBuffer = Array(5).fill(newLocation); // tampon initialise
      return newLocation;
    }

    // si position trop diff ne pas filtrer
    const distance = this.#calculateDistance(this.lastLocation, newLocation);
    if (distance > 100) {
      this.lastLocation = newLocation;
      this.positionBuffer = Array(5).fill(newLocation);
      return newLocation;
    }

    // ajouter nouvelle position au tampon et retire l'ancienne
    this.positionBuffer.push(newLocation);
    if (this.positionBuffer.length > 5) {
      this.positionBuffer.shift();
    }

    // moyenne ponderee pour affichage
    const weights = [0.1, 0.15, 0.2, 0.25, 0.3];
    let sumLon = 0, sumLat = 0, sumWeights = 0;

    for (let i = 0; i < this.positionBuffer.length; i++) {
      const weight = weights[i] || weights[weights.length - 1];
      sumLon += this.positionBuffer[i][0] * weight;
      sumLat += this.positionBuffer[i][1] * weight;
      sumWeights += weight;
    }

    // lisser position
    const smoothedPosition = [
      sumLon / sumWeights,
      sumLat / sumWeights
    ];

    this.lastLocation = smoothedPosition;
    return smoothedPosition;
  }

  #calculateDistance(point1, point2) {
    // convertir degres en radians
    const toRad = value => value * Math.PI / 180;

    const lon1 = toRad(point1[0]);
    const lat1 = toRad(point1[1]);
    const lon2 = toRad(point2[0]);
    const lat2 = toRad(point2[1]);

    // calculer la distance
    const R = 6371000;

    // formule de Haversine
    const dLat = lat2 - lat1;
    const dLon = lon2 - lon1;
    const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
              Math.cos(lat1) * Math.cos(lat2) *
              Math.sin(dLon/2) * Math.sin(dLon/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

    return R * c;
  }

  #updateUserPosition(userLocation, accuracy) {
    console.log("Position mise à jour:", userLocation, "Précision:", accuracy);

    const userPositionSource = this.map.getSource('user-position');
    if (userPositionSource) {
      userPositionSource.setData({
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: userLocation
        }
      });
    }

    const accuracySource = this.map.getSource('accuracy-circle');
    if (accuracySource && this.accuracyCircleVisible) {
      accuracySource.setData({
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: userLocation
        },
        properties: {
          radiusInMeters: accuracy
        }
      });
    }

    if (this.map && !this.isCenteringMap) {
      if (Math.random() > 0.82) {
        this.isCenteringMap = true;

        this.map.easeTo({
          center: userLocation,
          duration: 1800,
          easing: (t) => {
            return t * (2 - t);
          }
        });

        setTimeout(() => {
          this.isCenteringMap = false;
        }, 2000);
      }
    }

    // mise a jour de l'itineraire moins frequente
    if (!this.lastRouteUpdate || Date.now() - this.lastRouteUpdate > 10000) {
      this.#getDirections(userLocation);
      this.lastRouteUpdate = Date.now();
    }
  }

  #getDirections(userLocation) {
    const patientLocation = [this.markerValue.lng, this.markerValue.lat];
    const url = `https://api.mapbox.com/directions/v5/mapbox/driving/${userLocation[0]},${userLocation[1]};${patientLocation[0]},${patientLocation[1]}?steps=true&geometries=geojson&language=fr&access_token=${mapboxgl.accessToken}`;

    fetch(url)
      .then(response => response.json())
      .then(data => {
        if (data.routes && data.routes.length > 0) {
          const route = data.routes[0];
          const coordinates = route.geometry.coordinates;

          this.map.getSource('route').setData({
            type: 'Feature',
            properties: {},
            geometry: {
              type: 'LineString',
              coordinates: coordinates
            }
          });

          this.#displayInstructions(route.legs[0].steps);
        }
      })
      .catch(error => {
        console.error("Erreur lors de la récupération de l'itinéraire:", error);
      });
  }

  #displayInstructions(steps) {
    let instructionsContainer = document.getElementById('route-instructions');

    if (!instructionsContainer) {
      instructionsContainer = document.createElement('div');
      instructionsContainer.id = 'route-instructions';
      instructionsContainer.className = 'container p-3 mt-3 border rounded';
      this.element.parentNode.insertBefore(instructionsContainer, this.element.nextSibling);
    }

    let html = '<h5>Instructions de navigation:</h5><ol>';

    steps.forEach(step => {
      let instruction = step.maneuver.instruction;
      let distance = step.distance;
      let distanceText = distance >= 1000
        ? `${(distance / 1000).toFixed(1)} km`
        : `${Math.round(distance)} m`;

      html += `<li>${instruction} (${distanceText})</li>`;
    });

    html += '</ol>';
    instructionsContainer.innerHTML = html;
  }
}
