import { Controller } from "@hotwired/stimulus";
import mapboxgl from 'mapbox-gl';

export default class extends Controller {
  static values = {
    apiKey: String,
    marker: Object   //Object car ce n'est pas plusieur markers mais un seul
  };

  connect() {
    mapboxgl.accessToken = this.apiKeyValue;

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/acetonemapbox/cm7x93w99016u01sb6a5q9c5u" // definit sur Mapbox
    });

    this.#addMarkerToMap();
    this.#fitMapToMarker();
  }

  #addMarkerToMap() {
    const { lng, lat, info_marker_html, marker_html } = this.markerValue;   //Stimulus a automatiquement créé markerValue en se basant sur l'attribut de données
                                                                            // data-map-marker-value et la définition marker: Object dans static values.

    const popup = new mapboxgl.Popup({
      offset: [10, -25]               // Décalage de 25 pixels vers le haut, et 10 vers la droite, de l'info marker
    }).setHTML(info_marker_html);

    const customMarker = document.createElement("div");
    customMarker.innerHTML = marker_html;

    new mapboxgl.Marker(customMarker)
      .setLngLat([lng, lat])
     // .setPopup(popup)  //desactivation info_marker
      .addTo(this.map);
  }


  #fitMapToMarker() {
    const { lng, lat } = this.markerValue;

    this.map.flyTo({
      center: [lng, lat],
      zoom: 16,
      duration: 4000
    });
  }
}
