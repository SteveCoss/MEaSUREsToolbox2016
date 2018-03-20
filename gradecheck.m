%gradecheck
function [grade] =gradecheck(VS,sat,riv,Egrades, Jgrades)

% take ggrades that are relivant from the sheet
if strcmp(sat,'Envisat')
    for i=1:length(Egrades);
        Enames(i)=Egrades(i).name;
        Egrade{i}=Egrades(i).grade;
        Estats(i)=Egrades(i).stats;
    end
else if strcmp(sat,'Jason2')
    for i=1:length(Jgrades);
        Jnames(i)=Jgrades(i).name;
        Jgrade{i}=Jgrades(i).grade;
        Jstats(i)=Jgrades(i).stats;
    end
    end
end
 

if strcmp(sat,'Jason2');
    NAMES=Jnames;
    GRADES=Jgrade;
    STATS=Jstats;
else
    NAMES=Enames;
    GRADES=Egrade;
    STATS=Estats;
end
index=strfind(NAMES,VS.ID);
dx=find(~cellfun(@isempty,index));
for i=1:length(dx)
    string{i}=NAMES{dx(i)};
    stlength(i)=length(string{i});
    dxindex=find(min(stlength));
end
%this step determines letter grade or fit stats
if isnan(STATS(dx(dxindex)).nse)
    grade=GRADES{dx(dxindex)};
    if iscell(grade)
        grade=grade{1};
    end
else
    grade=STATS(dx(dxindex));
end
return