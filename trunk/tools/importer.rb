require 'config/environment'

def importCsv fileName
  file = File.new(fileName)
  fields=file.gets.split(",")
  puts fields
  lang=[]
  
  while l=file.gets do
    puts "Line:"+l
    ref=""
    idx=0
    vals=l.split(",")
    res=[]
    vals.each do |e|
      e.strip!
      if e[0]==34
        e=e[1,e.size-2]
      end
      res<<e
    end
    vals=res
    if vals[1]!="-1"
    
      puts vals
    
      m=Measure.createMeasure({:mcc=>vals[1],:mnc=>vals[0],:lac=>vals[2],:cellid=>vals[3],:lon=>vals[5],:lat=>vals[4],:signal=>vals[6],:user=>"alexbirkett"});
      puts m.to_s
    end
  end
end

def importBase
	total=0
  # measures=Importer.find_all_by_country_code(310,:limit=>100000)
  measures=Importer.find(:all,:limit=>100000)
  measures.each do |newm|
	total+=1
	if total%100==0
		puts "total:"+total.to_s
	end
	if(newm.network_id>0)
			m=Measure.createMeasure({:mnc=>newm.network_id,:mcc=>newm.country_code,:lac=>newm.lac,:cellid=>newm.cell_id,:lon=>newm.lon,:lat=>newm.lat,:user=>"alexbirkett"});
			puts m.to_s
	end
	newm.destroy();
  end
end

def importOperators fileName

  file = File.new(fileName)
  fields=file.gets.split(",")
  puts fields
  lang=[]
  
  while l=file.gets do
    puts "Line:"+l
    ref=""
    idx=0
    vals=l.split(",")
    puts vals
    o=Operators.new({:mcc=>vals[0],:mnc=>vals[1],:name=>vals[2],:status=>vals[3]});
    o.save
    puts o.to_s
  end
end


#importCsv "c:\\tmp\\cells.csv"
i=0
while i<1000
importBase 
i=i+1
end
