class Job < ActiveRecord::Base
  
  after_create :coordinates
  
  LEGEND = [["FF7F00", "Pickup in area"],
            ["0E53A7", "Dropoff in area"],
            ["FFB873", "Pickup outside area"],
            ["4284D3", "Dropoff outside area"]]
  
  def coordinates
    gc = Geocoder.search(pickup)
    if gc.length > 0
      self.pickup_lat = gc[0].latitude
      self.pickup_lng = gc[0].longitude
    end
    
    gc = Geocoder.search(dropoff)
    if gc.length > 0
      self.dropoff_lat = gc[0].latitude
      self.dropoff_lng = gc[0].longitude
    end
    
    save
  end
end
