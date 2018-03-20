% river line puller
%Uses d_segID to find entire river
clear all; close all; clc
 datapath='C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox\MEaSUREsToolbox2016\RiverLines';

%% to generate a center line
Lineorgrats=2 %1=generate line, 2 = altergrrats
River = 'Yukon';
Sat= 'Envisat'%'Envisat'
switch Lineorgrats
    case {1}
generatecenterline=1;% Generate a river centerline from point data
alterGRRATS=0
    case {2}
        generatecenterline=0;% Generate a river centerline from point data
alterGRRATS=1
end
        %change Flow Distance for VS in GRRATS file and make V2
%% is this river in SRTM coverage ?
SRTMcenter=false
%if not whats the starting points origional fid (This is the one at the
%mouth
STpnt=1
 if SRTMcenter
StartSeg=878 ;%top
endseg=2041; %mouth
RemovebadPoint=true%use this when VS are very near to ocean and in -9999 zone
%% lake block removal 
LR.LR=false;
LR.upgood=1271;
LR.downgood=830;
   
manoveride= []%[1581, 1763,3273,1732,3295]
 else
     LR=[]
     manoveride=[]
     StartSeg=[];
     endseg=[];
     RemovebadPoint=[]
 end

centerpointshapefile=strcat(River,'Center');
%Ganges [1581, 1763,3273,1732,3295]
%[1581, 1763,3273,1732,3295]%amazon
%[811,1549,1577,1532,1554,1552,1586,1530,1514,1535,1539,1555,1534,1589,1610,1567,1627]%parana
%[1280,1624,1614]%Ganges
%[1950,1569,1791,622]%Bhramaputra
%[653,675,684,677,679]%Amur
%[374,323,320,475]%StLawrence
%[319,326,332,331,337,334]%Zambezie
%[738,724,770,795,966,784,807,828,821,827,831,830,832,829,833,835,1044,987,1051,967,819,814,808,834,825,794,842]%Uruguay
%[760,756,384,397,441,463,531,445,142,722,332,450,492,513,725,462,408,549,432,701,535]%tocantins
%[112,123,148]%saoFrancisco
%[997,1256,1760,1748,1771,1818,1843,1867]%orinoco
%[64,69,58]%amazon
%[1369]%esequibo
%[1581, 1763,3273,1732]%amazon
%[374 411 372 399]st lawrence
%[920,1225,1262,1250,1325]%Yangtze
%% GRRATS file to modify

shapefileGRRATS=strcat(River,'_',Sat);
%%

if generatecenterline
 GCL(centerpointshapefile,StartSeg,endseg,River,manoveride,RemovebadPoint,LR,SRTMcenter,STpnt);%generate a center line of the correct poins from target river
   %S=shaperead(strcat(River,'_','centerline'));
else
    S=shaperead(strcat(River,'_','centerline')); % read in centerline for processing and adding Flow_Dist to GRRATS data 
end
if alterGRRATS
%% extract centerline info
if SRTMcenter
    Xline = [S.longitude];
    Yline=[S.latitude];
    FD=[S.Flow_Dist]
else if isfield(S,'lon');
        FD=[S.Flow_Dist];
        Xline=[S.lon];
        Yline=[S.lat];
    else
        Xline=[S.longitude];
        Yline=[S.latitude];
        FD =[S.Flow_Dist];
    end
end
     

%%find flow distance for each polygon
ModGRRATSflD(Xline, Yline, FD, shapefileGRRATS);
end
