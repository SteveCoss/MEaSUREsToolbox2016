%remove anoms
function [out] = removeanoms(VS,i,hflg,lflg, meanicg,flaglim,AbsHeight)
for z= 1:meanicg-2
    if sum(hflg)+sum(lflg)>0
        for j=1:length(VS(i).AltDat.ci)
            ic=VS(i).AltDat.c==VS(i).AltDat.ci(j);
            ig=VS(i).AltDat.iGood;
            icg=ic&ig;
            if ~isempty(VS(i).AltDat.h(icg))
                if hflg(j)==1;
                    Hdx=find(VS(i).AltDat.h(icg)==max(VS(i).AltDat.h(icg)));
                    dx=find(icg==1);
                    VS(i).AltDat.h(dx(Hdx))=nan;
                else if lflg(j)==1;
                        Hdx=find(VS(i).AltDat.h(icg)==min(VS(i).AltDat.h(icg)));
                        dx=find(icg==1);
                        VS(i).AltDat.h(dx(Hdx))=nan;
                    end
                end
            end
        end
        [hflg,lflg, noflg,meanicg] = anom(VS,i,flaglim,AbsHeight);
    end
end
VS(i).AltDat.hflg=hflg;
VS(i).AltDat.lflg=lflg;

out=VS(i).AltDat;
return

