function plot_paper_figs(trs)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   trs  = f1_trd,  f1_tre,  f3_trd,   f4_trb                        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Set default values for plots
    plotconf=struct();
    plotconf.close_figs=1;
    plotconf.ext='meta';
    plotconf.savepath='.';
    plotconf.figsize=[0,0,3600,2400];
    plotconf.dpi=220;
    plotconf.fontname='Arial';
    plotconf.fontnamelatex='CMU Serif';
    plotconf.fontsize=12;
    plotconf.phticks=[-pi,0,pi];
    plotconf.phlabels={'$-\pi$','0','$\pi$'};
    plotconf.tsticks=[0,25,50,75,100];
    plotconf.tslabels={'0','25','50','75','100'};
    plotconf.dolatex=0;

    %Plot figures
    plot_fig1({trs.f1_tre,trs.f1_trd},deepcopy(plotconf));
    plot_fig2(deepcopy(plotconf));
    plot_fig3(trs,deepcopy(plotconf));
    plot_fig4(trs,deepcopy(plotconf));

end

function plot_fig1(trs,conf)
    titles={'Easy Trial','Difficult Trial'};
    figure;
    for n=1:2
        %Panel N: Time-based Histograms: Experimental and simulated
        tr=trs{n};
        subplot(1,2,n);hold on;
        plot(tr.ts.ph_phhist,-tr.ts.omeganorm_phhist,'k');
        plot(tr.ts.ph_phhist,tr.ts.xnorm_phhist/2+0.5,'k--');
        xlim([-pi,pi]);
        if conf.dolatex
            %format_ticks(gca,conf.phlabels,[],conf.phticks,[],[],[],[],'FontSize',conf.fontsize,'FontName',conf.fontname);
            title(titles{n},'interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontnamelatex);
            xlabel('$\theta$','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontnamelatex)
            ylabel('$\dot{\theta_{Norm}}$ ','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontnamelatex)
            if n==1
                legend({'$\dot{\theta_{Norm}}$','$x_{Norm}$'},'interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontnamelatex);
            end
        else
            %format_ticks(gca,conf.phlabels,[],conf.phticks,[],[],[],[],'FontSize',conf.fontsize,'FontName',conf.fontname);
            title(titles{n},'FontSize',conf.fontsize,'FontName',conf.fontname);
            xlabel('\theta','FontSize',conf.fontsize,'FontName',conf.fontname)
            ylabel('\dot{\theta_{norm}} ''FontSize',conf.fontsize,'FontName',conf.fontname)
            if n==1
                legend({'\dot{\theta_{norm}}','x_{norm}'},'FontSize',conf.fontsize,'FontName',conf.fontname);
            end
        end
    end
    savefig('models_fig1',conf);
    if conf.close_figs, close; end
end

function plot_fig2(conf)
    %Simulate models with different distances to ghost
    m1=ModelMonostable('auto1D');
    m2=ModelMonostable('auto1D');
    m3=ModelMonostable('auto1D');
    m1.params{1}=3.1;
    m2.params{1}=3.3;
    m3.params{1}=3.6;
    m1.run
    m2.run
    m3.run

    %Defnie figure and axis
    figure;
    idx=1:1000;
    ax1=subplot(3,2,[1,3,5]);hold on;
    ax2=subplot(3,2,2);hold on;
    ax3=subplot(3,2,4);hold on;
    ax4=subplot(3,2,6);hold on;

    %phhists plots
    plot(ax1,m1.ph_phhist,-m1.omega_phhist,'k-');
    plot(ax1,m2.ph_phhist,-m2.omega_phhist,'k--');
    plot(ax1,m3.ph_phhist,-m3.omega_phhist,'k-.');
    xlim(ax1,[-pi,pi]);
    if conf.dolatex
        %format_ticks(ax1,conf.phlabels,[],[],[],[],conf.phticks,[],'FontSize',conf.fontsize,'FontName',conf.fontname);
        title(ax1,'Phase Histogram','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontnamelatex);
        xlabel(ax1,'$\theta$','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontnamelatex)
        ylabel(ax1,'$\dot{\theta}_{Norm}$','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontnamelatex)
        legend(ax1,{'$\omega = 3.1$','$\omega = 3.3$','$\omega = 4.0$'},'interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontnamelatex);
    else
        %format_ticks(ax1,conf.phlabels,[],[],[],[],conf.phticks,[],'FontSize',conf.fontsize,'FontName',conf.fontname);
        title(ax1,'Phase Histogram','FontSize',conf.fontsize,'FontName',conf.fontname);
        xlabel(ax1,'\theta','FontSize',conf.fontsize,'FontName',conf.fontname)
        ylabel(ax1,'\dot{\theta}_{Norm}','FontSize',conf.fontsize,'FontName',conf.fontname)
        legend(ax1,{'\omega = 3.1','\omega = 3.3','\omega = 4.0'},'FontSize',conf.fontsize,'FontName',conf.fontname);
    end        
    
    %tshists plots    
    plot(ax2,idx/100,m1.x(1:1000),'k-');
    plot(ax3,idx/100,m2.x(1:1000),'k--');
    plot(ax4,idx/100,m3.x(1:1000),'k-.');
    if conf.dolatex
        title(ax2,'x time series','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontnamelatex)
        xlabel(ax4,'$time (s)$','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontnamelatex)
        ylabel(ax2,'$x_{norm}$','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontnamelatex)
        ylabel(ax3,'$x_{norm}$','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontnamelatex)
        ylabel(ax4,'$x_{norm}$','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontnamelatex)
    else
        title(ax2,'x time series','FontSize',conf.fontsize,'FontName',conf.fontname)
        xlabel(ax4,'time (s)''FontSize',conf.fontsize,'FontName',conf.fontname)
        ylabel(ax2,'x_{norm}''FontSize',conf.fontsize,'FontName',conf.fontname)
        ylabel(ax3,'x_{norm}''FontSize',conf.fontsize,'FontName',conf.fontname)
        ylabel(ax4,'x_{norm}''FontSize',conf.fontsize,'FontName',conf.fontname)
    end
    
    savefig('models_fig2',conf);
    if conf.close_figs, close; end
end


function plot_fig3(trs,conf)
    tr=trs.f3_trd;
    figure;
    hold on
    idx=33000:42000;
    plot(idx/1000,2*(tr.ts.Rxnorm(idx)+1),'k--');
    plot(idx/1000,-tr.ts.Romega(idx),'k-');
    xlim([idx(1),idx(end)]/1000)
    if conf.dolatex
        xlabel('time (s)','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontnamelatex)
        ylabel('$\dot{\theta}$','interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontnamelatex)
        legend({'$x_{scaled}$','$\dot{\theta}$'},'interpreter','latex','FontSize',conf.fontsize,'FontName',conf.fontnamelatex);
    else
        xlabel('time (s)','FontSize',conf.fontsize,'FontName',conf.fontname)
        ylabel('\dot{\theta}','FontSize',conf.fontsize,'FontName',conf.fontname)
        legend({'x_{scaled}','\dot{\theta}'},'FontSize',conf.fontsize,'FontName',conf.fontname);
    end
        
    savefig('models_fig3',conf);
    if conf.close_figs, close; end
end


function plot_fig4(trs,conf)
    tr=trs.f4_trb;
    m=ModelMonostable('ed1');
    m.fit_trial2D(tr)
end

% function savefig(figname,conf)
%     if strcmp(conf.ext,'fig')
%         hgsave(gcf,figname,'all');
%     else
%         set(gcf, 'PaperUnits', 'inches', 'PaperPosition', conf.figsize/conf.dpi);
%         print(gcf,['-d',conf.ext],sprintf('-r%d',conf.dpi),figname);
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savefig(figname,gpc)    
    figname = joinpath(gpc.savepath,figname);
    if ~isempty(gpc.savepath) && exist(gpc.savepath,'dir')
        pos=gpc.figsize/gpc.dpi;
        set(gcf, 'PaperUnits', 'inches', 'PaperSize',pos(3:4),'PaperPosition', pos);
        if strcmp(gpc.ext,'fig')
            hgsave(gcf,figname,'all');
        elseif strcmp(gpc.ext,'pdf')
            mlf2pdf(gcf,figname);
        else
            print(gcf,['-d',gpc.ext],sprintf('-r%d',gpc.dpi),figname);
        end
        close gcf
    end
end
