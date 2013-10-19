function plot_trfit2D(mdl,tr,pfit)
    if nargin==2, pfit=mdl.params; end
    
    %Set default values for plots
    plotconf=struct();
    plotconf.close_figs=1;
    plotconf.ext='png';
    plotconf.figsize=[0,0,3600,2400];
    %plotconf.figsize=[0,0,1800,1200];
    plotconf.dpi=200;
    plotconf.fontname='Arial';
    plotconf.fontsize=12;
    plotconf.phticks=[-pi,0,pi];
    plotconf.phlabels={'$-\pi$','0','$\pi$'};
    plotconf.tsticks=[0,25,50,75,100];
    plotconf.tslabels={'0','25','50','75','100'};
    plotconf.use_cosph=0;
    
    %Easy hand always first in the model (equation 1)
    if tr.info.LID < tr.info.RID
        plotconf.hands={'L','R'};        
    else
        plotconf.hands={'R','L'};
    end    
    
    mdl.load_param(pfit);
    mdl.run();
    plotconf.tsL=length(mdl.ph_hist);
    plotconf.phL=length(mdl.ph_phhist);
    plotconf.t=1:plotconf.tsL;
    
    %Plot figures
    plot_figure1(mdl,tr,deepcopy(plotconf));
    plot_figure2(mdl,tr,deepcopy(plotconf));
end

