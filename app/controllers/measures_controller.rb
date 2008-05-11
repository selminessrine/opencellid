class MeasuresController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @measure_pages, @measures = paginate :measures, :per_page => 10
  end

  def show
    @measure = Measure.find(params[:id])
  end

  def new
    @measure = Measure.new
  end

  def create
    @measure = Measure.new(params[:measure])
    if @measure.save
      flash[:notice] = 'Measure was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @measure = Measure.find(params[:id])
  end

  def add
    mcc=params[:mcc]
    mnc=params[:mnc]
    lac=params[:lac]
    cellid=params[:cellid]
    username=params[:user]
   
    user=User.find_by_login(username)
    userId=1
    if user
      userid=user.id
    end
    extraInfo=params[:extraInfo]
    logger.info "New measure....params:"+mcc.to_s+" mnc:"+mnc.to_s+" lac:"+lac.to_s+" cellid:"+cellid.to_s

    @cell=Cell.find_by_mcc_and_mnc_and_lac_and_cellid(mcc,mnc,lac,cellid)
    if !@cell
      @cell=Cell.new(:mcc=>mcc,:mnc=>mnc,:lac=>lac,:cellid=>cellid)
    end
    
    # Check if there was already a Measure with these value (in that case, we do not add it)
    # 
    old=Measure.find_by_lat_and_lon_and_userid_and_cell_id(params[:lat],params[:lon],userid,@cell.cellid)
    puts "Getting old:"+old.to_s
    if !old
      @Measure=Measure.new(:lat=>params[:lat],:lon=>params[:lon],:userid=>userid,:extraInfo=>extraInfo)
      @Measure.cell=@cell
      @Measure.save
      @cell.nbSamples=@cell.nbSamples+1
      @cell.computePos
     @cell.save
    else
      logger.info "Measurement already here..."
    end
  end
  
  def update
    @Measure = Measure.find(params[:id])
    if @Measure.update_attributes(params[:Measure])
      flash[:notice] = 'Measure was successfully updated.'
      redirect_to :action => 'show', :id => @Measure
    else
      render :action => 'edit'
    end
  end

  def destroy
    Measure.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
