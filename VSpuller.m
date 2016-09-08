%VSpuller
%Written by Steve Coss
%extracts and names VS structures from process virtual station runs and
%saves them for interpilation processing.
function VSpuller(VS, rivername,satellite)
NAME=strcat(rivername,satellite,'VS');
File=fullfile('C:\Users\coss.31\Documents\MATH\Steves_final_Toolbox\AltimetryToolbox\MEaSUREsToolbox2016\VSoutputs',NAME);
save(File,'VS');
end