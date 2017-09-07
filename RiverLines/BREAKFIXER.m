function  [ nextsegg,junklist]= BREAKFIXER(S,lastgoodseg,segID,nextseg,k,junklist,manoveride);
if nextseg(end)==-9998
    lastgoodseg=nextseg(end-1)
end
Xline=[S.longitude];
Yline=[S.latitude];
FL=[S.flow_acc];
dexLG=find(segID==lastgoodseg);
%exclude values from the last good segment
if ~isempty(intersect(nextseg(1:k-2),nextseg(k-1)))
    for i=1:length(nextseg)-1
        dex(i).dex=find(segID==nextseg(i));
    end
    if isempty(junklist)
        dex=[dex.dex];
        junklist(length(junklist)+1)=nextseg(k-2)
    else
        for i=1:length(junklist)
            dexj(i).dexj=find(segID==junklist(i));
        end
        dexj=[dexj.dexj];
        dex=[dex.dex];
        dex=union(dex, dexj);
        junklist(length(junklist)+1)=nextseg(k-2);
    end
else
    
    
    if ~isempty(junklist)
        for i=1:length(junklist)
            dexj(i).dexj=find(segID==junklist(i));
        end
        dexj=[dexj.dexj];
         dex=union(dexLG, dexj);
    else dex=dexLG;
    end
end
%% find last good omiting junk
if k<3
 lastgoodpoint=max(FL(dexLG));
LGP=find(FL==lastgoodpoint);

else

    [LGP]=FurthestfromLLGseg(nextseg,dexLG,Xline,Yline,segID);
end
% else if length(lastgoodpoint)>1
%         [LGP]=FurthestfromLLGseg(nextseg,dexLG,Xline,Yline,segID);
%     else
%         LGP=find(FL==lastgoodpoint);
%     end
% end
%% find new point using manoveride
for i=1:length(manoveride)
    or(i).or=find(segID==manoveride(i));
end
or=[or.or];
dex=[dex or];
if ~isempty(junklist)& isempty(intersect(nextseg(1:k-2),nextseg(k-1)))
    difdex=setdiff(1:1:length(segID),dex,'legacy');
    difdex=union(difdex,dexj);
else
    difdex=setdiff(1:1:length(segID),dex,'legacy');
end

Xlinegood=Xline(difdex);
Ylinegood=Yline(difdex);

targetx= Xline(LGP(1));
targety= Yline(LGP(1));




   
    D=sqrt((targetx-Xlinegood).^2 + (targety-Ylinegood).^2 );
    [~,imin]=min(D);
    nextsegg=segID(difdex(imin));
    
end