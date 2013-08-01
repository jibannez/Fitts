function pguess=fit_trial1D(mdl,tr,do_plot)
    if nargin<3, do_plot=1;end
    
    %Get experimental trial info
    if tr.info.ID<3
        idsrt='e';
    elseif tr.info.ID>5
        idsrt='d';
    else
        idsrt='m';
    end

    %Recompute experimental omega... can't understand problem...
    omega_phhist=get_ph_histogram(tr.ts.omega,tr.ts.ph,mdl.bins);
    wfexp=tr.ts.f*2*pi;
    
    %Predefined values of circular summation coefficients
    c_values=containers.Map({'e','m','d'}, { pi/2, pi/3, pi/3});
    d_values=containers.Map({'e','m','d'}, {-pi/2, 0   , 0});

    %Parameteres data structures
    pguess=cell(size(mdl.params));
    pguess{end}=1;
    pinit=mdl.params;

    %Initial fixed guess of parameters 
    pguess{1}=4.0;
    pguess{2}=2.0;
    pguess{3}=1.0;
    pguess{4}=c_values(idsrt);
    pguess{5}=d_values(idsrt);
    
    %Run model and correct the scaling
    mdl.load_param(pguess);
    mdl.run
    pguess{end}=pguess{end}*range(omega_phhist)/range(mdl.omega_phhist);
    pguess{1}=sqrt(wfexp^2+5*pguess{end}^2);
    
    %Run model and correct w to match experimental freq
    mdl.load_param(pguess);
    mdl.run;    
    pguess{1}=sqrt(pguess{1}^2+wfexp^2-mean(mdl.phdot)^2);
    %pguess{1}=sqrt(wfexp^2+9*pguess{end}^2);
    
    if do_plot, mdl.plot_trfit1D(tr,'',pguess); end 
    mdl.load_param(pguess)
end