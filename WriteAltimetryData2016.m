%write altimetry2016 is a redesigned version for preperation for dat upload.
%The origional versions Were writen by Mike durand and Steve Tuozzolo
function WriteAltimetryData2016(VS,Filter,Ice)


%level 2: these are the level 2 data from the platforms... not archived here
%level 3: these are the actual elevations being output by Chan's scripts,
%            on a footprint-by-footprint basis
%level 4: these are the timeseries of averaged products

fname=['DataProduct/' VS.ID '.nc'];

%% 1 extract dimensions from altimetry data
nt=length(VS.AltDat.t); %number of measurement times
ntAll=length(VS.AltDat.tAll); %total number of measurements

%% 2 definitions
ncid=netcdf.create(fname,'NETCDF4');      

%2.0 define groups
tGroupID=netcdf.defGrp(ncid,'Timeseries');
sGroupID=netcdf.defGrp(ncid,'Sampling');
l3GroupID=netcdf.defGrp(ncid,'Unprocessed GDR Data');
fGroupID=netcdf.defGrp(ncid,'Filter');

%2.1 define coordinate variables
vIDs.Lon=netcdf.defVar(ncid,'lon','NC_DOUBLE',[]);
vIDs.Lat=netcdf.defVar(ncid,'lat','NC_DOUBLE',[]);

%2.2 other root group items
%2.2.1 root group dimensions
iddimid = netcdf.defDim(ncid,'id',netcdf.getConstant('NC_UNLIMITED'));
satdimid = netcdf.defDim(ncid,'sat',netcdf.getConstant('NC_UNLIMITED'));
gradedimid = netcdf.defDim(ncid,'grade',netcdf.getConstant('NC_UNLIMITED'));
Timeimid = netcdf.defDim(ncid,'Time',netcdf.getConstant('NC_UNLIMITED'));

%2.2.2a define items
vIDs.ID=netcdf.defVar(ncid,'ID','NC_CHAR',iddimid);
vIDs.FlowDistance=netcdf.defVar(ncid,'Flow_Dist','NC_DOUBLE',[]);
vIDs.pass=netcdf.defVar(ncid,'pass','NC_INT',[]);
if ~isstruct(VS.grade);
vIDs.grade=netcdf.defVar(ncid,'grade','NC_CHAR',gradedimid);
else
    vIDs.nse=netcdf.defVar(ncid,'nse','NC_DOUBLE',gradedimid);
    vIDs.nseAVG=netcdf.defVar(ncid,'nseAVG','NC_DOUBLE',gradedimid);
    vIDs.R=netcdf.defVar(ncid,'R','NC_DOUBLE',gradedimid);
    vIDs.std=netcdf.defVar(ncid,'std','NC_DOUBLE',gradedimid);
    vIDs.stdAVG=netcdf.defVar(ncid,'stdAVG','NC_DOUBLE',gradedimid);
end
vIDs.TimeStamp=netcdf.defVar(ncid,'TimeStamp','NC_DOUBLE',Timeimid);

%2.2.2b flag items from root group (flags need a mask/values/meening)
vIDs.sat=netcdf.defVar(ncid,'sat_values','NC_CHAR',satdimid);%sat flag values
vIDs.rate=netcdf.defVar(ncid,'rate','NC_DOUBLE',[]);


%2.3 sampling 
%2.3.1 dimensions
SceneDimId = netcdf.defDim(sGroupID,'scene',netcdf.getConstant('NC_UNLIMITED'));
XDimId = netcdf.defDim(sGroupID,'lonbox',length(VS.X)-1);
YDimId = netcdf.defDim(sGroupID,'latbox',length(VS.Y)-1);
IceDimId= netcdf.defDim(sGroupID,'icedat',size(Ice,1));
cDimId = netcdf.defDim(sGroupID,'coordinates',5);
%2.3.2 definitions
vIDs.LandsatSceneID=netcdf.defVar(sGroupID,'scene','NC_CHAR',SceneDimId);
vIDs.SampX=netcdf.defVar(sGroupID,'lonbox','NC_DOUBLE',XDimId);
vIDs.SampY=netcdf.defVar(sGroupID,'latbox','NC_DOUBLE',YDimId);
vIDs.Island=netcdf.defVar(sGroupID,'island','NC_INT',[]);

