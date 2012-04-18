# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

Job.destroy_all
Job.create(title: "Red Chair", pickup: "Golden Jubilee Bridge, London", dropoff: "British Museum, London", description: "Job #1 description")
Job.create(title: "Blue Chair", pickup: "Millennium Bridge, London", dropoff: "10 Downing Street, London", description: "Job #2 description")
Job.create(title: "Green Chair", pickup: "Tower Bridge, London", dropoff: "Buckingham Palace, London", description: "Job #3 description")
Job.create(title: "Yellow Chair", pickup: "Heathrow Airport, London", dropoff: "Lambeth, London", description: "Job #4 description")