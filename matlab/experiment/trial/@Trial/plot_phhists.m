function plot_phhists(tr)
    if isa(tr.ts,'TimeSeriesBimanual')
        figure; hold on;
        ph=linspace(-pi,pi,length(tr.ts.Romega_phhist));
        rscale=max(-tr.ts.Romega_phhist)/2;
        lscale=max(-tr.ts.Lomega_phhist)/2;
        maxy=max([max(-tr.ts.Lomega_phhist),max(-tr.ts.Romega_phhist)]);
        plot(ph,-tr.ts.Romega_phhist,'r');  
        plot(ph,-tr.ts.Lomega_phhist,'r--'); 
        plot(ph,(tr.ts.Rxnorm_phhist+1)*rscale,'b'); 
        plot(ph,(tr.ts.Lxnorm_phhist+1)*lscale,'b--');
        plot(ph,(tr.ts.Rvnorm_phhist+1)*rscale,'m'); 
        plot(ph,(tr.ts.Lvnorm_phhist+1)*lscale,'m--');
        legend({'Romega','Lomega','Rxnorm','Lxnorm','Rvnorm','Lvnorm'});
        hline(0,'k');
        vline(ph(round(end/2)),'k');
        xlim([-pi,pi]);  
        ylim([0,maxy]);
    else
        figure; hold on;
        ph=linspace(-pi,pi,length(tr.ts.omega_phhist));
        plot(ph,-tr.ts.omega_phhist,'r');  
        plot(ph,tr.ts.xnorm_phhist*10,'b'); 
        plot(ph,tr.ts.vnorm_phhist*10,'k'); 
        legend({'omega','xnorm','vnorm'});
        hline(0,'k');
        vline(ph(round(end/2)),'k');
        xlim([-pi,pi]);
        ylim([-10,10]);
    end