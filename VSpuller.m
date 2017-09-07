%VSpuller
%Written by Steve Coss
%extracts and names VS structures from process virtual station runs and
%saves them for interpilation processing.
function VSpuller(VS, rivername,satellite,UseV2)
if UseV2
NAME=strcat(rivername,satellite,'VS','_V2');
else
NAME=strcat(rivername,satellite,'VS');
end
File=fullfile('C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox\MEaSUREsToolbox2016\VSoutputs',NAME);
save(File,'VS');
end