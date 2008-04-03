class CellController < ApplicationController
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @cell_pages, @cells = paginate :cells, :per_page => 10
  end
  
  def listKml
    @cells=Cell.find(:all)
      response.headers['Content-Type'] = 'application/vnd.google-earth.kml+xml'
  	render :layout=>false
  end
  
  def show
    @cell = Cell.find(params[:id])
  end
  
  def getACell params
    mcc=params[:mcc]
    mnc=params[:mnc]
    lac=params[:lac]
    cellid=params[:cellid]
    if lac 
      cell=Cell.find_by_mcc_and_mnc_and_lac_and_cellid(mcc,mnc,lac,cellid)
    else
      cell=Cell.find_by_mcc_and_mnc_and_cellid(mcc,mnc,cellid)
    end
   end
   
  def get
    @cell=getACell params
	render :layout=>false
   end

  def getMesures
    @cell=getACell params
	render :layout=>false
   end
   
   def map
    @cells=Cell.find(:all)
   end
  
  #
  # Return Point in a selected area
  #
  def getInArea
    max=params[:max]||20
    if params[:bbox]
      bbox=params[:bbox].split(',')
      r=Rect.new bbox[0].to_f,bbox[1].to_f,bbox[2].to_f,bbox[3].to_f
    else
      r=Rect.new -180.to_f,-90.to_f,180.to_f,90.to_f
    end
    map.places.each do
        |place|
        if  (place.isInside? r) && ( max==-1 || (@map.places.size<max) )
          @map.places<<place
       end
     end
     if params[:type]=="xml"
       render(:action=>"showXml",:layout=>false)
     else
       render(:action=>"showKml",:layout=>false)
     end
  end
  
   
   def stats
    # Last found cells
    # 
    @lastCells=Cell.find(:all,:limit=>5)
    # 
    # Total number of cells:
    @totalCells=Mesure.find_by_sql("SELECT count(*) as res from cells")[0].attributes["res"].to_i
    # Total number of samples:
    @totalMesures=Mesure.find_by_sql("SELECT count(*) as res from mesures")[0].attributes["res"].to_i
    # List of mcc/nmc
    @mcc=Cell.find_by_sql("SELECT * from cells group by mcc")
    @mnc=Cell.find_by_sql("SELECT * from cells group by mnc")
   end
   
   
end