function pguess=fit_trial1D(mdl,tr,do_plot)
    if nargin<3, do_plot=1;end

    plot_debug=0;
    
    %Get experimental trial info
    if tr.info.ID<3
        idsrt='e';
    elseif tr.info.ID>5
        idsrt='d';
    else
        idsrt='m';
    end
    omexp=-tr.ts.omega_phhist;
    wf=tr.ts.f*2*pi;
    
   
    
    %Predefined values of circular summation coefficients
    c_values=containers.Map({'e','m','d'}, { pi/2, pi/2, pi/3});
    d_values=containers.Map({'e','m','d'}, {-pi/2,-pi/4,  0});
    
    %Parameteres data structures
    pguess=cell(size(mdl.params));
    pguess{end}=1.0;
    pinit=mdl.params;
    
    % New idea for optimization algorithm: 
    %   1-find the best fitting tau by lse on substracted detrend omegas
    %   2-substract the mean difference to w
    %
    % mdl.run
    % pp{end}=pp{end}*range(trd1.ts.omega_phhist)/range(m1.omega_phhist)
    % mdl.run
    % pp{1}=pp{1}+(min(-trd1.ts.omega_phhist)-min(-m1.omega_phhist))/pp{end}
    
    %Initial Guess of Parameters   
    pguess{2}=2.0;
    pguess{3}=1.0;
    pguess{4}=c_values(idsrt);
    pguess{5}=d_values(idsrt);
    pguess{1}=4.0;%sqrt(wf^2+pguess{2}^2+pguess{3}^2);
    
    %Run model and correct the scaling
    mdl.load_param(pguess);
    mdl.run
    pguess{end}=pguess{end}*range(tr.ts.omega_phhist)/range(mdl.omega_phhist);
    %Run model and correct w
    mdl.load_param(pguess);
    mdl.run;
    pguess{1}=pguess{1}+(min(-tr.ts.omega_phhist)-min(-mdl.omega_phhist))/pguess{end};
    if do_plot, mdl.plot_trfit1D(tr,'',pguess); end 
    mdl.load_param(pguess)
end

%Old method, testing new one yet...
%     
%     %First Guess of Parameters   
%     avg1=tsmovavg(omexp,'s',floor(length(omexp)/4),1);
%     avg2=tsmovavg(omexp,'s',floor(length(omexp)/8),1);
%     avg1=resize_vector(avg1(~isnan(avg1)),length(omexp));
%     avg2=resize_vector(avg2(~isnan(avg2)),length(omexp));
%     
%     pguess{2}=range(avg1)/2;
%     pguess{3}=range(avg1-avg2)/4;
%     pguess{4}=c_values(idsrt);
%     pguess{5}=d_values(idsrt);
%     pguess{1}=sqrt(wf^2+pguess{2}^2+pguess{3}^2);
%     
%     %Run model with new parameter guess
%     mdl.load_param(pguess);
%     mdl.run;
%     
%     %Plot previous guess
%     if plot_debug
%         figure; hold on; 
%         plot(omexp,'r');
%         plot(avg1,'b');
%         plot(avg2,'g');
%         plot(avg1-avg2,'k--');
%         plot(resize_vector(-mdl.omega_phhist,length(omexp))','m');
%         legend({'omega','avg1','avg2','diff','omsim'})
%     end
%     
%     %Recompute w value
%     omsim=resize_vector(-mdl.omega_phhist,length(omexp))';    
%     omdiff=median(omsim-omexp);
%     pguess{1}=pguess{1}-omdiff;
%     
%     %Run model with new parameter guess
%     mdl.load_param(pguess);
%     mdl.run;
%     
%     %Plot previous guess
%     if plot_debug
%         figure; hold on; 
%         plot(omsim,'b');
%         plot(omexp,'r');
%         plot(omsim-omexp,'k');
%         plot(resize_vector(-mdl.omega_phhist,length(omexp)),'b--'); 
%         legend({'omsim','omexp','diff','omsimnew'});
%     end
%     
%     %Recompute a value
%     omsim=-mdl.omega_phhist;
%     omsimavg=tsmovavg(omsim,'s',floor(length(omsim)/4),1);
%     omsimavg=resize_vector(omsimavg(~isnan(omsimavg)),length(omexp))';
%     omexpavg=tsmovavg(omexp,'s',floor(length(omexp)/4),1);
%     omexpavg=resize_vector(omexpavg(~isnan(omexpavg)),length(omexp))';
%     omdiff=median(omsimavg-omexpavg); 
%     pguess{2}=pguess{2}+omdiff;
%     
%     %Last plot
%     if plot_debug
%         mdl.load_param(pguess);
%         mdl.run;
%         figure; hold on; 
%         plot(omsim,'b');
%         plot(omsimavg,'b.');
%         plot(omexp,'r');
%         plot(omexpavg,'r.');
%         plot(omsimavg-omexpavg,'k');
%         plot(resize_vector(-mdl.omega_phhist,length(omexp)),'b--');
%         legend({'omsim','avgsim','omexp','avgexp','diff','newomsim'});
%     end
%     
%     %Clean up, plot if need and exit
%     mdl.load_param(pinit);
%     if do_plot, mdl.plot_trfit1D(tr,'',pguess); end 
% end