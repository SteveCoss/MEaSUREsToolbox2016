%LEVEL3 takes VS and adds L3 to AltDat so to create gridded level three
%data
function VS=LEVEL3(VS)

VS.AltDat.L3.LonLat= [VS.AltDat.lon  VS.AltDat.lat] ;%position
VS.AltDat.L3.h= [VS.AltDat.lon  VS.AltDat.lat VS.AltDat.h] ;%height
VS.AltDat.L3.sig0= [VS.AltDat.lon  VS.AltDat.lat VS.AltDat.sig0];%Sig0
VS.AltDat.L3.PK= [VS.AltDat.lon  VS.AltDat.lat VS.AltDat.PK];%PK
VS.AltDat.L3.cycle= [VS.AltDat.lon  VS.AltDat.lat VS.AltDat.c];%cycle
VS.AltDat.L3.tAll= [VS.AltDat.lon  VS.AltDat.lat VS.AltDat.tAll];%time
VS.AltDat.L3.iGoodH= [VS.AltDat.lon  VS.AltDat.lat VS.AltDat.iGoodH];%heightfilter
VS.AltDat.L3.IceFlag= [VS.AltDat.lon  VS.AltDat.lat VS.AltDat.IceFlag];%ice flag
VS.AltDat.L3.iGood= [VS.AltDat.lon  VS.AltDat.lat VS.AltDat.iGood];%allfilter

return
