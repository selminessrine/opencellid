class Measure < ActiveRecord::Base
  belongs_to :cell
  belongs_to :user

  def Measure.createMeasure params
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
    logger.info "New Measure....params:"+mcc.to_s+" mnc:"+mnc.to_s+" lac:"+lac.to_s+" cellid:"+cellid.to_s

    @cell=Cell.find_by_mcc_and_mnc_and_lac_and_cellid(mcc,mnc,lac,cellid)
    if !@cell
      @cell=Cell.new(:mcc=>mcc,:mnc=>mnc,:lac=>lac,:cellid=>cellid)
    end
    #
    # Check if there was already a Measure with these value (in that case, we do not add it)
    # 
    old=Measure.find_by_lat_and_lon_and_userid_and_cell_id(lat,lon,userid,@cell.id)
    logger.info"old:"+old.to_s+" cell:"+@cell.to_s
    if old==nil
      @measure=Measure.new(:lat=>lat,:lon=>lon,
                         :mcc=>mcc,:mnc=>mnc,:lac=>lac,:realCellId=>cellid,
                         :userid=>userid,:extraInfo=>extraInfo,:measured_at=>params[:measured_at],:signal=>params[:signal])
      @measure.cell=@cell
      @measure.save
      @cell.nbSamples=@cell.nbSamples+1
      @cell.computePos
      @cell.save
    else
      logger.info "measurement already here..."
    end
    return @measure
  end

end
