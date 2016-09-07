%% Process program for measures
%Written by M. Durand
%Edited by S. Tuozzolo 9/2015
%Edited by S.Coss 6/2016
%Requires raw data extracted from GDR, Rivernames & Satellite names, and
%ice data (optional). Options to create NetCDFs, plots of individual
%virtual stations, and overall statistics are available. See Readme.txt
%file for more information on script & associated functions.

clear all; close all; clc;
%% Create a list of rivers you want to run
NorthAmerica={'Columbia','Mackenzie','StLawrence','Susquehanna', 'Yukon','Mississippi'};
SouthAmerica={'Amazon','Orinoco','Tocantins','SaoFrancisco','Uruguay','Magdalena','Parana','Oiapoque','Essequibo','Courantyne'};
Africa={'Congo','Nile','Niger','Zambezi'};
Eurasia={'Amur','Anabar','Ayeyarwada','Kuloy','Ob','Mezen','Lena','Yenisei','Pechora','Pyasina','Khatanga','Olenyok' ...
    ,'Indigirka','Kolyma','Anadyr','Yangtze','Mekong','Ganges','Brahmaputra','Indus','Volga'};

CurrRiv={'StLawrence'}; %if you want to do a single river, use this
Americas=[NorthAmerica SouthAmerica];
World=[Americas Africa Eurasia];
RunRiv=CurrRiv; %you can switch this to CurrRiv if you only want to run one river.
Satellite={'Jason2','Envisat'}; %either Envisat or Jason2 or both, need a cell with 1 or more strings
J2=[]; Env=[];
%omit tital stations
tide=true;

for iriv=1:length(RunRiv)
    clearvars -except RunRiv Satellite iriv jsat J2 Env tide; %keep these on each loop. get rid of each river's data when moving to the next river
    for jsat=1:length(Satellite)
        %% uselib('altimetry')
        %set the datapath and input values for river data analysis
        datapath='C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox\IN';
        library='C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox';
        addpath(genpath(datapath))%this is the path to the raw data (GDR outputs + shapefiles + misc data)
        addpath(genpath(library)) %this is the path to the altimetry toolbox
        rivername=RunRiv{iriv}; satellite=Satellite{jsat}; stations=0; %set current river, satellite, and # of stations (0 is default)
        %% add in and process grade file
       [Egrades,Jgrades]=gradelistreader(Satellite);
        %% add in tide check
       [Tname,Tdist]=tidereader;
       
        [DoIce,icefile]=IceCheck(rivername); %check rivername to see if ice
        %% Read in virtual station metadata & shapefiles
        [VS, Ncyc,S,stations] = ReadPotentialVirtualStations(rivername,satellite,stations); %get VS data from shapefile
        if size(VS,1)>0
            DEM=zeros(length(stations),3);
            clear 'Gdat' %prevents errors from less Envi than J2stations
            for i=stations
                [VS(i).AltDat, DEM(VS(i).Id+1,:), Gdat(i)]= GetAltimetry(VS(i),Ncyc); %get all raw data, place in VS structure
            end
            stations=Gdat+1;
            stations(stations==0)=[]; %remove stations from list with bad data
            %% Create filter data using SRTM -> GMTED -> ASTER (?)
             FilterData=struct([]);
            FilterData=CreateFilterData(VS,DEM,FilterData,stations);
            [FilterData]=CBelevations(VS,FilterData);%constreign by baseline elevation
            
            %% Read the icefile for the relevant river with freeze/that dates for the years 2000-2015
            %all icefiles should be 'icebreak_rivername.xlsx'
            if DoIce
                IceData=ReadIceFile(icefile); %read in ice file for freeze/thaw dates
            else IceData=[];
            end
            %% Run through the data and analyze / store
            % HeightFilter.m runs IceFilter.m when necessary. CalcAvgHeights.m is creates an average pass height
            % WriteAltimetrydData.m writes VS metadata, raw data, and filtered data to a .nc file, one for each virtual station.
            DoPlotsFilt=false; ShowBad=false; DoPlotsIce=false; DoPlotsAvg=false; DoNetCDF=true;
            CT=1;
            clear 'WRITTEN' %prevents errors from less Envi than J2stations
            for i=stations,
                [VS(i).AltDat] = HeightFilter(VS(i).AltDat,S(i),FilterData(i),IceData,DoIce,VS(i).ID,DoPlotsFilt,ShowBad);
           
              
                   % VS(i).AltDat =  hi_lowAnom(VS,i, FilterData(i).AbsHeight);
                
                 VS(i).AltDat = CalcAvgHeights(FilterData(i).AbsHeight,VS(i).AltDat,VS(i).ID,IceData,DoPlotsAvg);
                VS(i).AltDat.AbsHeight=FilterData(i).AbsHeight;
                 %% add tide distance
                    if tide && VS(i).AltDat.Write
                    [VS(i)] = tidecheck(VS(i),rivername,Tname,Tdist);
                    end
                      
                if VS(i).AltDat.Write && DoNetCDF
                    %% drop grades into VS/netcdf
                    [VS(i).grade] = gradecheck(VS(i),satellite,rivername,Egrades,Jgrades);
                    
                    %%  write it to .nc
                     WriteAltimetryData(VS(i),FilterData(i),IceData);
                    
                    WRITTEN{CT}=VS(i).ID;
                    CT=CT+1;
                end
                
              
            end
            if CT ==1
                WRITTEN=[];
            end
            %% Generate overall statistics for river
            %genRivStats(VS,rivername,stations,iriv,RunRiv)
           
            if jsat==1 && size(VS,1)>0 %put in the jason 2 category
                J2=genRivStats(VS,rivername,stations,iriv,RunRiv,J2);
                J2(iriv).WRITTEN=WRITTEN';
                J2fl=1;
            else if size(VS,1)>0 %put in the envisat category
                    Env=genRivStats(VS,rivername,stations,iriv,RunRiv,Env);
                    Env(iriv).WRITTEN=WRITTEN';
                    Envfl=1;
                end
            end
        end
        VSpuller(VS,rivername,satellite);%saves the VS for each sat/riv combo
    end
    if ~exist('J2fl','var')
        J2(iriv).Flag = 1;
    end
    if ~exist('Envfl','var')
        Env(iriv).Flag =1;
    end
    WriteSummaryFile(J2(iriv),Env(iriv),RunRiv{iriv});
    clearvars J2fl Envfl
    
end
%% See how the bulk river data performs
%
[totmat,j2prop,envprop]=DoMetaPlots(RunRiv,J2,Env);

J2sum=0; J2wri=0;
Ensum=0; Enwri=0;

for i=1:length(J2)
    J2sum=J2sum+size(J2(i).Val,2);
    J2wri=J2wri+size(J2(i).WRITTEN,1);
    Ensum=Ensum+size(Env(i).Val,2);
    Enwri=Enwri+size(Env(i).WRITTEN,1);
end