class Cell < ActiveRecord::Base
  has_many :Measures
  
  def computePos
    lat=0.0
    lon=0.0
    self.measures.each do |mes|
      lat+=mes.lat
      lon+=mes.lon
    end
    self.lat=lat/self.Measures.size
    self.lon=lon/self.Measures.size
    self.save
  end
  
  def operator
    Operators.find_by_mcc_and_mnc(self.mcc,self.mnc)
  end
  
  def operatorName
    begin
    Operators.find_by_mcc_and_mnc(self.mcc,self.mnc).name
      
    rescue
      "not know"
    end
  end
  
  def country
     begin
          Country.find(self.mcc)
      rescue
      end
  end
end
