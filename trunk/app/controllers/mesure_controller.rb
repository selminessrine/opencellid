class MesureController < ApplicationController



  def add
    logger.info "Will add mesure..."
    begin
      if params[:user]==nil
        user=User.find_by_apiKey(params[:key])
        params[:user]=user.login
      end      
      mesure=Mesure.createMesure(params) 
    rescue =>e
       logger.error e
       @error="Invalid API KEY"
    end
      
      render :layout=>false
  end
  
  
   def map
    @mesures=Mesure.find_all_by_cell_id(params[:id])
    if !@mesures then @mesures=[] end
   end
end
