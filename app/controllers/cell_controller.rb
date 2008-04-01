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
   
end
