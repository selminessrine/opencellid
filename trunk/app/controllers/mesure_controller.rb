class MesureController < ApplicationController



  def add
    mesure=Mesure.createMesure(params) 
  end
  
  
   def map
    @mesures=Mesure.find_all_by_cell_id(params[:id])
    if !@mesures then @mesures=[] end
   end
end
