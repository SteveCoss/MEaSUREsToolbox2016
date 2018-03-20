%Script opens Centerline shapefiels used in GRRATS V2 FLow distances,
%and extracts the Lat/Lon of points at intervals supplied by the user
%(closest to)

clear all; clc; close all
%% User input 
River='Yukon'
Interval= 250;
%%Load centerfile
Ffile=strcat(River,'_centerline.shp')
P=shaperead(Ffile);
%% generate vector of dessired locations 
FD=[P.Flow_Dist];
TargetFD=min(FD):Interval:max(FD);
%%  seek closest Flow D available
for i = 1:length(TargetFD);
[~, I(i)] = min(abs(FD-TargetFD(i)));
end
%% extract Lat lon from those places
if isfield(P,'latitude');
LAT=[P.latitude];
LON=[P.longitude];
else
    LAT=[P.lat];
    LON=[P.lon];
end

Tlon=LON(I)';
Tlat=LAT(I)';
Tfd=FD(I)';
T=[ Tlon,Tlat, Tfd];
%write xls
Outfilename=strcat(num2str(Interval),'-m-',River,'_center_locations')
RANGE=strcat('A2:C',num2str(length(T)));
xlswrite(Outfilename,T,RANGE);