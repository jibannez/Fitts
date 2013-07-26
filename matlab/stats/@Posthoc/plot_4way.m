function plot_4way(phoc)
    phoc.order=1;
    plot_posthoc_var([phoc.vname,'L'],{{'grp','ss','did'}},0);
    plot_posthoc_var([phoc.vname,'R'],{{'grp','ss','did'}},0);
    phoc.order=0;
    plot_posthoc_var([phoc.vname,'L'],{{'grp','ss','did'}},0);
    plot_posthoc_var([phoc.vname,'R'],{{'grp','ss','did'}},0);
end