function plot_figure1(mdl,tr,conf)
    d=get_data_4plot(mdl,tr,conf);
    figure('name','Plot of trial fitting: simulated vs experimental phase space and time series');
    for h=1:2
        %PANEL 1.h: Phdot vs ph: Experimental and simulated data        
        ax_omg=subplot(2,2,1+2*(h-1));hold on;
        title('Angular state space');
        plot(ax_omg,mdl.(['ph',num2str(h),'_phhist']),-mdl.(['omega',num2str(h),'_phhist']),'-.k');
        plot(ax_omg,linspace(-pi,pi,d.phL),d.omega_phhist{h},'-k');
        legend(ax_omg,{'$\dot{\theta}_{sim}$','$\dot{\theta}_{exp}$'},'interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontname);
        xlabel('$\theta$','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontname);
        ylabel('$\dot{\theta}$','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontname);
        xlim([-pi,pi]);
        hline(0,'k');grid on;
        
        %PANEL 2.h: Time-based Histograms: Experimental and simulated
        ax_tshist=subplot(2,2,2+2*(h-1));hold on;
        title('Position/Velocity Time series histograms');
        plot(ax_tshist,d.t,d.xnorm_hist{h},'-k');
        plot(ax_tshist,d.t,d.vnorm_hist{h},'-k');
        plot(ax_tshist,d.t,mdl.(['xnorm',num2str(h),'_hist']),'--k');
        plot(ax_tshist,d.t,mdl.(['vnorm',num2str(h),'_hist']),'-.k');
        legend(ax_tshist,{'x_{sim}','v_{sim}','$x_{exp}$','$v_{exp}$'},'interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontname);
        hline(0,'k');grid on;
    end      
    conf.figsize=[0,0,3600,2400];
    savefig('models_fig4',conf)
    if conf.close_figs, close; end
end

function plot_figure2(mdl,tr,conf)
    %FIGURE 2: Time Series: Experimental and simulated
    figure('name','Plot of simulated vs experimental time series');
    ax_exp=subplot(2,1,1); hold on; 
    title(ax_exp,'Experimental $\dot{\theta}$','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontname);
    ax_sim=subplot(2,1,2); hold on; 
    title(ax_sim,'Simulated $\dot{\theta}$','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontname);
    colors={'k-','k--'};
    ylimits=[0,0];    
    idx=10000:30000;
    for h=1:2
        %Get data 
        omegasim=-resize_vector(mdl.phdot(:,h),length(mdl.phdot(:,h))*10);
        omegaexp=-tr.ts.([conf.hands{h},'omega']);
        omegasim=omegasim(idx);
        omegaexp=omegaexp(idx);
        %Get limits
        if min(omegasim)<ylimits(1)
            ylimits(1)=min(omegasim);
        end
        if max(omegasim)>ylimits(2)
            ylimits(2)=max(omegasim);
        end        
        if min(omegaexp)<ylimits(1)
            ylimits(1)=min(omegaexp);
        end
        if max(omegaexp)>ylimits(2)
            ylimits(2)=max(omegaexp);
        end

        %Plot experimental theta dot
        plot(ax_exp,idx/1000,omegaexp,colors{h})    
        xlim(ax_exp,[idx(1),idx(end)]/1000)
        grid(ax_exp,'on');
        
        %Plot simulated theta dot
        plot(ax_sim,idx/1000,omegasim,colors{h})
        xlim(ax_sim,[idx(1),idx(end)]/1000);
        grid(ax_sim,'on');
        
        %Display numerical results
        disp(['Results for hand ',conf.hands{h}])
        disp(['Experimental frequency: ',num2str(tr.ts.([conf.hands{h},'f'])*2*pi),...
            '  Simulated frequency: ',num2str(-mean(mdl.phdot(:,h)))])
    end
    ylimits=[-1,ylimits(2)];
    
    ylim(ax_exp,ylimits);
    xlabel(ax_exp,'time (s)','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontname)
    ylabel(ax_exp,'$\dot{\theta}$','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontname)
    legend(ax_exp,{'$\dot{\theta}_{Easy}$','$\dot{\theta}_{Diff}$'},'interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontname)
    
    ylim(ax_sim,ylimits);
    xlabel(ax_sim,'time (s)','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontname)
    ylabel(ax_sim,'$\dot{\theta}$','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontname)    
    legend(ax_sim,{'$\dot{\theta}_{Easy}$','$\dot{\theta}_{Diff}$'},'interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontname)
    %mdl.load_param(pinit);
    savefig('models_fig5',conf)
    if conf.close_figs, close; end
end

function d=get_data_4plot(mdl,tr,conf)
    %Get simulated sizes to rescale experimental vectors
    d=struct();
    d.tsL=length(mdl.ph_hist);
    d.phL=length(mdl.ph_phhist);
    d.t=1:d.tsL;
    %Get experimental time series and scaled histograms 
    if conf.use_cosph
        for h=1:2
            d.ph{h}=tr.ts.([conf.hands{h},'ph']);
            d.omega{h}=diff(unwrap(d.ph{h})*1000);
            d.omega{h}=-[d.omega{h}(1);d.omega{h}];
            d.x{h}=cos(d.ph{h});
            d.v{h}=[0;diff(d.x{h}*1000)];
            d.xnorm{h}=normalize(d.x{h});
            d.vnorm{h}=normalize(d.v{h});
            d.xnorm_hist{h}=normalize(get_ts_histogram(d.x{h},tr.ts.([conf.hands{h},'peaks']),d.tsL));
            d.vnorm_hist{h}=normalize(get_ts_histogram(d.v{h},tr.ts.([conf.hands{h},'peaks']),d.tsL));
            d.xnorm_phhist{h}=normalize(get_ph_histogram(d.x{h},d.ph{h},d.phL));
            d.vnorm_phhist{h}=normalize(get_ph_histogram(d.v{h},d.ph{h},d.phL));
            d.omega_phhist{h}=get_ph_histogram(d.omega{h},d.ph{h},d.phL);
            d.omeganorm_phhist{h}=normalize(d.omega_phhist{h});
            d.omega_hist{h}=get_ts_histogram(d.omega{h},tr.ts.([conf.hands{h},'peaks']),d.tsL);
            d.omeganorm_hist{h}=normalize(d.omega_hist{h});
        end        
    else
        for h=1:2
            d.ph_phhist{h}=resize_vector(tr.ts.([conf.hands{h},'ph_phhist']),d.phL);
            d.omega_phhist{h}=-resize_vector(tr.ts.([conf.hands{h},'omega_phhist']),d.phL);
            d.omeganorm_phhist{h}=-resize_vector(normalize(tr.ts.([conf.hands{h},'omega_phhist'])),d.phL);
            d.xnorm_phhist{h}=resize_vector(tr.ts.([conf.hands{h},'xnorm_phhist']),d.phL);
            d.vnorm_phhist{h}=resize_vector(tr.ts.([conf.hands{h},'vnorm_phhist']),d.phL);
            d.anorm_phhist{h}=resize_vector(tr.ts.([conf.hands{h},'anorm_phhist']),d.phL);
            d.ph_hist{h}=resize_vector(tr.ts.([conf.hands{h},'ph_phhist']),d.tsL);
            d.omega_hist{h}=-resize_vector(tr.ts.([conf.hands{h},'omega_hist']),d.tsL);
            d.omeganorm_hist{h}=-resize_vector(normalize(tr.ts.([conf.hands{h},'omega_hist'])),d.tsL);
            d.xnorm_hist{h}=resize_vector(tr.ts.([conf.hands{h},'xnorm_hist']),d.tsL);
            d.vnorm_hist{h}=resize_vector(tr.ts.([conf.hands{h},'vnorm_hist']),d.tsL);
            d.anorm_hist{h}=resize_vector(tr.ts.([conf.hands{h},'anorm_hist']),d.tsL);
            d.vf{h}=tr.(['vf',conf.hands{h}]).vectors;
            d.ph{h}=tr.ts.([conf.hands{h},'ph']);
            d.xnorm{h}=tr.ts.([conf.hands{h},'xnorm']);
            d.vnorm{h}=tr.ts.([conf.hands{h},'vnorm']);
        end
    end
end

function savefig(figname,conf)
    if strcmp(conf.ext,'fig')
        hgsave(gcf,figname,'all');
    else
        set(gcf, 'PaperUnits', 'inches', 'PaperPosition', conf.figsize/conf.dpi);
        print(gcf,['-d',conf.ext],sprintf('-r%d',conf.dpi),figname);
    end
end