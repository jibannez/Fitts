function res=analyze_var(phoc,factors)
    %That's an easy one. It runs holm test after preparing data for the
    %analysys. After that, it returns crosslevel pairwise comparisons

    res = struct();

    if phoc.isdid
        if strcmp('all',factors)
            factors={'grp','ss','did'};
        else
            factors=phoc.sort_postgroups_did(factors);
        end
        fdata = phoc.rearrange_var_data(factors);
    else
        if strcmp('all',factors),
            factors={'grp','idl','idr','ss'};
        else
            phoc.sort_postgroups(factors);
        end
        fdata = phoc.rearrange_var_data(factors);
    end


    [phgrps, phgrplabels]=phoc.get_posthoc_groups(fdata,factors);

    Holmmat=phoc.get_holmmat(phgrps,0,0.5,2,phgrplabels);

    [f1mat,f2mat]=phoc.get_pairwise_comparisons(Holmmat+Holmmat',fdata,factors);

    res.factors = factors;
    res.data = fdata;
    res.phgrps = phgrps;
    res.phgrplabels = phgrplabels;
    res.Holmmat = Holmmat;
    res.f1mat = f1mat;
    res.f2mat = f2mat;
end