function  [ nextseg]= BREAKFIXER2(S,lastgoodseg,segID);

Xline=[S.longitude];
Yline=[S.latitude];
FL=[S.flow_acc];
%exclude values from the last good segment
dex=find(segID==lastgoodseg);
lastgoodpoint=max(FL(dex));
LGP=find(FL==lastgoodpoint)

difdex=setdiff(1:1:length(segID),dex,'legacy');

Xlinegood=Xline(difdex);
Ylinegood=Yline(difdex);

targetx= Xline(LGP);
targety= Yline(LGP);




   
    D=sqrt((targetx-Xlinegood).^2 + (targety-Ylinegood).^2 );
    [~,imin]=min(D);
    nextseg=segID(difdex(imin));