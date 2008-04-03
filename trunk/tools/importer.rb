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
    m=Mesure.createMesure({:mcc=>vals[1],:mnc=>vals[2],:lac=>vals[3],:cellid=>vals[4],:lat=>vals[7],:lon=>vals[8],:signal=>vals[5],:mesured_at=>Time.at(vals[6].to_i),:user=>"gsmloc.org"});
    puts m.to_s
  end
end


importCsv "c:\\tmp\\cells"
