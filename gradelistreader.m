%gradelistreader
%process grades and store for use in the loop
function [Egrades,Jgrades]=gradelistreader(sat, UseV2)
if UseV2
    Nameappend='_gradesC_V2';
else
    
    Nameappend='_gradesC_V1';
end

%envi
if numel(sat)==2;
    gradefileE=fullfile('C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox\MEaSUREsToolbox2016\IN' ...
        ,strcat(sat(2), Nameappend,'.xlsx'));
   
    [~,~,RAW]=xlsread(cell2mat(gradefileE),'','','basic');
   
  S=size(RAW);
    for i=1:S(1)
        Egrades(i).name=RAW((i),1);
        if isempty(RAW{(i),2})
            Egrades(i).grade=nan
        else
        Egrades(i).grade=RAW{(i),2};
        end
        Egrades(i).stats.nse=RAW{(i),3};
        Egrades(i).stats.nsemedian=RAW{(i),4};
        Egrades(i).stats.R=RAW{(i),5};
        Egrades(i).stats.std=RAW{(i),6};
        Egrades(i).stats.stdmedian=RAW{(i),7};
        if ~UseV2
        %prox
        Egrades(i).stats.prox=RAW{(i),9};
        Egrades(i).stats.proxSTD=RAW{(i),10};
        Egrades(i).stats.proxR=RAW{(i),11};
        Egrades(i).stats.proxE=RAW{(i),12};
        end
        
    end
    
    %jason
    gradefileJ=fullfile('C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox\MEaSUREsToolbox2016\IN' ...
        ,strcat(sat(1), Nameappend,'.xlsx'));
      [~,~,RAW]=xlsread(cell2mat(gradefileJ),'','','basic');
    S=size(RAW);
    for i=1:S(1)
        Jgrades(i).name=RAW((i),1);
       if isempty(RAW{(i),2})
            Jgrades(i).grade=nan
        else
        Jgrades(i).grade=RAW((i),2);
        end
        Jgrades(i).stats.nse=RAW{(i),3};
        Jgrades(i).stats.nsemedian=RAW{(i),4};
        Jgrades(i).stats.R=RAW{(i),5};
        Jgrades(i).stats.std=RAW{(i),6};
        Jgrades(i).stats.stdmedian=RAW{(i),7};
         if ~UseV2
        %prox
        Jgrades(i).stats.prox=RAW{(i),9};
        Jgrades(i).stats.proxSTD=RAW{(i),10};
        Jgrades(i).stats.proxR=RAW{(i),11};
        Jgrades(i).stats.proxE=RAW{(i),12};
         end
    end
else if strcmp(sat,'Envisat');
        gradefileE=fullfile('C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox\MEaSUREsToolbox2016\IN' ...
            ,strcat(sat, Nameappend,'.xlsx'));
         [~,~,RAW]=xlsread(cell2mat(gradefileE),'','','basic');
         S=size(RAW);
    for i=1:S(1)
        Egrades(i).name=RAW((i),1);
       if isempty(RAW{(i),2})
            Egrades(i).grade=nan
        else
        Egrades(i).grade=RAW((i),2);
        end
        Egrades(i).stats.nse=RAW{(i),3};
        Egrades(i).stats.nsemedian=RAW{(i),4};
        Egrades(i).stats.R=RAW{(i),5};
        Egrades(i).stats.std=RAW{(i),6};
        Egrades(i).stats.stdmedian=RAW{(i),7};
         if ~UseV2
        %prox
        Egrades(i).stats.prox=RAW{(i),9};
        Egrades(i).stats.proxSTD=RAW{(i),10};
        Egrades(i).stats.proxR=RAW{(i),11};
        Egrades(i).stats.proxE=RAW{(i),12};
         end
        
    end
        %dump empty variable
        Jgrades=nan;
        Jnse=nan;
    else
        gradefileJ=fullfile('C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox\MEaSUREsToolbox2016\IN' ...
            ,strcat(sat, Nameappend,'.xlsx'));
       [~,~,RAW]=xlsread(cell2mat(gradefileE),'','','basic');
         S=size(RAW);
    for i=1:S(1)
        Jgrades(i).name=RAW((i),1);
        if isempty(RAW{(i),2})
            Jgrades(i).grade=nan
        else
        Jgrades(i).grade=RAW((i),2);
        end
        Jgrades(i).stats.nse=RAW{(i),3};
        Jgrades(i).stats.nsemedian=RAW{(i),4};
        Jgrades(i).stats.R=RAW{(i),5};
        Jgrades(i).stats.std=RAW{(i),6};
        Jgrades(i).stats.stdmedian=RAW{(i),7};
         if ~UseV2
        %prox
        Jgrades(i).stats.prox=RAW{(i),9};
        Jgrades(i).stats.proxSTD=RAW{(i),10};
        Jgrades(i).stats.proxR=RAW{(i),11};
        Jgrades(i).stats.proxE=RAW{(i),12};
         end
    end
        %dump empty variable
        Egrades=nan;
        Ense=nan;
        
    end
end
end