%2.4 Unprocessed GDR Data
l3DimId = netcdf.defDim(l3GroupID,'l3',ntAll);
vIDs.L3Lon=netcdf.defVar(l3GroupID,'lon','NC_DOUBLE',l3DimId);
vIDs.L3Lat=netcdf.defVar(l3GroupID,'lat','NC_DOUBLE',l3DimId);
vIDs.L3h=netcdf.defVar(l3GroupID,'h','NC_DOUBLE',l3DimId);
vIDs.L3sig0=netcdf.defVar(l3GroupID,'sig0','NC_DOUBLE',l3DimId);
vIDs.L3pk=netcdf.defVar(l3GroupID,'pk','NC_DOUBLE',l3DimId);
vIDs.L3cyc=netcdf.defVar(l3GroupID,'cycle','NC_INT',l3DimId);
vIDs.L3t=netcdf.defVar(l3GroupID,'time','NC_DOUBLE',l3DimId);
vIDs.heightfilter=netcdf.defVar(l3GroupID,'heightfilter','NC_INT',l3DimId);
vIDs.icefilter=netcdf.defVar(l3GroupID,'icefilter','NC_INT',l3DimId);
vIDs.allfilter=netcdf.defVar(l3GroupID,'allfilter','NC_INT',l3DimId);


%2.5 timeseries 
tdimid = netcdf.defDim(tGroupID,'time',nt);
vIDs.time=netcdf.defVar(tGroupID,'time','NC_DOUBLE',tdimid);
vIDs.cycle=netcdf.defVar(tGroupID,'cycle','NC_INT',tdimid);
vIDs.hbar=netcdf.defVar(tGroupID,'hbar','NC_DOUBLE',tdimid);
vIDs.hwbar=netcdf.defVar(tGroupID,'hwbar','NC_DOUBLE',tdimid);
vIDs.sig0Avg=netcdf.defVar(tGroupID,'sig0bar','NC_DOUBLE',tdimid);
vIDs.pkAvg=netcdf.defVar(tGroupID,'pkbar','NC_DOUBLE',tdimid);


%2.6 filter
%%filter group needs approprate flag attributes (values/masks/meanings)
IceDimId = netcdf.defDim(fGroupID,'years',size(Ice,1));
demdimid = netcdf.defDim(ncid,'DEMused',netcdf.getConstant('NC_UNLIMITED'));

vIDs.nND=netcdf.defVar(fGroupID,'nNODATA','NC_INT',[]);


vIDs.riverh=netcdf.defVar(fGroupID,'riverh','NC_DOUBLE',[]);


vIDs.maxh=netcdf.defVar(fGroupID,'maxh','NC_DOUBLE',[]);


vIDs.minh=netcdf.defVar(fGroupID,'minh','NC_DOUBLE',[]);


vIDs.icethaw=netcdf.defVar(fGroupID,'icethaw','NC_DOUBLE',IceDimId);


vIDs.icefreeze=netcdf.defVar(fGroupID,'icefreeze','NC_DOUBLE',IceDimId);


vIDs.DEMused=netcdf.defVar(fGroupID,'DEMused','NC_CHAR',demdimid);






%% 3  attributes
%3.1 global
netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'title',['Altimetry Data for virtual station ' VS.ID]);
netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'Conventions', 'CF-1.6' ); % required to indicate that data is CF complient
%3.2 root group
%3.2.1 coordinate units
netcdf.putAtt(ncid,vIDs.Lat,'units','degrees_north');
netcdf.putAtt(ncid,vIDs.Lon,'units','degrees_east');

%3.2.2a other root group
netcdf.putAtt(ncid,vIDs.sat,'long_name','satellite');
netcdf.putAtt(ncid,vIDs.rate,'units','Hz');

netcdf.putAtt(ncid,vIDs.rate,'long_name','sampling rate');
netcdf.putAtt(ncid,vIDs.pass,'long_name','pass_number');
if ~isstruct(VS.grade);
    netcdf.putAtt(ncid,vIDs.grade,'long_name','grade');
