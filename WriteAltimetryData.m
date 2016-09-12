function WriteAltimetryData(VS,Filter,Ice)

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
UGDR_GroupID=netcdf.defGrp(ncid,'Unprocessed GDR Data');
fGroupID=netcdf.defGrp(ncid,'Filter');



%2.1 other root group items
%2.1.1 text string ids
londimid = netcdf.defDim(ncid,'X',netcdf.getConstant('NC_UNLIMITED'));
latdimid = netcdf.defDim(ncid,'Y',netcdf.getConstant('NC_UNLIMITED'));
gradedimid = netcdf.defDim(ncid,'grade',netcdf.getConstant('NC_UNLIMITED'));
Timeimid = netcdf.defDim(ncid,'T',netcdf.getConstant('NC_UNLIMITED'));
distdimid= netcdf.defDim(ncid,'distance',netcdf.getConstant('NC_UNLIMITED'));
filldimid= netcdf.defDim(ncid,'root',netcdf.getConstant('NC_UNLIMITED'));
%2.2.1 define coordinate variables
vIDs.Lon=netcdf.defVar(ncid,'lon','NC_DOUBLE',londimid);
vIDs.Lat=netcdf.defVar(ncid,'lat','NC_DOUBLE',latdimid);

%2.2.2 define items
vIDs.ID=netcdf.defVar(ncid,'ID','NC_CHAR',filldimid);
vIDs.sat=netcdf.defVar(ncid,'sat','NC_CHAR',filldimid);

vIDs.FlowDistance=netcdf.defVar(ncid,'Flow_Dist','NC_DOUBLE',distdimid);
vIDs.rate=netcdf.defVar(ncid,'rate','NC_DOUBLE',filldimid);
vIDs.pass=netcdf.defVar(ncid,'pass','NC_INT',filldimid);
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

%2.3 sampling 
%2.3.1 dimensions
SceneDimId = netcdf.defDim(sGroupID,'scene',netcdf.getConstant('NC_UNLIMITED'));
XDimId = netcdf.defDim(sGroupID,'X',length(VS.X)-1);
 XLimId = netcdf.defDim(sGroupID,'Xlimit',2);
YDimId = netcdf.defDim(sGroupID,'Y',length(VS.Y)-1);
 YLimId = netcdf.defDim(sGroupID,'Ylimit',2);
IceDimId= netcdf.defDim(sGroupID,'icedat',size(Ice,1));
cDimId = netcdf.defDim(sGroupID,'coordinates',5);
%2.3.2 definitions
vIDs.LandsatSceneID=netcdf.defVar(sGroupID,'scene','NC_CHAR',SceneDimId);
vIDs.SampX=netcdf.defVar(sGroupID,'lonbox','NC_DOUBLE',XDimId);
vIDs.XLim=netcdf.defVar(sGroupID,'lon_Limits','NC_DOUBLE', XLimId);
vIDs.SampY=netcdf.defVar(sGroupID,'latbox','NC_DOUBLE',YDimId);
vIDs.YLim=netcdf.defVar(sGroupID,'lat_Limits','NC_DOUBLE', YLimId);
vIDs.Island=netcdf.defVar(sGroupID,'island','NC_INT',SceneDimId);

%2.4 Unprocessed GDR Data
l3DimId = netcdf.defDim(UGDR_GroupID,'UGDR',ntAll);
UGDRXDimId = netcdf.defDim(UGDR_GroupID,'X',ntAll);
UGDRYDimId = netcdf.defDim(UGDR_GroupID,'Y',ntAll);
UGDRZDimId = netcdf.defDim(UGDR_GroupID,'Z',ntAll);
UGDRTDimId = netcdf.defDim(UGDR_GroupID,'T',ntAll);

vIDs.UGDR_Lon=netcdf.defVar(UGDR_GroupID,'lon','NC_DOUBLE',UGDRXDimId);
vIDs.UGDR_Lat=netcdf.defVar(UGDR_GroupID,'lat','NC_DOUBLE',UGDRYDimId);
vIDs.UGDR_h=netcdf.defVar(UGDR_GroupID,'h','NC_DOUBLE',UGDRZDimId);
vIDs.UGDR_sig0=netcdf.defVar(UGDR_GroupID,'sig0','NC_DOUBLE',l3DimId);
vIDs.UGDR_pk=netcdf.defVar(UGDR_GroupID,'pk','NC_DOUBLE',l3DimId);
vIDs.UGDR_cyc=netcdf.defVar(UGDR_GroupID,'cycle','NC_INT',l3DimId);
vIDs.UGDR_t=netcdf.defVar(UGDR_GroupID,'time','NC_DOUBLE',UGDRTDimId);
vIDs.UGDR_heightfilter=netcdf.defVar(UGDR_GroupID,'heightfilter','NC_INT',l3DimId);
vIDs.UGDR_icefilter=netcdf.defVar(UGDR_GroupID,'icefilter','NC_INT',l3DimId);
vIDs.UGDR_allfilter=netcdf.defVar(UGDR_GroupID,'allfilter','NC_INT',l3DimId);


