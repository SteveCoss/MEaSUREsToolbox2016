function [altstruct] = inlinecomp(VS,i)
 

if i<2
    %vs being evaluated
   for j=1:length(VS(i).AltDat.ci)
        ic=VS(i).AltDat.c==VS(i).AltDat.ci(j);
        ig=VS(i).AltDat.iGood;
        icg=ic&ig;
        if ~isempty(VS(i).AltDat.h(icg))
        hcmid_max(j)=nanmax(VS(i).AltDat.h(icg));
        hcmid_min(j)=nanmin(VS(i).AltDat.h(icg));
        else
            hcmid_max(j)=nan;
            hcmid_min(j)=nan;
        end
    end
    %vs  above
    for j=1:length(VS(i+1).AltDat.ci)
        ic=VS(i+1).AltDat.c==VS(i+1).AltDat.ci(j);
        ig=VS(i+1).AltDat.iGood;
        icg=ic&ig;
          if ~isempty(VS(i).AltDat.h(icg))
        hchigh_max(j)=nanmax(VS(i).AltDat.h(icg));
        hchigh_min(j)=nanmin(VS(i).AltDat.h(icg));
        else
            hchigh_max(j)=nan;
            hchigh_min(j)=nan;
        end
   end
    
    
else if i<length(VS);
        % lower station
        for j=1:length(VS(i-1).AltDat.ci)
            ic=VS(i-1).AltDat.c==VS(i-1).AltDat.ci(j);
            ig=VS(i-1).AltDat.iGood;
            icg=ic&ig;
              if ~isempty(VS(i).AltDat.h(icg))
        hclow_max(j)=nanmax(VS(i).AltDat.h(icg));
        hclow_min(j)=nanmin(VS(i).AltDat.h(icg));
        else
            hclow_max(j)=nan;
            hclow_min(j)=nan;
        end
        end
        %vs being evaluated
        for j=1:length(VS(i).AltDat.ci)
            ic=VS(i).AltDat.c==VS(i).AltDat.ci(j);
            ig=VS(i).AltDat.iGood;
            icg=ic&ig;
            if ~isempty(VS(i).AltDat.h(icg))
        hcmid_max(j)=nanmax(VS(i).AltDat.h(icg));
        hcmid_min(j)=nanmin(VS(i).AltDat.h(icg));
        else
            hcmid_max(j)=nan;
            hcmid_min(j)=nan;
        end
        end
        %vs being above
        for j=1:length(VS(i+1).AltDat.ci)
            ic=VS(i+1).AltDat.c==VS(i+1).AltDat.ci(j);
            ig=VS(i+1).AltDat.iGood;
            icg=ic&ig;
            if ~isempty(VS(i).AltDat.h(icg))
        hchigh_max(j)=nanmax(VS(i).AltDat.h(icg));
        hchigh_min(j)=nanmin(VS(i).AltDat.h(icg));
        else
            hchigh_max(j)=nan;
            hchigh_min(j)=nan;
        end
        end
        
    else %the last VS
        % lower station
        for j=1:length(VS(i-1).AltDat.ci)
            ic=VS(i-1).AltDat.c==VS(i-1).AltDat.ci(j);
            ig=VS(i-1).AltDat.iGood;
            icg=ic&ig;
            if ~isempty(VS(i).AltDat.h(icg))
        hclow_max(j)=nanmax(VS(i).AltDat.h(icg));
        hclow_min(j)=nanmin(VS(i).AltDat.h(icg));
        else
            hclow_max(j)=nan;
            hclow_min(j)=nan;
        end
        end
        %vs being evaluated
        for j=1:length(VS(i).AltDat.ci)
            ic=VS(i).AltDat.c==VS(i).AltDat.ci(j);
            ig=VS(i).AltDat.iGood;
            icg=ic&ig;
             if ~isempty(VS(i).AltDat.h(icg))
        hcmid_max(j)=nanmax(VS(i).AltDat.h(icg));
        hcmid_min(j)=nanmin(VS(i).AltDat.h(icg));
        else
            hcmid_max(j)=nan;
            hcmid_min(j)=nan;
        end
        end
    end
end
%% with relevant hc extracted, compare
% if i<2
%     else if i<length(VS);
%         else 
%         end
% end


return

        
