function gp = get_lineplot_props(gp,factors,DIDmode)
    %Fill factor 1 related graphic properties
    if strcmp('grp',factors{1}) 
        gp.colors={[1,0.2,0.2],[0.2,0.2,1]};
        gp.linespec={'-ok','-.sk'};
        gp.linewidth=[0.6,0.7];
        gp.labels={'Strong Coupling','Weak Coupling'};
        gp.f1={'ST','WK'};
        gp.f1name='Group';
    elseif strcmp('ss',factors{1})
        gp.colors={[1,0.2,0.2],[0.2,0.2,1],[0.2,1,0.2]};
        gp.linespec={'-ok','-.sk',':dk'};
        gp.linewidth=[0.6,0.7,0.8];
        gp.labels={'S1','S2','S3'};
        gp.f1=gp.labels;
        gp.f1name='Session';
    elseif strcmp(DIDmode,'3levels')
        gp.colors={[1,0.2,0.2],[0.2,0.2,1],[0.2,1,0.2]};
        gp.linespec={'-ok','-.sk',':dk'};
        gp.linewidth=[0.6,0.7,0.8];
        gp.labels={'Zero','Small','Large'};
        gp.f1={'Zero','Small','Large'};
        gp.f1name='ID_{diff}';
    elseif strcmp(DIDmode,'6levels2')
        gp.colors={[0.2,1,1],[0.2,0.2,1],[0.2,0.2,0.2],[0.4,0.4,0.4],[0.4,0.4,1],[0.4,1,1]};
        gp.linespec={'-ok','-sk','-dk','--^k','--vk','--*k'};
        gp.linewidth=[0.6,0.8,1,0.6,0.8,1];
        %gp.labels={'LI','SI','ZE','ZD','SC','LC'};
        gp.labels={'+2','+1','0_D','0_E','-1','-2'};
        gp.f1={'+2','+1','0_D','0_E','-1','-2'};
        gp.f1name='ID_{diff}';
    end
    %Fill factor 2 related graphic properties
    if strcmp('grp',factors{2}) 
        gp.xticks=[1,2];     
        gp.xticklabels={'Strong Coupling','Weak Coupling'};
        gp.f2={'ST','WK'};
        gp.f2name='Group';
    elseif strcmp('ss',factors{2})
        gp.xticks=[1,2,3];
        gp.xticklabels={'S1','S2','S3'};
        gp.f2=gp.xticklabels;
        gp.f2name='Session';
    elseif strcmp(DIDmode,'3levels')
        gp.xticks=[1,2,3];        
        gp.xticklabels={'Zero','Small','Large'};
        gp.f2={'Zero','Small','Large'};
        gp.f2name='ID_{diff}';
    elseif strcmp(DIDmode,'6levels2')
        gp.xticks=[1,2,3,4,5,6];        
        gp.xticklabels={'+2','+1','0_D','0_E','-1','-2'};
        gp.f2={'+2','+1','0_D','0_E','-1','-2'};
        gp.f2name='ID_{diff}';
    end
    %Fill ylabel information
    gp=get_yprops(gp.vname,gp);
    gp.figsize=floor([0,0,2,2/gp.aureumprop].*gp.col2inches.*gp.dpi);
    gp.do_legend=1;
end