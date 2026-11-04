const defaultLat = 20.9374, defaultLng = 77.7796;
let map, marker;
function initMap(){
  if(!document.getElementById("map")) return;
  map = L.map("map").setView([defaultLat, defaultLng], 13);
  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",{maxZoom:19,attribution:"© OpenStreetMap contributors"}).addTo(map);
  marker = L.marker([defaultLat,defaultLng],{draggable:true}).addTo(map);
  updateLocation(defaultLat,defaultLng);
  map.on("click",e=>{marker.setLatLng(e.latlng);updateLocation(e.latlng.lat,e.latlng.lng);});
  marker.on("dragend",()=>{const p=marker.getLatLng();updateLocation(p.lat,p.lng);});
}
function updateLocation(lat,lng){
  const a=document.getElementById("latitude"), b=document.getElementById("longitude");
  if(a) a.value=lat.toFixed(6); if(b) b.value=lng.toFixed(6);
}
function locateMe(){
  if(!navigator.geolocation){alert("Your browser does not support location.");return;}
  navigator.geolocation.getCurrentPosition(pos=>{
    const {latitude,longitude}=pos.coords;
    map.setView([latitude,longitude],15); marker.setLatLng([latitude,longitude]); updateLocation(latitude,longitude);
  },()=>alert("Location permission was not granted. You can click the map instead."));
}
document.addEventListener("DOMContentLoaded",initMap);
