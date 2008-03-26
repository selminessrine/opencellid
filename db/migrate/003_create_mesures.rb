class CreateMesures < ActiveRecord::Migration
  def self.up
    create_table :mesures do |t|
      t.column :lat,       :float, :default=>0.0
      t.column :lon,       :float , :default=>0.0
      t.column :cell_id,       :integer
      t.column :created_at,                :datetime
    end
  end

  def self.down
    drop_table :mesures
  end
end
