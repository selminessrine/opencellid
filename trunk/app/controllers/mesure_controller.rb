class MesureController < ApplicationController



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
    old=Mesure.find_by_lat_and_lon_and_userid_and_cell(params[:lat],params[:lon],userid,@cell)
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
  
   def map
    @mesures=Mesure.find_all_by_cell_id(params[:id])
    if !@mesures then @mesures=[] end
   end
end
