function pguess=fit_trial2D(mdl,tr,do_plot)
    if nargin<3, do_plot=1;end
    
    %Easy hand always first in the model (equation 1)
    if tr.info.LID < tr.info.RID
        hands={'L','R'};
    else
        hands={'R','L'};
    end
    
    %Predefined values of circular summation coefficients
    c_values=containers.Map({'e','m','d'}, { pi/2, pi/2, pi/3});
    d_values=containers.Map({'e','m','d'}, {-pi/2,-pi/4,  0.0});
    
    %First Guess of Parameters 
    pguess=cell(size(mdl.params));
    pguess{end-1}=0.2;
    pguess{end}=0.8;
    pinit=mdl.params; 

    for h=1:2
        idsrt=get_idsrt(tr.info.([hands{h},'ID']));
        omh=-tr.ts.([hands{h},'omega_phhist']);
        wf=tr.ls.([hands{h},'f'])*2*pi;
        avg1=tsmovavg(omh,'s',floor(length(omh)/4),1);
        avg2=tsmovavg(omh,'s',floor(length(omh)/8),1);
        avg1=resize_vector(avg1(~isnan(avg1)),length(omh));
        avg2=resize_vector(avg2(~isnan(avg2)),length(omh));
        %figure; hold on; plot(omh,'r');plot(avg1,'b');plot(avg2,'g');legend({'omega','avg8','avg16'})
        pguess{2+h}=range(avg1)/2;
        pguess{4+h}=range(avg1-avg2)/4;
        pguess{6+h}=c_values(idsrt);
        pguess{8+h}=d_values(idsrt);
        pguess{h}  =sqrt(wf^2+pguess{2+h}^2+pguess{4+h}^2);
    end

    %Recompute w value
    mdl.load_param(pguess);
    mdl.run;
    for h=1:2
        omexp=-tr.ts.([hands{h},'omega_phhist']);
        omsim=resize_vector(-mdl.(['omega',num2str(h),'_phhist']),length(omexp))';        
        omdiff=median(omsim-omexp);
        pguess{h}=pguess{h}-omdiff;
    end
    
    %Recompute a value
    mdl.load_param(pguess);
    mdl.run;
    for h=1:2
        %idsrt=get_idsrt(tr.info.([hands{h},'ID']));
        omexp=-tr.ts.([hands{h},'omega_phhist']);
        omsim=-mdl.(['omega',num2str(h),'_phhist']);
        omsimavg=tsmovavg(omsim,'s',floor(length(omsim)/4),1);
        omsimavg=resize_vector(omsimavg(~isnan(omsimavg)),length(omexp))';
        omexpavg=tsmovavg(omexp,'s',floor(length(omexp)/4),1);
        omexpavg=resize_vector(omexpavg(~isnan(omexpavg)),length(omexp))';        
        omdiff=median(omsimavg-omexpavg);
        pguess{2+h}=pguess{2+h}+omdiff;
    end    
    
    %Clean up, plot if need and exit
    mdl.load_param(pinit);
    if do_plot, mdl.plot_trfit2D(tr,pguess); end 
end

function idsrt=get_idsrt(id)
    if id<2.7
        idsrt='e';
    elseif id>5
        idsrt='d';
    else
        idsrt='m';
    end
end