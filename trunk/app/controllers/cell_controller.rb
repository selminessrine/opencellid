class CellController < ApplicationController
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
  def index
    list
    render :action => 'list'
  end

  def list
    if params[:mcc] then
      cond="mcc="+params[:mcc]
    end    
    @cell_pages, @cells = paginate :cells, :conditions=>cond,:order=>"id desc",:per_page => 100
  end
  
  def listKml
    if params[:mcc] then
      cond="mcc="+params[:mcc]
    end
    limit=200
    if params[:limit] then limit=params[:limit] end
    @cells=Cell.find(:all,:limit=>limit,:conditions=>cond,:order=>"id desc")
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
      if cellid
        cell=Cell.find_by_mcc_and_mnc_and_lac_and_cellid(mcc,mnc,lac,cellid)
      else
        cells=Cell.find_all_by_mcc_and_mnc_and_lac(mcc,mnc,lac)
        cell=Cell.computeAverage(cells)
      end
    else
      cell=Cell.find_by_mcc_and_mnc_and_cellid(mcc,mnc,cellid)
    end
   end
   
  def get
    @cell=getACell params
    if( params[:fmt]==nil || params[:fmt]=="xml" ) 
     	render :layout=>false
    else
      if @cell
        render :text=> @cell.lat+","+@cell.lon
      else
        render :text=>"error: cell not fond"
      end
    end
   end

  def getMeasures
    @cell=getACell params
	render :layout=>false
   end
   
   def map
      @map=true
      if params[:id] 
        @title="View cells... "
        @cells=[Cell.find(params[:id])]
      else
        @title="latest  200 cells"
        @cells=Cell.find(:all,:limit=>200,:order=>"id desc")
      end
   end
  
  #
  # Return Point in a selected area
  #
  def getInArea
    max=params[:max]||100
    if params[:BBOX]
      bbox=params[:BBOX].split(',')
      r=Rect.new bbox[0].to_f,bbox[1].to_f,bbox[2].to_f,bbox[3].to_f
    else
      r=Rect.new -180.to_f,-90.to_f,180.to_f,90.to_f
    end
    @cells=Cell.find_by_sql("SELECT * from cells where lat>="+r.minLat.to_s+" and lat<="+r.maxLat.to_s+" and lon>="+r.minLon.to_s+" and lon<="+r.maxLon.to_s+" LIMIT 200")
     if params[:type]=="xml"
       render(:action=>"showXml",:layout=>false)
     else
       render(:action=>"listKml",:layout=>false)
     end
  end
  
   
   def stats
    # Last found cells
    # 
    @lastCells=Cell.find(:all,:limit=>200,:order=>"id desc")
    # 
    # Total number of cells:
    @totalCells=Measure.find_by_sql("SELECT count(*) as res from cells")[0].attributes["res"].to_i
    # Total number of samples:
    @totalMeasures=Measure.find_by_sql("SELECT count(*) as res from measures")[0].attributes["res"].to_i
    # List of mcc/nmc
    @mcc=Cell.find_by_sql("SELECT * from cells group by mcc")
    @mnc=Cell.find_by_sql("SELECT * from cells group by mnc")
    @countries=[]
    @mcc.each do |c|
      begin
        countrie=Country.find(c.mcc)
        @countries<<countrie
      rescue
      end
    end
   end
   
   
end
