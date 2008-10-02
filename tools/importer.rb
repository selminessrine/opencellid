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


importCsv "c:\\tmp\\cells.csv"
