class MesuresController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @mesure_pages, @mesures = paginate :mesures, :per_page => 10
  end

  def show
    @mesure = Mesure.find(params[:id])
  end

  def new
    @mesure = Mesure.new
  end

  def create
    @mesure = Mesure.new(params[:mesure])
    if @mesure.save
      flash[:notice] = 'Mesure was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @mesure = Mesure.find(params[:id])
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
    logger.info "New mesure....params:"+mcc.to_s+" mnc:"+mnc.to_s+" lac:"+lac.to_s+" cellid:"+cellid.to_s

    @cell=Cell.find_by_mcc_and_mnc_and_lac_and_cellid(mcc,mnc,lac,cellid)
    if !@cell
      @cell=Cell.new(:mcc=>mcc,:mnc=>mnc,:lac=>lac,:cellid=>cellid)
    end
    
    # Check if there was already a mesure with these value (in that case, we do not add it)
    # 
    old=Mesure.find_by_lat_and_lon_and_userid_and_cell_id(params[:lat],params[:lon],userid,@cell.cellid)
    puts "Getting old:"+old.to_s
    if !old
      @mesure=Mesure.new(:lat=>params[:lat],:lon=>params[:lon],:userid=>userid,:extraInfo=>extraInfo)
      @mesure.cell=@cell
      @mesure.save
      @cell.nbSamples=@cell.nbSamples+1
      @cell.computePos
     @cell.save
    else
      logger.info "mesurement already here..."
    end
  end
  
  def update
    @mesure = Mesure.find(params[:id])
    if @mesure.update_attributes(params[:mesure])
      flash[:notice] = 'Mesure was successfully updated.'
      redirect_to :action => 'show', :id => @mesure
    else
      render :action => 'edit'
    end
  end

  def destroy
    Mesure.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
