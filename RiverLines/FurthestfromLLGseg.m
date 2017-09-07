function  [LGP]=FurthestfromLLGseg(nextseg,dexLG,Xline,Yline,segID);
back=find(segID==nextseg(end-2));
Xlinegood=Xline(back(end));
Ylinegood=Yline(back(end));

targetx= Xline(dexLG);
targety= Yline(dexLG);




   
    D=sqrt((targetx-Xlinegood).^2 + (targety-Ylinegood).^2 );
    [~,imax]=max(D);
    LGP=dexLG(imax);
end