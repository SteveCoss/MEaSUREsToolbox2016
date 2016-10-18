%gradelistreader 
%process grades and store for use in the loop
function [Egrades,Jgrades]=gradelistreader(sat)
%envi
if numel(sat)==2;
gradefileE=fullfile('C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox\MEaSUREsToolbox2016\IN' ...
    ,strcat(sat(2),'_gradesC','.xlsx'));
[NUM,TXT,RAW]=xlsread(cell2mat(gradefileE));
if length(TXT)>length(NUM)
    missing=length(TXT)-length(NUM);
     start=length(NUM)
    for i=1:length(missing)
        NUM( start+(i),:)=nan;
    end
end
for i=1:length(TXT)
Egrades(i).name=TXT((i),1);
Egrades(i).grade=TXT((i),2);
Egrades(i).stats.nse=NUM((i),1);
Egrades(i).stats.nseAVG=NUM((i),2);
Egrades(i).stats.R=NUM((i),3);
Egrades(i).stats.std=NUM((i),4);
Egrades(i).stats.stdAVG=NUM((i),5);
end

%jason
gradefileJ=fullfile('C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox\MEaSUREsToolbox2016\IN' ...
    ,strcat(sat(1),'_gradesC','.xlsx'));
[NUM,TXT,RAW]=xlsread(cell2mat(gradefileJ));
if length(TXT)>length(NUM)
    missing=length(TXT)-length(NUM);
     start=length(NUM)
    for j=1:missing
        NUM( start+(j),:)=nan;
    end
end
    
for i=1:length(TXT)
Jgrades(i).name=TXT((i),1);
Jgrades(i).grade=TXT((i),2);
Jgrades(i).stats.nse=NUM((i),1);
Jgrades(i).stats.nseAVG=NUM((i),2);
Jgrades(i).stats.R=NUM((i),3);
Jgrades(i).stats.std=NUM((i),4);
Jgrades(i).stats.stdAVG=NUM((i),5);
end
else if strcmp(sat,'Envisat');
        gradefileE=fullfile('C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox\MEaSUREsToolbox2016\IN' ...
            ,strcat(sat,'_gradesC','.xlsx'));
        [NUM,TXT,RAW]=xlsread(cell2mat(gradefileE));
        if length(TXT)>length(NUM)
            missing=length(TXT)-length(NUM);
            start=length(NUM)
            for i=1:(missing)
                NUM( start+(i),:)=nan;
            end
        end
        for i=1:length(TXT)
            Egrades(i).name=TXT((i),1);
            Egrades(i).grade=TXT((i),2);
            Egrades(i).stats.nse=NUM((i),1);
            Egrades(i).stats.nseAVG=NUM((i),2);
            Egrades(i).stats.R=NUM((i),3);
            Egrades(i).stats.std=NUM((i),4);
            Egrades(i).stats.stdAVG=NUM((i),5);
        end
        %dump empty variable
         Jgrades=nan;
         Jnse=nan;
    else
        gradefileJ=fullfile('C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox\MEaSUREsToolbox2016\IN' ...
            ,strcat(sat,'_gradesC','.xlsx'));
        [NUM,TXT,RAW]=xlsread(cell2mat(gradefileJ));
         if length(TXT)>length(NUM)
            missing=length(TXT)-length(NUM);
            start=length(NUM)
            for i=1:(missing)
                NUM( start+(i),:)=nan;
            end
        end
        for i=1:length(TXT)
            Jgrades(i).name=TXT((i),1);
            Jgrades(i).grade=TXT((i),2);
            Jgrades(i).stats.nse=NUM((i),1);
            Jgrades(i).stats.nseAVG=NUM((i),2);
            Jgrades(i).stats.R=NUM((i),3);
            Jgrades(i).stats.std=NUM((i),4);
            Jgrades(i).stats.stdAVG=NUM((i),5);
        end
        %dump empty variable
         Egrades=nan;
         Ense=nan;
        
    end
end
end
