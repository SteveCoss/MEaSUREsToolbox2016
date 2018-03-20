%Create directories and save shape files into them to prepare for running
%on Euler
clear all; close all; clc;
NorthAmerica={'Columbia','Mackenzie','StLawrence','Susquehanna', 'Yukon','Mississippi'};
SouthAmerica={'Amazon','Orinoco','Tocantins','SaoFrancisco','Uruguay','Magdalena','Parana','Oiapoque','Essequibo','Courantyne'};
Africa={'Congo','Nile','Niger','Zambezi'};
Eurasia={'Amur','Anabar','Ayeyarwada','Kuloy','Ob','Mezen','Lena','Yenisei','Pechora','Pyasina','Khatanga','Olenyok' ...
    ,'Indigirka','Kolyma','Anadyr','Yangtze','Mekong','Ganges','Brahmaputra','Indus','Volga'};
CurrRiv={'Columbia'}; %if you want to do a single river, use this
Americas=[NorthAmerica SouthAmerica];
World=[Americas Africa Eurasia];
RunRiv=World; %you can switch this to CurrRiv if you only want to run one river.
Satellite={'ERS1c','ERS1g','ERS2'}; %either Envisat or Jason2 or both (ERS1c, ERS1g, ERS2), need a cell with 1 or more strings
J2=[]; Env=[]; ERS1c=[]; ERS1g=[]; ERS2=[];
Genscript = 1;

for iriv=1:length(RunRiv)
    clearvars -except RunRiv Satellite iriv jsat J2 Env tide UseV2 ERS1c ERS1g ERS2 Genscript; %keep these on each loop. get rid of each river's data when moving to the next river
    for jsat=1:length(Satellite)
        %% uselib('altimetry')
        %set the datapath and input values for river data analysis
        datapath='C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox\MEaSUREsToolbox2016\IN';
        library='C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox\MEaSUREsToolbox2016';
        addpath(genpath(datapath))%this is the path to the raw data (GDR outputs + shapefiles + misc data)
        addpath(genpath(library)) %this is the path to the altimetry toolbox
        rivername=RunRiv{iriv}; satellite=Satellite{jsat}; stations=0; %set current river, satellite, and #
        if Genscript
            
            % Read txt into cell A
             if strcmp(Satellite{jsat},'ERS1c');
            fid = fopen(fullfile('C:\Users\coss.31\Desktop\EulerDump','e1cvirtus_v1BLANK~'),'r');
            else if strcmp(Satellite{jsat},'ERS2');
                     fid = fopen(fullfile('C:\Users\coss.31\Desktop\EulerDump','e2virtus_v1BLANK~'),'r');
                end
             end
            i = 1;
            tline = fgetl(fid);
            A{i} = tline;
            while ischar(tline)
                i = i+1;
                tline = fgetl(fid);
                A{i} = tline;
            end
            %insert blank before the -1
            A{i}=[];
            A{i+1}=-1;
            fclose(fid);
            % Change cell A
             if strcmp(Satellite{jsat},'ERS1c');
            A{3} = strcat('joybid = ''',rivername,'_ERS1c'',');
             else if strcmp(Satellite{jsat},'ERS2');
                      A{3} = strcat('joybid = ''',rivername,'_ERS2'',');
                 end
             end
            % Write cell A into txt
             if strcmp(Satellite{jsat},'ERS1c');
            fid = fopen(fullfile('C:\Users\coss.31\Desktop\EulerDump',strcat('e1cvirtus_v1',rivername,'~')), 'w');
            else if strcmp(Satellite{jsat},'ERS2');
                    fid = fopen(fullfile('C:\Users\coss.31\Desktop\EulerDump',strcat('e2virtus_v1',rivername,'~')), 'w');
                end
             end
            for i = 1:numel(A)
                if A{i+1} == -1
                    fprintf(fid,'%s', A{i});
                    break
                else
                    fprintf(fid,'%s\n', A{i});
                end
            end
        else
            if exist(strcat(rivername,'_',Satellite{jsat},'.shp'), 'file') == 2
                mkdir(strcat('C:\Users\coss.31\Desktop\EulerDump\',Satellite{jsat}),strcat(rivername,'_',Satellite{jsat}));
                S = shaperead(strcat(rivername,'_',Satellite{jsat}))
                shapewrite(S,fullfile('C:\Users\coss.31\Desktop\EulerDump',Satellite{jsat},strcat(rivername,'_',Satellite{jsat}),strcat(rivername,'_',Satellite{jsat})));
            end
        end
    end
end