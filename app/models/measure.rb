class Measure < ActiveRecord::Base
  belongs_to :cell
  belongs_to :user

  def Measure.createMeasure params
    mcc=params[:mcc]
    mnc=params[:mnc]
    lat=params[:lat].to_f
    lon=params[:lon].to_f
    lac=params[:lac]
    cellid=params[:cellid]
    username=params[:user]
    extraInfo=params[:extraInfo]
    user=User.find_by_login(username)
    userid=1
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
    old=Measure.find_by_lat_and_lon_and_userid_and_realCellId(lat,lon,userid,@cell.cellid)
    logger.info"old:"+old.inspect+" cell:"+@cell.to_s
    if old==nil
      @measure=Measure.new(:lat=>lat,:lon=>lon,
                         :mcc=>mcc,:mnc=>mnc,:lac=>lac,:realCellId=>cellid,
                         :userid=>userid,:extraInfo=>extraInfo,:signal=>params[:signal])
      @measure.cell=@cell
      @measure.save
      @cell.nbSamples=@cell.nbSamples+1
	  @cell.needsComputation=true
#      @cell.computePos
      @cell.save
    else
      @measure=old
      logger.info "measurement already here..."
    end
    return @measure
  end

  def delete
     cell=self.cell
     logger.info "nb measures in cell:"+cell.nbSamples.to_s
     cell.nbSamples=cell.nbSamples-1
     cell.save
     if cell.nbSamples==0 
        cell.destroy
        logger.info "destorying cell"
     end
     self.destroy
  end
  
  
end
