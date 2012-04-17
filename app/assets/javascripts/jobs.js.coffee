# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.wellsure = window.wellsure or {}
((jobs, $) ->
  jobs.map = undefined
  jobs.pickup_markers = []
  jobs.dropoff_markers = []
  
  jobs.initMap = ->
    options =
      center: new google.maps.LatLng(51.507222, -0.1275)
      zoom: 12
      mapTypeId: google.maps.MapTypeId.ROADMAP
    jobs.map = new google.maps.Map $("#map_canvas")[0], options
    for job in gon.jobs
      jobs.addPickupMarker(job)
      jobs.addDropoffMarker(job)
      
  jobs.pinImage = (color) -> 
    new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + color,
      new google.maps.Size(21, 34), new google.maps.Point(0,0), new google.maps.Point(10, 34))
      
  jobs.addPickupMarker = (job) ->
    m_pickup = new google.maps.Marker
      position: new google.maps.LatLng(job.pickup_lat, job.pickup_lng)
      map: jobs.map
      icon: jobs.pinImage("0000FF")
    jobs.pickup_markers.push(m_pickup)
  
  jobs.addDropoffMarker = (job) ->
    m_dropoff = new google.maps.Marker
      position: new google.maps.LatLng(job.dropoff_lat, job.dropoff_lng)
      map: jobs.map
      icon: jobs.pinImage("FFFF00")
    jobs.dropoff_markers.push(m_dropoff)
    
) window.wellsure.jobs = window.wellsure.jobs or {}, jQuery