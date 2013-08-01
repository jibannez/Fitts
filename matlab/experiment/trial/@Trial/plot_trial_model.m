function  plot_trial_model(tr)
figure;
hold on
scatter(tr.ts.Lph_phhist,-tr.ts.Lomega_phhist,'r.');
scatter(tr.ts.Rph_phhist,-tr.ts.Romega_phhist,'b.');
xlim([-pi,pi])
legend({'Lphdot','Rphdot'})
hline(0,'k')

figure;
subplot(2,1,1)
hold on
plot(cos(tr.ts.Lph),'r');
plot(sin(tr.ts.Lph),'b');
plot(tr.ts.Lph,'k--')
plot(tr.ts.Lomega/min(tr.ts.Lomega),'m')
legend({'Lphcos','Lphsin','Lph','Lphdot'})
hline(0,'k')


subplot(2,1,2)
hold on
plot(cos(tr.ts.Rph),'r');
plot(sin(tr.ts.Rph),'b');
plot(tr.ts.Rph,'k--')
plot(tr.ts.Romega/min(tr.ts.Romega),'m')
legend({'Rphcos','Rphsin','Rph','Rphdot'})
hline(0,'k')