class MeasureController < ApplicationController



  def add
    logger.info "Will add Measure..."
    begin
      if params[:user]==nil
        user=User.find_by_apiKey(params[:key])
        params[:user]=user.login
      end      
      measure=Measure.createMeasure(params) 
    rescue =>e
       logger.error e
       @error="Invalid API KEY"
    end
      
      render :layout=>false
  end
  
  
   def map
    @map=true
    @measures=Measure.find_all_by_cell_id(params[:id])
    @cell=Cell.find(params[:id])
    if !@measures then @measures=[] end
   end
end
