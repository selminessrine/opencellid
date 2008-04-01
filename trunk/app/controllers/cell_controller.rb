class CellController < ApplicationController
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @cell_pages, @cells = paginate :cells, :per_page => 10
  end
  def show
    @cell = Cell.find(params[:id])
  end
  def get
    mcc=params[:mcc]
    mnc=params[:mnc]
    lac=params[:lac]
    cellid=params[:cellid]
    @cell=Cell.find_by_mcc_and_mnc_and_lac_and_cellid(mcc,mnc,lac,cellid)
	render :layout=>false
   end
   
   def map
    @cells=Cell.find(:all)
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