%2.5 timeseries 
tdimid = netcdf.defDim(tGroupID,'T',nt);
Ztsdimid = netcdf.defDim(tGroupID,'Z',nt);
tsdimid = netcdf.defDim(tGroupID,'TS',nt);
vIDs.time=netcdf.defVar(tGroupID,'time','NC_DOUBLE',tdimid);
vIDs.cycle=netcdf.defVar(tGroupID,'cycle','NC_INT',tsdimid);
vIDs.hbar=netcdf.defVar(tGroupID,'hbar','NC_DOUBLE',Ztsdimid);
vIDs.hwbar=netcdf.defVar(tGroupID,'hwbar','NC_DOUBLE',Ztsdimid);
vIDs.sig0Avg=netcdf.defVar(tGroupID,'sig0bar','NC_DOUBLE',tsdimid);
vIDs.pkAvg=netcdf.defVar(tGroupID,'pkbar','NC_DOUBLE',tsdimid);


%2.6 filter
%%filter group needs approprate flag attributes (values/masks/meanings)
 IceDimId = netcdf.defDim(fGroupID,'T',size(Ice,1));
 demdimid = netcdf.defDim(fGroupID,'DEM',length(Filter.DEMused));
fheightdimid = netcdf.defDim(fGroupID,'Z',1);


vIDs.nND=netcdf.defVar(fGroupID,'nNODATA','NC_INT', []);
vIDs.riverh=netcdf.defVar(fGroupID,'riverh','NC_DOUBLE',fheightdimid);
vIDs.maxh=netcdf.defVar(fGroupID,'maxh','NC_DOUBLE', fheightdimid);
vIDs.minh=netcdf.defVar(fGroupID,'minh','NC_DOUBLE', fheightdimid);
vIDs.icethaw=netcdf.defVar(fGroupID,'icethaw','NC_DOUBLE', IceDimId);
vIDs.icefreeze=netcdf.defVar(fGroupID,'icefreeze','NC_DOUBLE', IceDimId);
vIDs.DEMused=netcdf.defVar(fGroupID,'DEMused','NC_CHAR', demdimid);






%% 3  attributes
%3.1 global
netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'title',['GRRATS (Global River Radar Altimetry Time Series) Data for virtual station ' VS.ID]);
netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'Conventions', 'CF-1.6' ); % required to indicate that data is CF complient
netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'institution', 'Ohio State University, School of Earth Sciences' ); 
netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'source', 'MEaSUREs OSU ALT toolbox 2016' ); 
%netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'history', '' ); 
%netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'references', '' ); 

%3.2 root group
%3.2.1 coordinate units
netcdf.putAtt(ncid,vIDs.Lat,'units','degrees_north');
netcdf.putAtt(ncid,vIDs.Lat,'long_name','latitude');

netcdf.putAtt(ncid,vIDs.Lon,'units','degrees_east');
netcdf.putAtt(ncid,vIDs.Lon,'long_name','longitude');

%3.2.2 other root group
netcdf.putAtt(ncid,vIDs.ID,'long_name','reference_VS_ID');
netcdf.putAtt(ncid,vIDs.FlowDistance,'long_name','distance_from_river_mouth');
netcdf.putAtt(ncid,vIDs.FlowDistance,'units','km');


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
     netcdf.putAtt(ncid,vIDs.std,'units','m');
    netcdf.putAtt(ncid,vIDs.stdAVG,'long_name','average standard deviation of error');
    netcdf.putAtt(ncid,vIDs.stdAVG,'units','m');
end
netcdf.putAtt(ncid,vIDs.TimeStamp,'long_name','Time at creation of file');
netcdf.putAtt(ncid,vIDs.TimeStamp,'units','year month day hour minute second');

