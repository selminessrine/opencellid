class Mesure < ActiveRecord::Base
  belongs_to :cell
  belongs_to :user

  def Mesure.createMesure params
    mcc=params[:mcc]
    mnc=params[:mnc]
    lat=params[:lat]
    lon=params[:lon]
    lac=params[:lac]
    cellid=params[:cellid]
    username=params[:user]
    extraInfo=params[:extraInfo]
    user=User.find_by_login(username)
    userId=1
    if user
      userid=user.id
    end
    logger.info "New mesure....params:"+mcc.to_s+" mnc:"+mnc.to_s+" lac:"+lac.to_s+" cellid:"+cellid.to_s

    @cell=Cell.find_by_mcc_and_mnc_and_lac_and_cellid(mcc,mnc,lac,cellid)
    if !@cell
      @cell=Cell.new(:mcc=>mcc,:mnc=>mnc,:lac=>lac,:cellid=>cellid)
    end
    #
    # Check if there was already a mesure with these value (in that case, we do not add it)
    # 
    old=Mesure.find_by_lat_and_lon_and_userid_and_cell_id(lat,lon,userid,@cell)
    if old!=nil
      @mesure=Mesure.new(:lat=>params[:lat],:lon=>params[:lon],:userid=>userid,:extraInfo=>extraInfo,:mesured_at=>params[:mesured_at],:signal=>params[:signal])
      @mesure.cell=@cell
      @mesure.save
      @cell.nbSamples=@cell.nbSamples+1
      @cell.computePos
      @cell.save
    else
      logger.info "mesurement already here..."
    end
    return @mesure
  end

end
