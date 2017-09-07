function ModGRRATSflD(Xline, Yline, FD, shapefileGRRATS);
p=shaperead(shapefileGRRATS)
for i=1:length(p);
    goodcoord=~isnan(p(i).X);
    p(i).X=p(i).X(goodcoord);
    p(i).Y=p(i).Y(goodcoord);
    [ GEOM, INER, CPMO ] = polygeom( p(i).X,p(i).Y );
    D=sqrt((GEOM(2)-Xline).^2 + (GEOM(3)-Yline).^2 );
    [~,imin]=min(D);
    if min(D)<.2
        p(i).Flow_Dist=FD(imin);
    else
        p(i).Flow_Dist=-9999;
    end
end
%


shapewrite(p,strcat(shapefileGRRATS,'V2'));%write

return
