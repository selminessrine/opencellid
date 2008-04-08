class Cell < ActiveRecord::Base
  has_many :mesures
  
  def computePos
    lat=0.0
    lon=0.0
    self.mesures.each do |mes|
      lat+=mes.lat
      lon+=mes.lon
    end
    self.lat=lat/self.mesures.size
    self.lon=lon/self.mesures.size
    self.save
  end
  
  def operator
    Operators.find_by_mcc_and_mnc(self.mcc,self.mnc)
  end
  def country
     begin
          Country.find(self.mcc)
      rescue
      end
  end
end
