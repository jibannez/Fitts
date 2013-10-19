function run(mdl)
    %if mdl.conf.stoch
    %    [mdl.t, mdl.ph] = mdl.ode(mdl.eq,mdl.tspan,mdl.IC,mdl.options,mdl.params{:});    
    %else
    %    [mdl.t, mdl.ph] = mdl.ode(mdl.eq,mdl.tspan,mdl.IC,mdl.options,mdl.params{:});    
    %end
    if mdl.isauto==0
        clear(mdl.eq)
        clear('ynoise')
    end
    [mdl.t, mdl.ph] = mdl.ode(mdl.eq,mdl.tspan,mdl.IC,mdl.options,mdl.params{:});    
    if mdl.stype<2
        mdl.ph=filterdata(mdl.ph,24,50);
    else
        mdl.ph(:,1)=filterdata(mdl.ph(:,1),12,mdl.fs);
        mdl.ph(:,2)=filterdata(mdl.ph(:,2),12,mdl.fs);
    end
    if mdl.conf.plot, mdl.plot(); end
end