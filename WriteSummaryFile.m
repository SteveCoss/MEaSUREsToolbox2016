function WriteSummaryFile(J2,Env,Top,ERS2,ERS1c,ERS1g,RivName)
% writeDEM=true
filename=[RivName '_NetCDF_List.txt'];
FID = fopen(fullfile('C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox\MEaSUREsToolbox2016\Dataproduct',filename),'wt');


fprintf(FID,'%s','Virtual Stations with generated NetCDFs')

if J2.Flag ~=1
    A1=size(J2.Val,2);
    A2=length(J2.WRITTEN);  
    fprintf(FID,'\r%d Virtual Stations identified for Jason-2, %d written to NetCDF',A1,A2)
end

if Env.Flag ~=1
    A1=size(Env.Val,2);
    A2=length(Env.WRITTEN);
    fprintf(FID,'\r%d Virtual Stations identified for Envisat, %d written to NetCDF',A1,A2)
end

if Top.Flag ~=1
    A1=size(Top.Val,2);
    A2=length(Top.WRITTEN);
    fprintf(FID,'\r%d Virtual Stations identified for Topex, %d written to NetCDF',A1,A2)
end
if ERS2.Flag ~=1
    A1=size(ERS2.Val,2);
    A2=length(ERS2.WRITTEN);
    fprintf(FID,'\r%d Virtual Stations identified for ERS2, %d written to NetCDF',A1,A2)
end
if ERS1c.Flag ~=1
    A1=size(ERS1c.Val,2);
    A2=length(ERS1c.WRITTEN);
    fprintf(FID,'\r%d Virtual Stations identified for ERS1c, %d written to NetCDF',A1,A2)
end
if ERS1g.Flag ~=1
    A1=size(ERS1g.Val,2);
    A2=length(ERS1g.WRITTEN);
    fprintf(FID,'\r%d Virtual Stations identified for ERS1g, %d written to NetCDF',A1,A2)
end
    
if J2.Flag ~=1
%     A0 = [char(J2.ID)];
%     A1 = [J2.Val];
%     A2 = length(J2.Val);
%     A3 = ['Jason2'];
    A4 = length(J2.WRITTEN);
%     A5 = [char(J2.WRITTEN)];
%     
%     formatSpec = 'Rivername is %s. There are %d virtual stations for %s \r\n';
%     fprintf(FID,formatSpec,A0,A2,A3);
%     formatSpec = 'Net CDFs were written for %d virtual stations. \r\nTheir filenames are below \r\n';
%     fprintf(FID,formatSpec,A4);
    for i=1:A4
    fprintf(FID,'\r%s,',char(J2.WRITTEN(i)))
    end
end

if Env.Flag ~=1
   A4 = length(Env.WRITTEN);
   
    for i=1:A4
    fprintf(FID,'\r%s,',char(Env.WRITTEN(i)));
    end
end
if Top.Flag ~=1
   A4 = length(Top.WRITTEN);
   
    for i=1:A4
    fprintf(FID,'\r%s,',char(Top.WRITTEN(i)));
    end
end
if ERS2.Flag ~=1
   A4 = length(ERS2.WRITTEN);
   
    for i=1:A4
    fprintf(FID,'\r%s,',char(ERS2.WRITTEN(i)));
    end
end
if ERS1c.Flag ~=1
   A4 = length(ERS1c.WRITTEN);
   
    for i=1:A4
    fprintf(FID,'\r%s,',char(ERS1c.WRITTEN(i)));
    end
end
if ERS1g.Flag ~=1
   A4 = length(ERS1g.WRITTEN);
   
    for i=1:A4
    fprintf(FID,'\r%s,',char(ERS1g.WRITTEN(i)));
    end
end
    fclose(FID);
    
end