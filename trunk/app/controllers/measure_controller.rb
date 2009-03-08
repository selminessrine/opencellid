class MeasureController < ApplicationController


  # List all measures created by a user...
  def list
    begin
     user=User.find_by_apiKey(params[:key],:limit=>200)
     if user     
      @measures=Measure.find_all_by_userid(user.id)
     else
        @error="API Key not know....";
     end
    rescue =>e
       @error=e
    end
     if params[:fmt]=="csv"
		headers['Content-Type'] = "text/plain" 
       render(:action=>"listCsv",:layout=>false)
     else
       render(:layout=>false)
     end
  end
  
  # delete a meseaure created by a user...
  def delete
  
    logger.info "Will delete a Measure..."
    begin
      if params[:user]==nil
        user=User.find_by_apiKey(params[:key])
        params[:user]=user.login
      end      
      
      measure=Measure.find(params[:id])
      if(measure.userid==user.id)
         measure.delete
      else
         @error="Error, this measure does not belongs to you"
      end
    rescue =>e
       @error=e
    end
    render :layout=>false
  end
  
  def add
    logger.info "Will add Measure..."
    begin
      if params[:user]==nil
        user=User.find_by_apiKey(params[:key])
		if !user
		   raise "No user found with this API key"
		end
        params[:user]=user.login
      end

      if((params[:lat].to_f==0)||(params[:lon].to_f==0))
         @error="one of the two coordinate is null, which means probably an error..."
      elsif((params[:mcc].to_i==0)||(params[:mnc].to_i==0))
         @error="mcc or mnc is null, which means probably an error..."
      else
         @measure=Measure.createMeasure(params) 
      end
      
      
    rescue =>e
       logger.error e
       @error=e
          
    end
      
      render :layout=>false
  end
  
  def upload
  end
	#
   # upload set of measures
   def uploadCsv 
   line=0;
    if params[:user]==nil
        user=User.find_by_apiKey(params[:key])
		if !user
		   raise "No user found with this API key"
		end
        params[:user]=user.login
    end
	 
#     file=StringIO.new(params[:upload]['datafile'].read);
     file=StringIO.new(params[:datafile].read);
	 
	fields=file.gets.split(",")
	lang=[]
	line+=1
  
  while l=file.gets do
	line+=1
    ref=""
    idx=0
    vals=l.split(",")
    res=[]
	arr={}
	i=0
    vals.each do |e|
      e.strip!
      if e[0]==34 then
        e=e[1,e.size-2]
      end
	  res<<e
	  arr[fields[i].to_sym]=e
	  i=i+1
    end
    vals=res
	@measures=[]
	@errors=[]
	
    if vals[1]!="-1" and vals.size>2
		begin
			m=Measure.createMeasure(arr);
			@measures<<m
		rescue => e
			@errors<<e.to_s+" line:"+line.to_s+" "+l
		end
    end
  end
  render (:text =>" Added "+@measures.size.to_s+" Errors:"+@errors.to_s)
end


   def map
    @map=true
    @measures=Measure.find_all_by_cell_id(params[:id])
    @cell=Cell.find(params[:id])
    if !@measures then @measures=[] end
   end
end
