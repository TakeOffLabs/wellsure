# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.wellsure = window.wellsure or {}
((jobs, $) ->
  jobs.map = undefined
  jobs.pickup_markers = []
  jobs.dropoff_markers = []
  jobs.rectangle = undefined
  jobs.active_lines = []
  jobs.colors = ["black", "red", "green", "blue", "yellow"]
  jobs.crtColor = 0
  
  jobs.drawLineFrom = (m) ->
    jobs.clearAllLines()
    for i in [0.. (jobs.pickup_markers.length-1)]
      if jobs.pickup_markers[i] == m || jobs.dropoff_markers[i] == m
        jobs.drawLine(jobs.pickup_markers[i], jobs.dropoff_markers[i])
  
  jobs.drawLine = (m1, m2) ->
    jobs.active_lines.push new google.maps.Polyline
      path: [m1.getPosition(), m2.getPosition()]
      strokeColor: jobs.colors[jobs.crtColor]
      map: jobs.map
    jobs.crtColor++
    jobs.crtColor = 0 if jobs.crtColor == jobs.colors.length
  
  jobs.drawAllLines = ->
    jobs.clearAllLines()
    for i in [0..(jobs.pickup_markers.length-1)]
      if jobs.rectangle.bounds.contains(jobs.pickup_markers[i].getPosition()) && jobs.rectangle.bounds.contains(jobs.dropoff_markers[i].getPosition())
        jobs.drawLine(jobs.pickup_markers[i], jobs.dropoff_markers[i])
    false
  
  jobs.clearAllLines = ->
    for line in jobs.active_lines
      line.setMap(null)
    jobs.active_lines = []
    
  jobs.initMap = ->
    options =
      center: new google.maps.LatLng(51.507222, -0.1275)
      zoom: 12
      mapTypeId: google.maps.MapTypeId.ROADMAP
      panControl: false
      zoomControl: false
      scaleControl: false
      streetViewControl: false
      overviewMapControl: false
      mapTypeControl: false
      draggable: false
      minZoom: 12
      maxZoom: 12
      
    jobs.map = new google.maps.Map $("#map_canvas")[0], options
    for job in gon.jobs
      pick = jobs.addPickupMarker(job)
      drop = jobs.addDropoffMarker(job)
      
      google.maps.event.addListener pick, 'mouseover', ->
        jobs.drawLineFrom(@)
      
      google.maps.event.addListener drop, 'mouseover', ->
        jobs.drawLineFrom(@)
    
    jobs.addEditableRectangle()
    jobs.listJobs()
    
    $("a.draw_all_lines").live 'click', jobs.drawAllLines
      
  jobs.pinImage = (color) -> 
    new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + color,
      new google.maps.Size(21, 34), new google.maps.Point(0,0), new google.maps.Point(10, 34))
      
  jobs.addPickupMarker = (job) ->
    m_pickup = new google.maps.Marker
      position: new google.maps.LatLng(job.pickup_lat, job.pickup_lng)
      map: jobs.map
      title: job.title
      
    contentString = "<div class='job'><div class='title'><strong>Title: </strong>#{job.title}</div>" +
      "<div class='pickup'><strong>Pickup: </strong>#{job.pickup}</div>" +
      "<div class='dropoff'><strong>Drop-off: </strong>#{job.dropoff}</div></div>"
        
    infowindow = new google.maps.InfoWindow
      content: contentString
    
    google.maps.event.addListener m_pickup, 'click', ->
      infowindow.open(jobs.map, m_pickup)
    
    jobs.pickup_markers.push(m_pickup)
    return m_pickup
  
  jobs.addDropoffMarker = (job) ->
    m_dropoff = new google.maps.Marker
      position: new google.maps.LatLng(job.dropoff_lat, job.dropoff_lng)
      map: jobs.map
      title: job.title
      
    contentString = "<div class='job'><div class='title'><strong>Title: </strong>#{job.title}</div>" +
      "<div class='pickup'><strong>Pickup: </strong>#{job.pickup}</div>" +
      "<div class='dropoff'><strong>Drop-off: </strong>#{job.dropoff}</div></div>"
        
    infowindow = new google.maps.InfoWindow
      content: contentString
    
    google.maps.event.addListener m_dropoff, 'click', ->
      infowindow.open(jobs.map, m_dropoff)
    
    jobs.dropoff_markers.push(m_dropoff)
    return m_dropoff
  
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
  
  jobs.colorYellow = (marker) ->
    marker.setIcon jobs.pinImage("FF7F00")
    
  jobs.colorBlue = (marker) ->
    marker.setIcon jobs.pinImage("0E53A7")
    
  jobs.colorLightYellow = (marker) ->
    marker.setIcon jobs.pinImage("FFB873")
    
  jobs.colorLightBlue = (marker) ->
    marker.setIcon jobs.pinImage("4284D3")
    
  jobs.markerRecoloring = ->
    for i in [0..(jobs.pickup_markers.length-1)]
      pickup_in = jobs.rectangle.bounds.contains(jobs.pickup_markers[i].getPosition())
      dropoff_in = jobs.rectangle.bounds.contains(jobs.dropoff_markers[i].getPosition())
      if pickup_in && dropoff_in
        jobs.colorYellow(jobs.pickup_markers[i])
        jobs.colorBlue(jobs.dropoff_markers[i])
      else
        jobs.colorLightYellow(jobs.pickup_markers[i])
        jobs.colorLightBlue(jobs.dropoff_markers[i])
    
  jobs.listJobs = ->
    for job in gon.jobs
      if jobs.inArea(job, jobs.rectangle.getBounds())
        $("li[data-job-id=#{job.id}]").show().removeClass("drop-off-outside")
        if jobs.rectangle.bounds.contains(new google.maps.LatLng(job.pickup_lat, job.pickup_lng)) and !jobs.rectangle.bounds.contains(new google.maps.LatLng(job.dropoff_lat, job.dropoff_lng)) 
          $("li[data-job-id=#{job.id}]").show().addClass("drop-off-outside")
      else
        $("li[data-job-id=#{job.id}]").hide()
    jobs.markerRecoloring()
    
) window.wellsure.jobs = window.wellsure.jobs or {}, jQuery