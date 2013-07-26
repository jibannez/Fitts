function run(mdl)
    %if mdl.conf.stoch
    %    [mdl.t, mdl.ph] = mdl.ode(mdl.eq,mdl.tspan,mdl.IC,mdl.options,mdl.params{:});    
    %else
    %    [mdl.t, mdl.ph] = mdl.ode(mdl.eq,mdl.tspan,mdl.IC,mdl.options,mdl.params{:});    
    %end
    clear(mdl.eq)
    [mdl.t, mdl.ph] = mdl.ode(mdl.eq,mdl.tspan,mdl.IC,mdl.options,mdl.params{:});    
    if mdl.conf.plot, mdl.plot(); end
end