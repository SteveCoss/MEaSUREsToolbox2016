function WriteSummaryFile(J2,Env,RivName)
% writeDEM=true
filename=[RivName '_NetCDF_List.txt'];
FID = fopen(fullfile('C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox\MEaSUREsToolbox2016\Dataproduct',filename),'wt');

if J2(1).Flag == 1
%    fprintf(FID,'There were no Jason 2 crossings for this river \r\n')
end
if Env(1).Flag == 1
%    fprintf(FID,'There were no Envisat crossings for this river \r\n')
end
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
   

    %A0 = [char(Env.ID)];
    %A1 = [Env.Val];
    %A2 = length(Env.Val);
    %A3 = ['Envisat'];
    A4 = length(Env.WRITTEN);
    %A5 = [char(Env.WRITTEN)];
    
    %formatSpec = 'Rivername is %s. There are %d virtual stations for %s \r\n';
    %fprintf(FID,formatSpec,A0,A2,A3);
    %formatSpec = 'Net CDFs were written for %d virtual stations. \r\nTheir filenames are below \r\n';
    %fprintf(FID,formatSpec,A4);
    for i=1:A4
    fprintf(FID,'\r%s,',char(Env.WRITTEN(i)));
    end
end
    fclose(FID);
    
end