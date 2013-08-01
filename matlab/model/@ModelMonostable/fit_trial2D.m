function pguess=fit_trial2D(mdl,tr,do_plot)
    if nargin<3, do_plot=1;end
    
    %Easy hand always first in the model (equation 1)
    if tr.info.LID < tr.info.RID
        hands={'L','R'};
    else
        hands={'R','L'};
    end
    
    %Predefined values of circular summation coefficients
    %c_values=containers.Map({'e','m','d'}, { pi/2, pi/2, pi/3});
    %d_values=containers.Map({'e','m','d'}, {-pi/2,-pi/4,  0.0});
    c_values=containers.Map({'e','m','d'}, { pi/2, pi/3, pi/3});
    d_values=containers.Map({'e','m','d'}, {-pi/2, 0   , 0});
    
    %Parameteres data structures
    pguess=cell(size(mdl.params));
    omega_phhist=cell([2,1]);
    wfexp=cell([2,1]);
    pguess{end-2}=0.5;
    pguess{end-1}=1.0;
    pguess{end}=1.0;
    %pinit=mdl.params; 
    
    %Initial fixed guess of parameters   
    for h=1:2
        %Recompute experimental omega... can't understand problem...
        omega_phhist{h}=get_ph_histogram(tr.ts.([hands{h},'omega']),tr.ts.([hands{h},'ph']),mdl.bins);
        wfexp{h}=tr.ts.([hands{h},'f'])*2*pi;
        idsrt=get_idsrt(tr.info.([hands{h},'ID']));     
        pguess{ h }=4.0;
        pguess{2+h}=2.0;
        pguess{4+h}=1.0;
        pguess{6+h}=c_values(idsrt);
        pguess{8+h}=d_values(idsrt);        
    end

    %Run model and correct the scaling
    mdl.load_param(pguess);
    mdl.run
    for h=1:2
        idx=length(pguess)-(2-h);
        pguess{idx}=pguess{end}*range(omega_phhist{h})/range(mdl.(['omega',num2str(h),'_phhist']));
        pguess{ h }=sqrt(wfexp{h}^2+5*pguess{idx}^2);
        %pguess{idx}=pguess{idx}*range(tr.ts.([hands{h},'omega_phhist']))/range(mdl.(['omega',num2str(h),'_phhist']));
    end

    %Run model and correct w to match experimental freq
    mdl.load_param(pguess);
    mdl.run;
    for h=1:2
        pguess{h}=sqrt(pguess{h}^2+wfexp{h}^2-mean(mdl.phdot(:,h))^2);
    end
    
    if do_plot, mdl.plot_trfit2D(tr,pguess); end 
    %mdl.load_param(pguess);
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