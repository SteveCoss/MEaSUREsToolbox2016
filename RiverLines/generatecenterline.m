function generatecenterline(centerpointshapefile,StartSeg,endseg,River);
S=shaperead(shapefile);

for i=1:length(S);
  segID(i)=S(i).segmentID;
  DownSeg(i)=S(i).d_segID;
end

%% look at start seg for end seg and onward
k=1
for i=1:length(unique(segID));

if k==1

dex=find(segID==StartSeg);
nextseg(k)= DownSeg(dex(end));
k=k+1;
else if ~(nextseg(k-1)==endseg)
     
dex=find(segID==nextseg(k-1));
nextseg(k)= DownSeg(dex(end));
k=k+1;
    end
end
end    

allsegs=[StartSeg, nextseg];
k=0
for i=1:length(allsegs)
   
    fullsetindex(i).dex=find(segID==allsegs(i));
   
    for j=1:length(fullsetindex(i).dex);
        k=k+1;
        alldex(k)=fullsetindex(i).dex(j);
        
    end
end
S=S(alldex);
%% find and add Flow_Dist using euclidian distance
 %calculate a flow distance for each point on the line
 
%reject points without flowacc
 F=[S.flow_acc];
 goodpoint=F>-9999;
 S=S(goodpoint);
 F=[S.flow_acc];
 %Sort centerline by flowacc
[~,isort]=sort(F,'descend');
S=S(isort);

 for i=1:length(S);
  Xline(i)=S(i).longitude;
  Yline(i)=S(i).latitude;
 end
 
 
 %reproject lenterline points
mstruct = defaultm('robinson');
mstruct.origin = [ 0 0]; %eu(55 20) as(45 100)
mstruct.geoid = almanac('earth','wgs84','meters');
mstruct = defaultm(mstruct);
[X,Y]=mfwdtran(mstruct,Yline,Xline);
%mapshow(S)

FD=zeros(size(Xline));
for i=2:length(FD),
   
    FD(i)=FD(i-1)+sqrt( (X(i)-X(i-1))^2 + (Y(i)-Y(i-1))^2 );
    S(1).Flow_Dist=0;
    S(i).Flow_Dist=FD(i);
end

   S =  shapewrite(S,strcat(River,'_','centerline'));

return