%3.3 sampling group
netcdf.putAtt(sGroupID,vIDs.LandsatSceneID,'long_name','Landsat Scene ID');
netcdf.putAtt(sGroupID,vIDs.SampX,'long_name','Longitude Box Extents');
netcdf.putAtt(sGroupID,vIDs.XLim,'long_name','Longitude Limits');
netcdf.putAtt(sGroupID,vIDs.XLim,'units','degrees_east');
netcdf.putAtt(sGroupID,vIDs.SampY,'long_name','Latitude Box Extents');
netcdf.putAtt(sGroupID,vIDs.YLim,'long_name','Latitude Limits');
netcdf.putAtt(sGroupID,vIDs.YLim,'units','degrees_north');
netcdf.putAtt(sGroupID,vIDs.SampX,'units','degrees_east');
netcdf.putAtt(sGroupID,vIDs.SampY,'units','degrees_north');
%flags
netcdf.putAtt(sGroupID,vIDs.Island,'long_name','Island Flag');
netcdf.putAtt(sGroupID,vIDs.Island,'standard_name','Island_Flag');
netcdf.putAtt(sGroupID,vIDs.Island,'Fill_value','-1');
netcdf.putAtt(sGroupID,vIDs.Island,'valid_range','0,1');
netcdf.putAtt(sGroupID,vIDs.Island,'flag_masks','1');
netcdf.putAtt(sGroupID,vIDs.Island,'flag_meanings','island_present_in_polygon ');

%3.4 Unprocessed GDR Data
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lon,'units','degrees_east');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lon,'long_name','longitude');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lon,'standard_name','longitude');

netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lat,'units','degrees_north');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lat,'long_name','latitude');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lat,'standard_name','latitude');

netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'units','meters_above_EGM2008_geoid');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'positive','up');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'leng_name','unprocessed heights');


netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_sig0,'units','dB');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_sig0,'long_name','Sigma0');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_pk,'units','-');

netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_cyc,'units','-');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_cyc,'standard_name','Altimiter_cycle');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_cyc,'long_name','Unprocessed_GDR_Altimiter_cycle');

netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_t,'units','days since Jan-01-1900 00:00:00');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_t,'long_name','time');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_t,'calendar','standard');


%flags
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_heightfilter,'long_name','Good heights flag');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_heightfilter,'standard_name','Good_heights_flag');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_heightfilter,'valid_range','0, 1');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_heightfilter,'flag_masks','1');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_heightfilter,'flag _meenings','height_passed_filter');
%
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_icefilter,'long_name','No_ice_flag');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_icefilter,'valid_range','0, 1');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_icefilter,'flag_masks','1');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_icefilter,'flag_meenings','height_recorded_at_time_of_no_ice');
%
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_allfilter,'long_name','Combined_good_heights_and_ice_free_flag');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_allfilter,'valid_range','0, 1');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_allfilter,'flag_masks','1');
netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_allfilter,'flag_meenings','Ice_free_heights_that_passed_height_filter');


%3.5  timeseries 
%3.5.1 units
netcdf.putAtt(tGroupID,vIDs.time,'units','days since Jan-01-1900 00:00:00');
netcdf.putAtt(tGroupID,vIDs.time,'calendar','standard');
netcdf.putAtt(tGroupID,vIDs.time,'long_name','time');

netcdf.putAtt(tGroupID,vIDs.cycle,'units','-');
netcdf.putAtt(tGroupID,vIDs.cycle,'long_name','altimiter cycle');
netcdf.putAtt(tGroupID,vIDs.hbar,'units','meters_above_EGM2008_geoid');
netcdf.putAtt(tGroupID,vIDs.hwbar,'units','meters_above_EGM2008_geoid');
netcdf.putAtt(tGroupID,vIDs.sig0Avg,'units','dB');
netcdf.putAtt(tGroupID,vIDs.pkAvg,'units','-');


%3.5.2 timeseries long names
netcdf.putAtt(tGroupID,vIDs.hbar,'long_name','Average Height');
netcdf.putAtt(tGroupID,vIDs.hbar,'positive','up');

netcdf.putAtt(tGroupID,vIDs.hwbar,'long_name','Weighted Average Height');
netcdf.putAtt(tGroupID,vIDs.hwbar,'positive','up');

netcdf.putAtt(tGroupID,vIDs.sig0Avg,'long_name','Average Sigma0');
netcdf.putAtt(tGroupID,vIDs.pkAvg,'long_name','Average Peakiness');

%3.6 filter
netcdf.putAtt(fGroupID,vIDs.nND,'long_name','Number of Cycles without Data');
netcdf.putAtt(fGroupID,vIDs.nND,'units','count');
netcdf.putAtt(fGroupID,vIDs.riverh,'long_name','River elevation from filter file');
netcdf.putAtt(fGroupID,vIDs.riverh,'units','meters_above_EGM2008_geoid');
netcdf.putAtt(fGroupID,vIDs.maxh,'long_name','Maximum elevation allowed by filter');
netcdf.putAtt(fGroupID,vIDs.maxh,'units','meters_above_EGM2008_geoid');
netcdf.putAtt(fGroupID,vIDs.minh,'long_name','Minimum elevation allowed by filter');
netcdf.putAtt(fGroupID,vIDs.minh,'units','meters_above_EGM2008_geoid');
netcdf.putAtt(fGroupID,vIDs.DEMused,'long_name','DEM used in height filter');
%3.7 ice
netcdf.putAtt(fGroupID,vIDs.icethaw,'long_name','Thaw dates for river');
netcdf.putAtt(fGroupID,vIDs.icefreeze,'long_name','Freeze dates for river');


