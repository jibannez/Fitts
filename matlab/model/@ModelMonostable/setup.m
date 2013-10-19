function setup(mdl)
    if mdl.stype==1
        if strcmp({'e','m'},mdl.byname) | mdl.isauto
            mdl.eq='automonostableode1D';
        else
            mdl.eq='monostableode1D';
        end
        mdl.fitfcn = mdl.conf.fit1D;
        mdl.parnames=mdl.conf.parnames1D;
        mdl.IC=mdl.conf.IC1D;
        mdl.vfrange=mdl.conf.vfrange1D;
        mdl.vf_=mdl.conf.vf1D;
    elseif mdl.stype==2
        if strcmp(mdl.byname,'em') | mdl.isauto
            mdl.eq='automonostableode2D';        
        else
            mdl.eq='monostableode2D';
        end
        mdl.fitfcn= @(p, y)...
        [-p(11)*( p(1) + p(3)*sin(2*(y(:,1)'-p(7))+p(9)) + p(5)*cos(4*(y(:,1)'-p(7))))+ p(11)*sin(y(:,2)'-y(:,1)') ;...
         -p(12)*( p(2) + p(4)*sin(2*(y(:,2)'-p(8))+p(10))+ p(6)*cos(4*(y(:,2)'-p(8))))+ p(11)*sin(y(:,1)'-y(:,2)')]';   
        %mdl.fitfcn = mdl.conf.fit2D;
        mdl.vf_=mdl.conf.vf2D;
        mdl.parnames=mdl.conf.parnames2D;
        mdl.IC=mdl.conf.IC2D;
        mdl.vfrange=mdl.conf.vfrange2D;
        mdl.nc1=mdl.conf.nc1;
        mdl.nc2=mdl.conf.nc2;
        mdl.ncrange=mdl.conf.ncrange;
        mdl.ph_periods=mdl.conf.ph_periods;
    else
        error('Unknown model type')
    end
    mdl.tspan=mdl.conf.tspan;
    mdl.ode=mdl.conf.ode;
    mdl.options=mdl.conf.options;
    mdl.bins=mdl.conf.bins;
end