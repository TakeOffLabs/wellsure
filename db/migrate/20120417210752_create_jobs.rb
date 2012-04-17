class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.text :description
      t.string :pickup
      t.string :dropoff
      t.float :pickup_lat
      t.float :pickup_lng
      t.float :dropoff_lat
      t.float :dropoff_lng

      t.timestamps
    end
  end
end