netcdf.endDef(ncid);


%% 4 variables
%4.1 root group
netcdf.putVar(ncid,vIDs.Lon,0,length(VS.Lon),VS.Lon);
netcdf.putVar(ncid,vIDs.Lat,0,length(VS.Lat),VS.Lat);
netcdf.putVar(ncid,vIDs.ID,0,length(VS.ID),VS.ID);
netcdf.putVar(ncid,vIDs.FlowDistance,0,length(VS.FLOW_Dist),VS.FLOW_Dist/1000); %convert m->km
netcdf.putVar(ncid,vIDs.sat,0,length(VS.Satellite),VS.Satellite);
netcdf.putVar(ncid,vIDs.rate,0,length(VS.Rate),VS.Rate);
netcdf.putVar(ncid,vIDs.pass,0,length(VS.Pass),VS.Pass);
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
netcdf.putVar(sGroupID,vIDs.LandsatSceneID,0,length(VS.LSID),VS.LSID)
netcdf.putVar(sGroupID,vIDs.SampX,VS.X(1:end-1));
xlim=[max(VS.X) min(VS.X)];
netcdf.putVar(sGroupID,vIDs.XLim,xlim);
netcdf.putVar(sGroupID,vIDs.SampY,VS.Y(1:end-1));
ylim=[max(VS.Y) min(VS.Y)];
netcdf.putVar(sGroupID,vIDs.YLim,ylim);
 netcdf.putVar(sGroupID,vIDs.Island,0,length(VS.Island),VS.Island); 

%4.3 Unprocessed GDR Data
%datenum for jan1 1900
startdate=datenum(1900,1,1);

netcdf.putVar(UGDR_GroupID,vIDs.UGDR_Lon,VS.AltDat.lon);
netcdf.putVar(UGDR_GroupID,vIDs.UGDR_Lat,VS.AltDat.lat);
netcdf.putVar(UGDR_GroupID,vIDs.UGDR_h,VS.AltDat.h);
netcdf.putVar(UGDR_GroupID,vIDs.UGDR_sig0,VS.AltDat.sig0);
netcdf.putVar(UGDR_GroupID,vIDs.UGDR_pk,VS.AltDat.PK);
netcdf.putVar(UGDR_GroupID,vIDs.UGDR_cyc,VS.AltDat.c);
netcdf.putVar(UGDR_GroupID,vIDs.UGDR_t,VS.AltDat.tAll-startdate);
netcdf.putVar(UGDR_GroupID,vIDs.UGDR_heightfilter,VS.AltDat.iGoodH+0);
netcdf.putVar(UGDR_GroupID,vIDs.UGDR_icefilter,VS.AltDat.IceFlag+0);
netcdf.putVar(UGDR_GroupID,vIDs.UGDR_allfilter,VS.AltDat.iGood+0);

%4.4 timeseries 
netcdf.putVar(tGroupID,vIDs.time,VS.AltDat.t-startdate);
netcdf.putVar(tGroupID,vIDs.cycle,VS.AltDat.ci);
netcdf.putVar(tGroupID,vIDs.hbar,VS.AltDat.hbar);
netcdf.putVar(tGroupID,vIDs.hwbar,VS.AltDat.hwbar);
netcdf.putVar(tGroupID,vIDs.sig0Avg,VS.AltDat.sig0Avg);

%4.5 filter
netcdf.putVar(fGroupID,vIDs.nND,VS.AltDat.nNODATA);
netcdf.putVar(fGroupID,vIDs.riverh,Filter.AbsHeight);
netcdf.putVar(fGroupID,vIDs.maxh,Filter.AbsHeight+Filter.MaxFlood);
netcdf.putVar(fGroupID,vIDs.minh,Filter.AbsHeight-Filter.MinFlood);
netcdf.putVar(fGroupID,vIDs.DEMused,0,length(Filter.DEMused), Filter.DEMused);

%4.6 ice
if size(Ice,1)>2
netcdf.putVar(fGroupID,vIDs.icethaw,Ice(:,2)-startdate);
netcdf.putVar(fGroupID,vIDs.icefreeze,Ice(:,3)-startdate);
end

% close 
netcdf.close(ncid);

return
