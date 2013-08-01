function plot_trfit1D(mdl,tr,h,pfit,do_run)
if nargin<5, do_run=1; end
if nargin==3, pfit=h; h=''; end
if nargin==2, pfit=mdl.params; h=''; end

if do_run
    mdl.load_param(pfit);
    mdl.run();
elseif isempty(mdl.t)
    mdl.load_param(pfit);
    mdl.run();
end

%Get simulated sizes to rescale experimental vectors
tsL=length(mdl.ph_hist);
phL=length(mdl.ph_phhist);
t=1:tsL;

%Get experimental time series and scaled histograms 
ph=tr.ts.([h,'ph']);
omega=diff(unwrap(ph)*1000);
omega=-[omega(1);omega];
x=cos(ph);
v=[0;diff(x)*1000];
xnorm=normalize(x);
vnorm=normalize(v);
xnorm_hist=normalize(get_ts_histogram(x,tr.ts.peaks,tsL));
vnorm_hist=normalize(get_ts_histogram(v,tr.ts.peaks,tsL));
xnorm_phhist=normalize(get_ph_histogram(x,ph,phL));
vnorm_phhist=normalize(get_ph_histogram(v,ph,phL));
omega_phhist=get_ph_histogram(omega,ph,phL);
omeganorm_phhist=normalize(get_ph_histogram(omega,ph,phL));
omega_hist=get_ts_histogram(omega,tr.ts.peaks,tsL);
omeganorm_hist=normalize(get_ts_histogram(omega,tr.ts.peaks,tsL));
%xnorm=tr.ts.([h,'xnorm']);
%vnorm=tr.ts.([h,'vnorm']);
%omeganorm_hist=-tr.ts.([h,'omeganorm_hist']);
%vf=tr.(['vf',h]).vectors;    

%FIGURE 1. PANEL 1: Phdot vs ph: experimental and simulated data
figure('name','Plot of trial fitting 1: simulated vs experimental phidot and vector field');
ax_omg=subplot(3,2,1);hold on;
title('Angular phase plane');
plot(ax_omg,linspace(-pi,pi,phL),-mdl.omega_phhist,'b');
plot(ax_omg,linspace(-pi,pi,phL),omega_phhist,'r');
legend(ax_omg,{'simulated','experimental'});
xlabel('\theta');ylabel('\theta dot');
xlim([-pi,pi]);
hline(0,'k');grid on;

% ax_omg=subplot(2,2,3);hold on;
% title('Temporal evolution of \theta dot');
% plot(ax_omg,-mdl.omega_hist,'b');
% plot(ax_omg,omega_hist,'r');
% xlabel('time (%)');ylabel('phase_dot');
% xlim([0,length(omega_hist)]);
% hline(0,'k');grid on;

%FIGURE 1. PANEL 2.A. Simulated Cartesian phase planes: vector fields and trajectories
% ax_vfsim=subplot(2,2,[4]);hold on;
% title('Simulated phase plane and vector field');
% plot(ax_vfsim,mdl.xnorm,mdl.vnorm,'color',[1,.7,1])
% quiver(ax_vfsim,mdl.vfcart{:});
% xlabel('xnorm');ylabel('vnorm')
% xlim(ax_vfsim,[-1,1]);ylim(ax_vfsim,[-1, 1]);
% hline(0,'k');vline(0,'k');grid on;

%FIGURE 1. PANEL 2.B. Experimental Cartesian phase planes: vector fields and trajectories
% ax_vfexp=subplot(2,2,[2]);hold on;
% title('Experimental phase plane and vector field');
% i=isfinite(vf{1}) & isfinite(vf{2});
% [X,Y]=meshgrid(vf{end}{1},vf{end}{2});
% plot(ax_vfexp,xnorm,vnorm,'color',[1,.7,1]);
% quiver(ax_vfexp,X(i),Y(i),vf{1}(i),vf{2}(i));
% xlabel('xnorm');ylabel('vnorm')
% xlim(ax_vfexp,[-1,1]);ylim(ax_vfexp,[-1, 1]);
% hline(0,'k');vline(0,'k');grid on;

%FIGURE 2: Time-based Histograms: Experimental and simulated
%figure('name','Plot of trial fitting 2: simulated vs experimental phidot and vector field');
%ax_tshist=subplot(1,2,[1,2]);hold on;
ax_tshist=subplot(3,2,2);hold on;
title('TS-based histograms');
plot(ax_tshist,t,xnorm_hist,'r');
plot(ax_tshist,t,vnorm_hist,'b');

plot(ax_tshist,t,mdl.xnorm_hist,'r--');
plot(ax_tshist,t,mdl.vnorm_hist,'b--');
%legend(ax_tshist,{'x exp','v exp','x sim','v sim'});
hline(0,'k');grid on;

%FIGURE 3: Phase-based Histograms: Experimental and simulated
%figure('name','Plot of trial fitting 3: simulated vs experimental phidot and vector field');
%ax_phhist=subplot(1,2,[1,2]);hold on;
% ax_phhist=subplot(2,2,[2]);hold on;
% title('PH-based histograms');
% plot(ax_phhist,linspace(-pi,pi,phL),xnorm_phhist,'r');
% plot(ax_phhist,linspace(-pi,pi,phL),vnorm_phhist,'b');
% %plot(ax_phhist,linspace(-pi,pi,phL),omeganorm_phhist,'m');
% plot(ax_phhist,mdl.ph_phhist,mdl.xnorm_phhist,'r--');
% plot(ax_phhist,mdl.ph_phhist,mdl.vnorm_phhist,'b--');
% %plot(ax_phhist,mdl.ph_phhist,-mdl.omeganorm_phhist,'m--');
% legend(ax_phhist,{'x exp','v exp','x sim','v sim'});
% xlim([-pi,pi]);
% hline(0,'k');vline(0,'k');
% grid on;

%FIGURE 4: Time Series: Experimental and simulated
omegasim=-resize_vector(filterdata(mdl.phdot,12,mdl.fs),length(mdl.phdot)*10);
omegaexp=-tr.ts.omega;
if length(omegasim) > length(omegaexp)
    omegasim=omegasim(1:length(omegaexp));
else
    omegaexp=omegaexp(1:length(omegasim));
end
ylimits=[min(omegasim)-1,max(omegasim)+1];
%figure('name','Plot of trial fitting 4: Experimental and simulated Time Series'); 
subplot(3,2,[3,4]); hold on
title('Experimental \theta dot')
plot(omegaexp,'b');
%hline(mean(omegaexp),'k')
hline(tr.ts.f*2*pi,'k')
ylim(ylimits)
xlim([0,length(omegaexp)])
subplot(3,2,[5,6]); hold on
title('Simulated \theta dot')
plot(omegasim,'r')
%hline(mean(omegasim),'k')
hline(-mean(mdl.phdot),'k')
ylim(ylimits)
xlim([0,length(omegaexp)])
disp(['Experimental frequency: ',num2str(tr.ts.f*2*pi),'  Simulated frequency: ',num2str(-mean(mdl.phdot))])
end
