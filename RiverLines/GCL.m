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

% S=flip(S)
%   Xline=[S.longitude];
%   Yline=[S.latitude];

 
 
 %reproject lenterline points
ZONE = utmzone(Yline, Xline);
mstruct = defaultm('utm');
mstruct.zone = ZONE;
mstruct.geoid = almanac('earth','wgs84','meters');
mstruct = defaultm(mstruct);
[X,Y]=mfwdtran(mstruct,Yline,Xline);
X=smooth(X);
 Y=smooth(Y);
%mapshow(S)
% %% make sure they are in the correct order
% data=ones(length(X),2);
% data(:,1)=X;
% data(:,2)=Y;
% dist = pdist2(data,data);
% 
% 
% N = size(data,1);
% result = NaN(1,N);
% %find the start point
% stpoint = min(find([S.flow_acc]== min([S.flow_acc])));
% result(1) = stpoint; % first point is first row in data matrix
% k=1
% for ii=2:N
%     dist(:,result(ii-1)) = Inf;
%     [close, closest_idx] = min(dist(result(ii-1),:));
%     wazup(k)=close;
%     k=k+1;
%     result(ii) = closest_idx;
% end
% goodresult = wazup < nanmedian(wazup)*2;
% result = result(goodresult);
% S=S(result);
% X = X(result);
% Y = Y(result);

FD=zeros(size(X));
for i=2:length(FD),
   
    FD(i)=FD(i-1)+sqrt( (X(i)-X(i-1))^2 + (Y(i)-Y(i-1))^2 );
    S(1).Flow_Dist=0;
    S(i).Flow_Dist=FD(i);
end

     shapewrite(S,strcat(River,'_','centerline'));
else
    % get rid of duplicate vertacies
    if isfield(S,'ORIG_FID')
    if length(unique([S.ORIG_FID])) < length(S)%if there are duplicates
   Keep=1:2:length(S);
   S=S(Keep)
    end
    end
    Xline=[S.X];
  Yline=[S.Y];
       %reproject lenterline points
ZONE = utmzone(Yline, Xline);
mstruct = defaultm('utm');
mstruct.zone = ZONE;

 mstruct.geoid = almanac('earth','wgs84','meters');
 mstruct = defaultm(mstruct);
 [X,Y]=mfwdtran(mstruct,Yline,Xline);
%  X=smooth(X);
%  Y=smooth(Y);
%% make sure they are in the correct order
data=ones(length(X),2);
data(:,1)=X;
data(:,2)=Y;
%this next step crashes if data is too large break it into two if above a
%certain size
if length(data)>70000;
    fprintf('Large size has triggered 1 by approach');
   % find closest point one point at a time :(
   % start by sorting by flow accumulation
   %Sort centerline by flowacc
%    F=[S.flow_acc];
%  [~,isort]=sort(F,'descend');
%  X=X(isort);
% Y=Y(isort);

   
if isfield(S,'ORIG_FID')
stpoint = find([S.ORIG_FID]==STpnt);
IDD=[S.ORIG_FID];
else
    stpoint = find([S.OBJECTID]==STpnt);
    IDD=[S.OBJECTID];
end
I(1)=stpoint
CDX=1:1:length(X);
CDXL=CDX>0;
CDXL(I)=0;
for i=1:length(X)-1
    
    [blork Icheck]= min(abs(sqrt( (X(I(i))-X(CDXL)).^2 + (Y(I(i))-Y(CDXL)).^2 )));
    lookat=(CDX(CDXL));
    I(i+1)=lookat(Icheck);
    CDXL(I(i+1))=0;
end
S=S(I);
X = X(I);
Y = Y(I);
%smooth before FD but after order correction
X=smooth(X);
Y=smooth(Y);
    
else
dist = pdist2(data,data);


N = size(data,1);
result = NaN(1,N);
%find the start point
if isfield(S,'ORIG_FID')
stpoint = find([S.ORIG_FID]==STpnt);
else
    stpoint = find([S.OBJECTID]==STpnt);
end
result(1) = stpoint; % first point is first row in data matrix
k=1
for ii=2:N
    dist(:,result(ii-1)) = Inf;
    [close, closest_idx] = min((dist(result(ii-1),:)));
    wazup(k)=close;
    k=k+1;
    result(ii) = closest_idx;
end
goodresult = wazup < nanmedian(wazup)*1.5;
% %shift 1 because diff
% BAD=find(goodresult == 0);
% BAD2 = BAD+1;
% BAD3 = BAD-1;
% goodresult(BAD2)=0
% goodresult(BAD3)=0
result=result(goodresult);
S=S(result);
X = X(result);
Y = Y(result);
X=smooth(X);
Y=smooth(Y);
end
% %check order
% if S(1).ORIG_FID==STpnt
%     S=S
% else
%     result=fliplr(result);
%     S=S(result);
% end


    FD=zeros(size(S));
    for i=2:length(FD),
   
    FD(i)=FD(i-1)+sqrt( (X(i)-X(i-1))^2 + (Y(i)-Y(i-1))^2 );
    S(1).Flow_Dist=0;
    S(i).Flow_Dist=FD(i);
    end
 shapewrite(S,strcat(River,'_','centerline'))
end

return