else
    netcdf.putAtt(ncid,vIDs.nse,'long_name','MAX nash sutcliffe efficiency');
    netcdf.putAtt(ncid,vIDs.nseAVG,'long_name','average nash sutcliffe efficiency');
    netcdf.putAtt(ncid,vIDs.R,'long_name','correlation coefficient');
    netcdf.putAtt(ncid,vIDs.std,'long_name',' MIN standard deviation of error');
    netcdf.putAtt(ncid,vIDs.stdAVG,'long_name','average standard deviation of error');
end
netcdf.putAtt(ncid,vIDs.TimeStamp,'long_name','Time at creation of file');
%3.2.2b root group flag items
netcdf.putAtt(ncid,vIDs.sat,'long_name','satellite');
netcdf.putAtt(ncid,vIDs.rate,'long_name','sampling rate');

%3.3 sampling group
netcdf.putAtt(sGroupID,vIDs.LandsatSceneID,'long_name','Landsat Scene ID');
netcdf.putAtt(sGroupID,vIDs.SampX,'long_name','Longitude Box Extents');
netcdf.putAtt(sGroupID,vIDs.SampY,'long_name','Latitude Box Extents');
netcdf.putAtt(sGroupID,vIDs.SampX,'units','degrees_east');
netcdf.putAtt(sGroupID,vIDs.SampY,'units','degrees_north');
netcdf.putAtt(sGroupID,vIDs.Island,'long_name','Island Flag');

%3.4 Unprocessed GDR Data
netcdf.putAtt(l3GroupID,vIDs.L3Lon,'units','degrees_east');
netcdf.putAtt(l3GroupID,vIDs.L3Lat,'units','degrees_north');
netcdf.putAtt(l3GroupID,vIDs.L3h,'units','meters');
netcdf.putAtt(l3GroupID,vIDs.L3sig0,'units','dB');
netcdf.putAtt(l3GroupID,vIDs.L3pk,'units','unknown');
netcdf.putAtt(l3GroupID,vIDs.L3t,'units','days since 0000-01-00 00:00:00');
netcdf.putAtt(l3GroupID,vIDs.heightfilter,'units','0 filtered out, 1 included (logical)');
netcdf.putAtt(l3GroupID,vIDs.icefilter,'long_name','0 filtered out, 1 included (logical)');
netcdf.putAtt(l3GroupID,vIDs.allfilter,'long_name','0 filtered out, 1 included (logical)');

%3.5  timeseries 
%3.5.1 units
netcdf.putAtt(tGroupID,vIDs.time,'units','days since 0000-01-00 00:00:00');
netcdf.putAtt(tGroupID,vIDs.cycle,'units','-');
netcdf.putAtt(tGroupID,vIDs.hbar,'units','meters');
netcdf.putAtt(tGroupID,vIDs.hwbar,'units','meters');
netcdf.putAtt(tGroupID,vIDs.sig0Avg,'units','dB');
netcdf.putAtt(tGroupID,vIDs.pkAvg,'units','unknown');


%3.5.2 timeseries long names
netcdf.putAtt(tGroupID,vIDs.hbar,'long_name','Average Height');
netcdf.putAtt(tGroupID,vIDs.hwbar,'long_name','Weighted Average Height');
netcdf.putAtt(tGroupID,vIDs.sig0Avg,'long_name','Average Sigma0');
netcdf.putAtt(tGroupID,vIDs.pkAvg,'long_name','Peakiness');

%3.6 filter
netcdf.putAtt(fGroupID,vIDs.nND,'long_name','Number of Cycles without Data');
netcdf.putAtt(fGroupID,vIDs.riverh,'long_name','River elevation from filter file');
netcdf.putAtt(fGroupID,vIDs.maxh,'long_name','Maximum elevation allowed by filter');
netcdf.putAtt(fGroupID,vIDs.minh,'long_name','Minimum elevation allowed by filter');
netcdf.putAtt(fGroupID,vIDs.minh,'long_name','Minimum elevation allowed by filter');
netcdf.putAtt(fGroupID,vIDs.DEMused,'long_name','DEM used in height filter');
%3.7 ice
netcdf.putAtt(fGroupID,vIDs.icethaw,'long_name','Thaw dates for river');
netcdf.putAtt(fGroupID,vIDs.icefreeze,'long_name','Freeze dates for river');


netcdf.endDef(ncid);


