function [hflg,lflg, noflg,meanicg] = anom(VS,i,flaglim,AbsHeight)
for j=1:length(VS(i).AltDat.ci)
    ic=VS(i).AltDat.c==VS(i).AltDat.ci(j);
    ig=VS(i).AltDat.iGood;
    icg=ic&ig;
    if ~isempty(VS(i).AltDat.h(icg))
        hcmid_max(j)=nanmax(VS(i).AltDat.h(icg));
        hcmid_min(j)=nanmin(VS(i).AltDat.h(icg));
        icglength(j)=length(VS(i).AltDat.h(icg));
    else
        hcmid_max(j)=nan;
        hcmid_min(j)=nan;
         icglength(j)=nan;
    end
end
range=abs(hcmid_max-hcmid_min);
refrange=nanmedian(range);


hanom=abs(hcmid_max-refrange);
lanom=abs(hcmid_min-refrange);
%% mark anoms for removal based on 2* threshold
% for k=1:length(hanom);
%     if range(k) > flaglim *refrange;
%         if hanom(k)> lanom(k);
%             hflg(k)=1;
%             noflg(k)=0;
%             lflg(k)=0;
%         else if lanom(k)>hanom(k);
%                 hflg(k)=0;
%                 noflg(k)=0;
%                 lflg(k)=1;
%                 
%             end
%         end
%     else
%         hflg(k)=0;
%         noflg(k)=1;
%         lflg(k)=0;
%     end
% end
%% flag by range, but remove by closest to DEM
for k=1:length(hanom);
    if range(k) > flaglim * refrange;
        if abs(AbsHeight- hcmid_max(k))> abs(AbsHeight- hcmid_min(k));
            hflg(k)=1;
            noflg(k)=0;
            lflg(k)=0;
        else if abs(AbsHeight- hcmid_max(k))< abs(AbsHeight- hcmid_min(k));
                hflg(k)=0;
                noflg(k)=0;
                lflg(k)=1;
                
            end
        end
    else
        hflg(k)=0;
        noflg(k)=1;
        lflg(k)=0;
    end
end
meanicg=round( nanmean(icglength));
return