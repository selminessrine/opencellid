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
    m=Mesure.createMesure({:mcc=>vals[1],:mnc=>vals[2],:lac=>vals[3],:cellid=>vals[4],:lon=>vals[7],:lat=>vals[8],:signal=>vals[5],:mesured_at=>Time.at(vals[6].to_i),:user=>"gsmloc.org"});
    puts m.to_s
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
    vals=l.split(";")
    o=Operators.new({:mcc=>vals[0],:mnc=>vals[1],:name=>vals[2],:status=>vals[3]});
    o.save
    puts o.to_s
  end
end


importOperators "c:\\tmp\\countries.csv"
