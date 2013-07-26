function plot_trfit2D(mdl,tr,pfit)
    if nargin==2, pfit=mdl.params; end

    if ~iscell(pfit), pfit=num2cell(pfit);end
    pinit=mdl.params;
    mdl.load_param(pfit);
    mdl.run();
    pfit=cell2mat(pfit);

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
    for h=1:2
        ph_phhist{h}=resize_vector(tr.ts.([hands{h},'ph_phhist']),phL);
        omega_phhist{h}=-resize_vector(tr.ts.([hands{h},'omega_phhist']),phL);
        xnorm_phhist{h}=resize_vector(tr.ts.([hands{h},'xnorm_phhist']),phL);
        vnorm_phhist{h}=resize_vector(tr.ts.([hands{h},'vnorm_phhist']),phL);
        anorm_phhist{h}=resize_vector(tr.ts.([hands{h},'anorm_phhist']),phL);
        ph_hist{h}=resize_vector(tr.ts.([hands{h},'ph_phhist']),tsL);
        omega_hist{h}=-resize_vector(tr.ts.([hands{h},'omega_hist']),tsL);
        xnorm_hist{h}=resize_vector(tr.ts.([hands{h},'xnorm_hist']),tsL);
        vnorm_hist{h}=resize_vector(tr.ts.([hands{h},'vnorm_hist']),tsL);
        anorm_hist{h}=resize_vector(tr.ts.([hands{h},'anorm_hist']),tsL);
        vf{h}=tr.(['vf',hands{h}]).vectors;
        ph{h}=tr.ts.([hands{h},'ph']);
        %xnorm{h}=cos(ph{h});
        %vnorm{h}=[0;diff(xnorm{h})*1000];
        %vnorm{h}=vnorm{h}/max(abs(vnorm{h}));
        xnorm{h}=tr.ts.([hands{h},'xnorm']);
        vnorm{h}=tr.ts.([hands{h},'vnorm']);
    end  
    fitfcn=mdl.fitfcn;
    omfitted=fitfcn(pfit,[linspace(-pi,pi,phL)',linspace(-pi,pi,phL)']);

    for h=1:2
        %FIGURE 1. PANEL 1: Phdot vs ph: experimental and simulated data
        figure('name',['Plot of trial fitting 1: simulated vs experimental phidot and vector field for ',hands{h},' hand']);
        ax_omg=subplot(2,2,[1,3]);hold on;
        title('Angular phase plane');        
        scatter(ax_omg,linspace(-pi,pi,phL),-omfitted(:,h),'b.');
        scatter(ax_omg,linspace(-pi,pi,phL),-mdl.(['omega',num2str(h),'_phhist']),'m.');
        scatter(ax_omg,linspace(-pi,pi,phL),omega_phhist{h},'r.');
        legend(ax_omg,{'theorethical','simulated','experimental'});
        xlabel('phase');ylabel('phase_dot');
        xlim([-pi,pi]);
        hline(0,'k');grid on;

        %FIGURE 1. PANEL 2.A. Simulated Cartesian phase planes: vector fields and trajectories
        ax_vfsim=subplot(2,2,[4]);hold on;
        title(['Simulated phase plane and vector field for ',hands{h},' hand']);
        plot(ax_vfsim,mdl.(['xnorm',num2str(h)]),mdl.(['vnorm',num2str(h)]),'color',[1,.7,1])
        %quiver(ax_vfsim,mdl.vfcart{:});
        xlabel('xnorm');ylabel('vnorm')
        xlim(ax_vfsim,[-1,1]);ylim(ax_vfsim,[-1, 1]);
        hline(0,'k');vline(0,'k');grid on;

        %FIGURE 1. PANEL 2.B. Experimental Cartesian phase planes: vector fields and trajectories
        ax_vfexp=subplot(2,2,[2]);hold on;
        vf_=vf{h};
        title(['Experimental phase plane and vector field for ',hands{h},' hand']);
        i=isfinite(vf_{1}) & isfinite(vf_{2});
        [X,Y]=meshgrid(vf_{end}{1},vf_{end}{2});
        plot(ax_vfexp,xnorm{h},vnorm{h},'color',[1,.7,1]);
        quiver(ax_vfexp,X(i),Y(i),vf_{1}(i),vf_{2}(i));
        xlabel('xnorm');ylabel('vnorm')
        xlim(ax_vfexp,[-1,1]);ylim(ax_vfexp,[-1, 1]);
        hline(0,'k');vline(0,'k');grid on;

        %FIGURE 2: Time-based Histograms: Experimental and simulated
        figure('name',['Plot of trial fitting 2: simulated vs experimental phidot and vector field for ',hands{h},' hand']);
        ax_tshist=subplot(1,2,[1,2]);hold on;
        title('TS-based histograms');
        plot(ax_tshist,t,xnorm_hist{h},'r');
        plot(ax_tshist,t,vnorm_hist{h},'b');
        %plot(ax_tshist,t,anorm_hist,'y');
        plot(ax_tshist,t,ph_hist{h}./pi,'k');
        plot(ax_tshist,t,omega_hist{h}./max(omega_hist{h}),'m');

        plot(ax_tshist,t,mdl.(['xnorm',num2str(h),'_hist']),'r--');
        plot(ax_tshist,t,mdl.(['vnorm',num2str(h),'_hist']),'b--');
        %plot(ax_tshist,t,mdl.anorm_hist,'m--');
        plot(ax_tshist,t,mdl.(['ph',num2str(h),'_hist'])./pi,'k--');
        plot(ax_tshist,t,mdl.(['omeganorm',num2str(h),'_hist']),'m--');
        legend(ax_tshist,{'xp xnorm','xp vnorm','xp ph','xp omega','mdl xnorm','mdl vnorm','mdl ph','mdl omega'});
        hline(0,'k');grid on;

        %FIGURE 3: Phase-based Histograms: Experimental and simulated
        figure('name',['Plot of trial fitting 3: simulated vs experimental phidot and vector field for ',hands{h},' hand']);
        ax_phhist=subplot(1,2,[1,2]);hold on;
        title('PH-based histograms');
        scatter(ax_phhist,linspace(-pi,pi,phL),xnorm_phhist{h},'r.');
        scatter(ax_phhist,linspace(-pi,pi,phL),vnorm_phhist{h},'b.');
        scatter(ax_phhist,linspace(-pi,pi,phL),omega_phhist{h}./max(omega_phhist{h}),'m.');
        scatter(ax_phhist,mdl.(['ph',num2str(h),'_phhist']),mdl.(['xnorm',num2str(h),'_phhist']),'rx');
        scatter(ax_phhist,mdl.(['ph',num2str(h),'_phhist']),mdl.(['vnorm',num2str(h),'_phhist']),'bx');
        scatter(ax_phhist,mdl.(['ph',num2str(h),'_phhist']),mdl.(['omeganorm',num2str(h),'_phhist']),'mx');
        legend(ax_phhist,{'xp xnorm','xp vnorm','xp omega','mdl xnorm','mdl vnorm','mdl omega'});
        xlim([-pi,pi]);
        hline(0,'k');vline(0,'k');
        grid on;
    end

    mdl.load_param(pinit);

end
