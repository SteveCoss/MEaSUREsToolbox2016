%function hi_lowAnom 
%filter bad returns from passes based on hi-lo range anomoly

function [out] =  hi_lowAnom(VS,i,AbsHeight)
flaglim=2;
%flags anoms for removal based on flaglim
[hflg,lflg, noflg, meanicg] = anom(VS,i,flaglim,AbsHeight);


%% remove flagged elements of hc
[VS(i).AltDat] = removeanoms(VS,i,hflg,lflg, meanicg,flaglim, AbsHeight);
% VS(i).AltDat.hflg= hflg;
% VS(i).AltDat.lflg=lflg;
% VS(i).AltDat.noflg=noflg;
out=VS(i).AltDat;
            
return