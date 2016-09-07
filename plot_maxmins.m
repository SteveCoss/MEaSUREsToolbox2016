figure
plot(VS(i).AltDat.t,hcmid_max)
hold on 
plot(VS(i).AltDat.t,hcmid_min)

plot(VS(i+1).AltDat.t,hchigh_min)
hold on
plot(VS(i+1).AltDat.t,hchigh_max)
plot(VS(i).AltDat.t,hanom)
plot(VS(i).AltDat.t,lanom)


plot(VS(i+1).AltDat.t,hclow_min)
plot(VS(i+1).AltDat.t,hclow_max)

legend('mid','mid','high','high','low','low')