%% 4 variables
%4.1 root group
netcdf.putVar(ncid,vIDs.Lon,VS.Lon);
netcdf.putVar(ncid,vIDs.Lat,VS.Lat);
netcdf.putVar(ncid,vIDs.ID,0,length(VS.ID),VS.ID);
netcdf.putVar(ncid,vIDs.FlowDistance,VS.FLOW_Dist/1000); %convert m->km
netcdf.putVar(ncid,vIDs.sat,0,length(VS.Satellite),VS.Satellite);
netcdf.putVar(ncid,vIDs.rate,VS.Rate);
netcdf.putVar(ncid,vIDs.pass,VS.Pass);
if ~isstruct(VS.grade);
netcdf.putVar(ncid,vIDs.grade,0,length(VS.grade),VS.grade);%grade
else
netcdf.putVar(ncid,vIDs.nse,0,length(VS.grade),VS.grade.nse);%grade
netcdf.putVar(ncid,vIDs.nseAVG,0,length(VS.grade),VS.grade.nseAVG);%grade
netcdf.putVar(ncid,vIDs.R,0,length(VS.grade),VS.grade.R);%grade
netcdf.putVar(ncid,vIDs.std,0,length(VS.grade),VS.grade.std);%grade
netcdf.putVar(ncid,vIDs.stdAVG,0,length(VS.grade),VS.grade.stdAVG);%grade
end
Tstamp=clock;
netcdf.putVar(ncid,vIDs.TimeStamp,0,length(Tstamp),Tstamp);

%4.2 sampling
% netcdf.putVar(sGroupID,vIDs.LandsatSceneID %to be completed
netcdf.putVar(sGroupID,vIDs.SampX,VS.X(1:end-1));
netcdf.putVar(sGroupID,vIDs.SampY,VS.Y(1:end-1));
netcdf.putVar(sGroupID,vIDs.Island,VS.Y(1:end-1)); %to be completed

%4.3 Unprocessed GDR Data
netcdf.putVar(l3GroupID,vIDs.L3Lon,VS.AltDat.lon);
netcdf.putVar(l3GroupID,vIDs.L3Lat,VS.AltDat.lat);
netcdf.putVar(l3GroupID,vIDs.L3h,VS.AltDat.h);
netcdf.putVar(l3GroupID,vIDs.L3sig0,VS.AltDat.sig0);
netcdf.putVar(l3GroupID,vIDs.L3pk,VS.AltDat.PK);
netcdf.putVar(l3GroupID,vIDs.L3cyc,VS.AltDat.c);
netcdf.putVar(l3GroupID,vIDs.L3t,VS.AltDat.tAll);
netcdf.putVar(l3GroupID,vIDs.heightfilter,VS.AltDat.iGoodH+0);
netcdf.putVar(l3GroupID,vIDs.icefilter,VS.AltDat.IceFlag+0);
netcdf.putVar(l3GroupID,vIDs.allfilter,VS.AltDat.iGood+0);

%4.4 timeseries 
netcdf.putVar(tGroupID,vIDs.time,VS.AltDat.t);
netcdf.putVar(tGroupID,vIDs.cycle,VS.AltDat.ci);
netcdf.putVar(tGroupID,vIDs.hbar,VS.AltDat.hbar);
netcdf.putVar(tGroupID,vIDs.hwbar,VS.AltDat.hwbar);
netcdf.putVar(tGroupID,vIDs.sig0Avg,VS.AltDat.sig0Avg);

%4.5 filter
netcdf.putVar(fGroupID,vIDs.nND,VS.AltDat.nNODATA);
netcdf.putVar(fGroupID,vIDs.riverh,Filter.AbsHeight);
netcdf.putVar(fGroupID,vIDs.maxh,Filter.AbsHeight+Filter.MaxFlood);
netcdf.putVar(fGroupID,vIDs.minh,Filter.AbsHeight-Filter.MinFlood);
netcdf.putVar(fGroupID,vIDs.DEMused,0,length(Filter.DEMused),Filter.DEMused);

%4.6 ice
if size(Ice,1)>2
netcdf.putVar(fGroupID,vIDs.icethaw,Ice(:,2));
netcdf.putVar(fGroupID,vIDs.icefreeze,Ice(:,3));
end

% close 
netcdf.close(ncid);

return
