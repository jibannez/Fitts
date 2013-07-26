function load_ppset(mdl,d)
    mdl.subs_param(d.pname,d.p);
    mdl.t     = d.t;
    mdl.ph    = d.ph;
end