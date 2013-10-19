function inspectts(tr,h)
if nargin<2, h='R';end
figure;
hold on;
plot(tr.ts.([h,'xnorm_hist']),'k')
plot(tr.ts.([h,'vnorm_hist']),'--k')
plot(tr.ts.([h,'anorm_hist']),'r')
plot(tr.ts.([h,'jerknorm_hist']),'--r')
plot(-tr.ts.([h,'omeganorm_hist']),'m')
hline(0,'k-')
legend({'xnorm','vnorm','anorm','wnorm'})


