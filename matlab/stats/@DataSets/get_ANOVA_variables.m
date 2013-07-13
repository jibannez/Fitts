function get_ANOVA_variables(ds)
    for v=1:length(ds.vtypes)
        if strcmp('osc',ds.vtypes{v})
            vars=Oscillations.get_anova_variables();
            ds.vnamesB=[ ds.vnamesB, vars];
            ds.vnamesU=[ ds.vnamesU, vars];
            ds.vtypesB=[ ds.vtypesB, repmat(ds.vtypes(v),1,length(vars))];
            ds.vtypesU=[ ds.vtypesU, repmat(ds.vtypes(v),1,length(vars))];
        elseif strcmp('vf',ds.vtypes{v})
            vars=VectorField.get_anova_variables();
            ds.vnamesB=[ ds.vnamesB, vars];
            ds.vnamesU=[ ds.vnamesU, vars];
            ds.vtypesB=[ ds.vtypesB, repmat(ds.vtypes(v),1,length(vars))];
            ds.vtypesU=[ ds.vtypesU, repmat(ds.vtypes(v),1,length(vars))];        
        else
            vars=LockingStrength.get_anova_variables();
            ds.vnamesB=[ ds.vnamesB, vars];
            ds.vtypesB=[ ds.vtypesB, repmat(ds.vtypes(v),1,length(vars))];        
        end    
    end
    ds.vnoB=length(ds.vnamesB);
    ds.vnoU=length(ds.vnamesU);
end
