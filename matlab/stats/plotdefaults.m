function pltcfg = plotdefaults(pltcfg)
    if nargin==0, pltcfg=struct(); end
    
    pltcfg.ext='tiff';
    pltcfg.dpi=1200;
    pltcfg.col2inches=3.3;
    pltcfg.aureumprop=(1+sqrt(5))/2;
    pltcfg.do_legend=0;
    pltcfg.do_anotations=0;
    pltcfg.do_title=0;
    pltcfg.do_ylabel=1;
    pltcfg.do_grids=0;
    pltcfg.do_ticks=1;
    pltcfg.do_yticklabels=1;
    pltcfg.plot_type='subplot'; %'tight' 'figure' 'subplot'
    pltcfg.figsize=[0,0,2,2*pltcfg.aureumprop]*pltcfg.col2inches*pltcfg.dpi;
    pltcfg.fontnamelatex='CMU Serif';
    pltcfg.fontname='Arial';
    pltcfg.fontsize=4;
    pltcfg.do_latex=0;
end