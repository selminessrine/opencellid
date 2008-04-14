require 'config/environment'


def cleanDatabase
  mesures=Mesure.find(:all)
  count=0
  mesures.each do |m|
    count=count+1
    if count%10 ==0 
          puts count.to_s+"..." 
    end
    c=m.cell
    m.mcc=c.mcc
    m.mnc=c.mnc
    m.lac=c.lac
    m.realCellId=c.cellid
    m.save
 end
end

cleanDatabase