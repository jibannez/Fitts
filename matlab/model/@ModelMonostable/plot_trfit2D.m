function plot_trfit2D(mdl,tr,pfit)
    if nargin==2, pfit=mdl.params; end
    
    use_cosph=0;
    mdl.load_param(pfit);
    mdl.run();
    
    %Easy hand always first in the model (equation 1)
    if tr.info.LID < tr.info.RID
        hands={'L','R'};
    else
        hands={'R','L'};
    end

    %Get simulated sizes to rescale experimental vectors
    tsL=length(mdl.ph_hist);
    phL=length(mdl.ph_phhist);
    t=1:tsL;

    %Get experimental time series and scaled histograms 
    if use_cosph
        for h=1:2
            ph{h}=tr.ts.([hands{h},'ph']);
            omega{h}=diff(unwrap(ph{h})*1000);
            omega{h}=-[omega{h}(1);omega{h}];
            x{h}=cos(ph{h});
            v{h}=[0;diff(x{h}*1000)];
            xnorm{h}=normalize(x{h});
            vnorm{h}=normalize(v{h});
            xnorm_hist{h}=normalize(get_ts_histogram(x{h},tr.ts.([hands{h},'peaks']),tsL));
            vnorm_hist{h}=normalize(get_ts_histogram(v{h},tr.ts.([hands{h},'peaks']),tsL));
            xnorm_phhist{h}=normalize(get_ph_histogram(x{h},ph{h},phL));
            vnorm_phhist{h}=normalize(get_ph_histogram(v{h},ph{h},phL));
            omega_phhist{h}=get_ph_histogram(omega{h},ph{h},phL);
            omeganorm_phhist{h}=normalize(omega_phhist{h});
            omega_hist{h}=get_ts_histogram(omega{h},tr.ts.([hands{h},'peaks']),tsL);
            omeganorm_hist{h}=normalize(omega_hist{h});
        end        
    else
        for h=1:2
            ph_phhist{h}=resize_vector(tr.ts.([hands{h},'ph_phhist']),phL);
            omega_phhist{h}=-resize_vector(tr.ts.([hands{h},'omega_phhist']),phL);
            omeganorm_phhist{h}=-resize_vector(normalize(tr.ts.([hands{h},'omega_phhist'])),phL);
            xnorm_phhist{h}=resize_vector(tr.ts.([hands{h},'xnorm_phhist']),phL);
            vnorm_phhist{h}=resize_vector(tr.ts.([hands{h},'vnorm_phhist']),phL);
            anorm_phhist{h}=resize_vector(tr.ts.([hands{h},'anorm_phhist']),phL);
            ph_hist{h}=resize_vector(tr.ts.([hands{h},'ph_phhist']),tsL);
            omega_hist{h}=-resize_vector(tr.ts.([hands{h},'omega_hist']),tsL);
            omeganorm_hist{h}=-resize_vector(normalize(tr.ts.([hands{h},'omega_hist'])),tsL);
            xnorm_hist{h}=resize_vector(tr.ts.([hands{h},'xnorm_hist']),tsL);
            vnorm_hist{h}=resize_vector(tr.ts.([hands{h},'vnorm_hist']),tsL);
            anorm_hist{h}=resize_vector(tr.ts.([hands{h},'anorm_hist']),tsL);
            vf{h}=tr.(['vf',hands{h}]).vectors;
            ph{h}=tr.ts.([hands{h},'ph']);
            xnorm{h}=tr.ts.([hands{h},'xnorm']);
            vnorm{h}=tr.ts.([hands{h},'vnorm']);
        end
    end

    figure('name','Plot of trial fitting: simulated vs experimental phase space and time series');
    for h=1:2
        %PANEL 1.h: Phdot vs ph: Experimental and simulated data        
        ax_omg=subplot(2,2,1+2*(h-1));hold on;
        title('Angular phase plane');
        plot(ax_omg,mdl.(['ph',num2str(h),'_phhist']),-mdl.(['omega',num2str(h),'_phhist']),'b');
        plot(ax_omg,linspace(-pi,pi,phL),omega_phhist{h},'r');
        legend(ax_omg,{'simulated','experimental'});
        xlabel('\theta');ylabel('\theta dot');
        xlim([-pi,pi]);
        hline(0,'k');grid on;
        
        %PANEL 2.h: Time-based Histograms: Experimental and simulated
        ax_tshist=subplot(2,2,2+2*(h-1));hold on;
        title('TS-based histograms');
        plot(ax_tshist,t,xnorm_hist{h},'r');
        plot(ax_tshist,t,vnorm_hist{h},'b');
        plot(ax_tshist,t,mdl.(['xnorm',num2str(h),'_hist']),'r--');
        plot(ax_tshist,t,mdl.(['vnorm',num2str(h),'_hist']),'b--');
        hline(0,'k');grid on;
    end      
        
    %FIGURE 2: Time Series: Experimental and simulated
    figure('name','Plot of simulated vs experimental time series');
    ax_exp=subplot(2,1,1); hold on; title(ax_exp,'Experimental \theta dot');
    ax_sim=subplot(2,1,2); hold on; title(ax_sim,'Simulated \theta dot');
    colors={'r','b'};
    ylimits=[0,0];    
    for h=1:2
        %Get data 
        omegasim=-resize_vector(mdl.phdot(:,h),length(mdl.phdot(:,h))*10);
        omegaexp=-tr.ts.([hands{h},'omega']);
        if length(omegasim) > length(omegaexp)
            omegasim=omegasim(1:length(omegaexp));
        else
            omegaexp=omegaexp(1:length(omegasim));
        end
        
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
        plot(ax_exp,omegaexp,colors{h})    
        xlim(ax_exp,[0,length(omegaexp)])
        grid on
        
        %Plot simulated theta dot
        plot(ax_sim,omegasim,colors{h})
        xlim(ax_sim,[0,length(omegaexp)]);
        grid on
        
        %Display numerical results
        disp(['Results for hand ',hands{h}])
        disp(['Experimental frequency: ',num2str(tr.ts.([hands{h},'f'])*2*pi),...
            '  Simulated frequency: ',num2str(-mean(mdl.phdot(:,h)))])
    end
    ylim(ax_exp,ylimits);
    ylim(ax_sim,ylimits);
    
    %mdl.load_param(pinit);

end
