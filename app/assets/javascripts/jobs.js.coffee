# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.wellsure = window.wellsure or {}
((jobs, $) ->
  jobs.map = undefined
  jobs.pickup_markers = []
  jobs.dropoff_markers = []
  jobs.rectangle = undefined
  
  jobs.initMap = ->
    options =
      center: new google.maps.LatLng(51.507222, -0.1275)
      zoom: 12
      mapTypeId: google.maps.MapTypeId.ROADMAP
    jobs.map = new google.maps.Map $("#map_canvas")[0], options
    for job in gon.jobs
      jobs.addPickupMarker(job)
      jobs.addDropoffMarker(job)
    
    jobs.addEditableRectangle()
    jobs.listJobs()
      
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
  
  jobs.addEditableRectangle = ->
    jobs.rectangle = new google.maps.Rectangle
    bounds = new google.maps.LatLngBounds()
    
    bounds.extend(new google.maps.LatLng(51.53, -0.10))
    bounds.extend(new google.maps.LatLng(51.48, -0.14))
    
    rectOptions =
      editable: true
      strokeColor: "#FF0000"
      strokeOpacity: 0.8
      strokeWeight: 2
      fillColor: "#FF0000"
      fillOpacity: 0.35
      map: jobs.map
      bounds: bounds
    jobs.rectangle.setOptions(rectOptions)
    google.maps.event.addListener jobs.rectangle, "bounds_changed", ->
      jobs.listJobs()
  
  jobs.inArea = (job, bound) ->
    bound.contains(new google.maps.LatLng(job.pickup_lat, job.pickup_lng))
    
  jobs.listJobs = ->
    for job in gon.jobs
      if jobs.inArea(job, jobs.rectangle.getBounds())
        console.log job.id
    console.log "listing jobs"
    
) window.wellsure.jobs = window.wellsure.jobs or {}, jQuery