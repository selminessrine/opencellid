class CreateCells < ActiveRecord::Migration
  def self.up
    create_table :cells do |t|
      t.column :lat,       :float, :default=>0.0
      t.column :lon,       :float , :default=>0.0
      t.column :mcc, :integer 
      t.column :mnc, :integer 
      t.column :range,     :integer , :default =>0
      t.column :nbSamples, :integer , :default=>0
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
    end
  end

  def self.down
    drop_table :cells
  end
end
