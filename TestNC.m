ncid = netcdf.create('test4.nc','NETCDF4');
%latdimid = netcdf.defDim(ncid,'latitude',3);
%londimid = netcdf.defDim(ncid,'longitude',3);
datadimid = netcdf.defDim(ncid,'data',3);
v.lat = netcdf.defVar(ncid,'latitude','NC_DOUBLE',datadimid);
v.lon = netcdf.defVar(ncid,'longitude','NC_DOUBLE',datadimid);
v.dat = netcdf.defVar(ncid,'Data','NC_DOUBLE',datadimid);
v.dat2 = netcdf.defVar(ncid,'Dat1','NC_DOUBLE',datadimid);
v.da1 = netcdf.defVar(ncid,'Alpha','NC_DOUBLE',datadimid);

netcdf.putAtt(ncid,v.lat,'long_name','latitude');
netcdf.putAtt(ncid,v.lon,'long_name','longitude');
netcdf.putAtt(ncid,v.dat,'long_name','Data');
netcdf.putAtt(ncid,v.dat2,'long_name','Dat1');
netcdf.putAtt(ncid,v.da1,'long_name','Alpha');

netcdf.putAtt(ncid,v.lat,'units','degree_north');
netcdf.putAtt(ncid,v.lon,'units','degree_east');
netcdf.putAtt(ncid,v.dat,'coordinates','longitude latitude');
netcdf.putAtt(ncid,v.dat2,'coordinates','longitude latitude');
netcdf.putAtt(ncid,v.da1,'coordinates','longitude latitude');

netcdf.putVar(ncid,v.lat,[40 30 20]);
netcdf.putVar(ncid,v.lon,[40 50 60]);
netcdf.putVar(ncid,v.dat,[1 0 1]);
netcdf.putVar(ncid,v.dat2,[2 3 4]);
netcdf.putVar(ncid,v.da1,[0 0 1]);

netcdf.close(ncid);