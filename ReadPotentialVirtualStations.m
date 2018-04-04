function [VS,Ncyc,S,stations] = ReadPotentialVirtualStations(fname,satellite,stations,UseV2)
Riv=fname;
if UseV2 & strcmp(satellite,'Envisat')||strcmp(satellite,'Jason2')
    fnameshape=[fname '_' satellite 'V2'];
    fname=[fname '_' satellite];
else
    fname=[fname '_' satellite];
end
%% associate with right file name endings based on sample frequency
if satellite(1:2)=='En'
    filecheck=fopen([fname '_0_18hz']);
else if satellite(1:2)=='Ja'
        filecheck=fopen([fname '_0_20hz']);
    else
        filecheck=fopen([fname '_0_10hz']);
    end
end
%verify file present
if filecheck==-1
    VS=[];
    Ncyc=[];
    S=[];
else
    %%create VS using shape file
    if UseV2 & strcmp(satellite,'Envisat')||strcmp(satellite,'Jason2')
        S=shaperead(fnameshape);
        SMF=[]%shapemodflag
    else if strcmp(satellite,'TopexPos')
            S=shaperead([Riv '_' 'Jason2V2']);%need to pull in and modify J2 shape because thee are no Topex shapes
            SMF='TP'%shapemodflag
        else
            S=shaperead(fname);
            SMF=[]%shapemodflag
        end
    end
    
    for i=1:length(S)
        if isempty(SMF);
            VS(i).ID=S(i).Station_ID;
        else if strcmp(SMF,'TP')
                Key   = [Riv '_' 'Jason2_'];
                Index = strfind(S(i).Station_ID, Key);
                %S(i).Station_ID(strfind(S(i).Station_ID, '_')) = []
                Value = sscanf(S(i).Station_ID(Index(1) + length(Key):end), '%g', 1);
                VS(i).ID=[fname '_' num2str(Value)];
            end
        end
        VS(i).Lat=nanmean(S(i).Y);
        VS(i).Lon=nanmean(S(i).X);
        VS(i).Width=S(i).RivWidth;
        VS(i).Pass=S(i).Pass_Num;
        ID=strsplit(VS(i).ID,'_');
        VS(i).Id=str2num(cell2mat(ID(3)));
        if ~isempty(S(i).Landsat_ID);
            VS(i).LSID=S(i).Landsat_ID;
        else
            VS(i).LSID='NA';
        end
        VS(i).Satellite=satellite;
        VS(i).X=S(i).X;
        VS(i).Y=S(i).Y;
        VS(i).FLOW_Dist=S(i).Flow_Dist;
        
        if isfield(S(i),'Island_Flg')
            
            VS(i).Island=S(i).Island_Flg;
        else
            VS(i).Island=-1;
        end
        if satellite(1:2)=='En'
            Ncyc=89;
            VS(i).Rate=18; %Hz
            
        else if satellite(1)=='J'
                Ncyc=303;
                VS(i).Rate=20; %Hz
            else if satellite(1:4)=='ERS2'%need to correct these cycle numbers
                Ncyc=85;
                VS(i).Rate=20; %Hz
                else if satellite(1:2)=='To'
                        Ncyc=289;
                VS(i).Rate=10; %Hz
                end
            end
        end
    end
    %replace VSIDs with proper non ENVi/J2 sat
%     if ~strcmp(VS(1).ID,[Riv '_' satellite '_0']);
%         
%         if strcmp(VS(1).ID,[Riv '_' 'Envisat' '_0']);
%             for k=1:length(VS);
%                 VS(k).ID = strrep(VS(k).ID,'Envisat',satellite);
%                 VS(k).Rate = 20 ;
%             end
%         else
%             for k=1:length(VS);
%                 VS(k).ID = strrep(VS(k).ID,'Jason2',satellite);
%             end
%         end
%     end
    
end
if stations==0;
    stations=1:length(VS);
end %run all stations unless otherwise specified
%sometimes the stations are in VS structure out of order due to the order
%they were origionally drawn in they must be sorted by id.
if length(VS)>1
    [sx,sx]=sort([VS.Id]);
    ss=VS(sx);
    VS=ss;
end

end