function GCL(centerpointshapefile,StartSeg,endseg,River,manoveride,RemovebadPoint,LR,SRTMcenter,STpnt)
%S=shaperead(centerpointshapefile);
load(fullfile('C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox\MEaSUREsToolbox2016\RiverLines\CenterpointMATs',centerpointshapefile));
if SRTMcenter
%% pull segids
  segID=[S.segmentID];
  DownSeg=[S.d_segID];


%% look at start seg for end seg and onward
junklist=[nan];
k=1
for i=1:length(unique(segID));
    
    if k==1
        
        dex=find(segID==StartSeg);
        nextseg(k)= DownSeg(dex(end));
        k=k+1;
        %junklist=[];
    else if ~(nextseg(k-1)==endseg)
%             if nextseg(k-1)==670
%                 poatop=1
%             end
            if nextseg(k-1)==-9999 || nextseg(k-1)==-9998;%if there is a break find the nearest point
                if k<3
                    [ nextseg(k-1),junklist]= BREAKFIXER(S,StartSeg,segID,nextseg,k,junklist,manoveride);
                else
                    [ nextseg(k-1),junklist]= BREAKFIXER(S,nextseg(k-2),segID,nextseg,k,junklist,manoveride);
                end
            else if~isempty(intersect(nextseg(1:k-2),nextseg(k-1))) %this invalidates the last 2 nextsegs
                    [ nextseg(k-2),junklist]= BREAKFIXER(S,nextseg(k-2),segID,nextseg,k,junklist,manoveride);
                    k=k-1;
                else
                    dex=find(segID==nextseg(k-1));
                    nextseg(k)= DownSeg(dex(end));
                    if length(setdiff(manoveride,nextseg(k)))<length(manoveride)
                        nextseg(k)=-9998
                        k=k+1;
                    else
                        
                        k=k+1;
                    end
                end
            end
            
        end
    end
end

for i =1:length(nextseg)
    nextsegg(i+1)=nextseg(i);
end
nextsegg(1)=StartSeg;
allsegs=setdiff(nextsegg,manoveride,'stable');
if LR.LR
    onebad=find(allsegs==LR.upgood);
    endbad=find(allsegs==LR.downgood);
    allsegs(onebad+1:endbad-1)=nan;
end
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
 if RemovebadPoint
%reject points without flowacc
 F=[S.flow_acc];
 goodpoint=F>-9999;
 S=S(goodpoint);
 F=[S.flow_acc];
 end
 %Sort centerline by flowacc
% [~,isort]=sort(F,'descend');
% S=S(isort);

S=flip(S)
  Xline=[S.longitude];
  Yline=[S.latitude];

 
 
 %reproject lenterline points
mstruct = defaultm('eqaazim ');
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

     shapewrite(S,strcat(River,'_','centerline'));
else
    % get rid of duplicate vertacies
   Keep=1:2:length(S);
   S=S(Keep)
    Xline=[S.X];
  Yline=[S.Y];

 

     %reproject lenterline points
 mstruct = defaultm('balthsrt');
 mstruct.geoid = almanac('earth','wgs84','meters');
 mstruct = defaultm(mstruct);
 [X,Y]=mfwdtran(mstruct,Yline,Xline);
%% make sure they are in the correct order
data=ones(length(X),2);
data(:,1)=X;
data(:,2)=Y;
dist = pdist2(data,data);


N = size(data,1);
result = NaN(1,N);
%find the start point
stpoint = find([S.ORIG_FID]==STpnt);
result(1) = stpoint; % first point is first row in data matrix

for ii=2:N
    dist(:,result(ii-1)) = Inf;
    [~, closest_idx] = min(dist(result(ii-1),:));
    result(ii) = closest_idx;
end
S=S(result);
% %check order
% if S(1).ORIG_FID==STpnt
%     S=S
% else
%     result=fliplr(result);
%     S=S(result);
% end


    FD=zeros(size(X));
    for i=2:length(FD),
   
    FD(i)=FD(i-1)+sqrt( (X(i)-X(i-1))^2 + (Y(i)-Y(i-1))^2 );
    S(1).Flow_Dist=0;
    S(i).Flow_Dist=FD(i);
    end
 shapewrite(S,strcat(River,'_','centerline'))
end

return