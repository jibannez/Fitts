function get_barplotdid6_props(gpc,bi)
    %Fill ylabel information    
    set(0,'DefaultTextFontname', gpc.fontname)
    set(0,'DefaultAxesFontName', gpc.fontname)
    gpc.figsize=floor([0,0,2,4./gpc.aureumprop].*gpc.col2inches.*gpc.dpi);
    gpc.xmin = 0;
    gpc.xmax = (3*gpc.franges(2)+1)*gpc.franges(1)-1;    
    get_yprops(gpc);
    gpc.ymin = nanmin(filterOutliers(bi(:)));
    gpc.ymax = nanmax(filterOutliers(bi(:)));
    gpc.yrange=gpc.ymax-gpc.ymin;
    gpc.get_xlabels_pos();    
    %gpc.ylim=[gpc.ymin-gpc.yrange/7,gpc.ymax+gpc.yrange/7];

    % Factor 2, determines legend names and coloring scheme
    if strcmp(gpc.factors{end},'grp')
        gpc.names ={'Coupled','Uncoupled'};
        gpc.colors={[[0.6,0.2,0.2] ; [0.8,0.2,0.2];[1,0.2,0.2]],...
            [[0.2,0.2,1]   ; [0.2,0.2,0.8];[0.2,0.2,0.6]]};
    elseif strcmp(gpc.factors{end},'did')
        gpc.names ={'+2','+1','0_D','0_E','-1','-2'};
        gpc.colors={ [[0.45,0.45,0.45];    [0.5,0.5,0.5];     [0.55,0.55,0.55]],...
            [[0.45,0.45,0.45];    [0.5,0.5,0.5];     [0.55,0.55,0.55]],...
            [[0.45,0.45,0.45];    [0.5,0.5,0.5];     [0.55,0.55,0.55]],...
            [[0.45,0.45,0.45];    [0.5,0.5,0.5];     [0.55,0.55,0.55]],...
            [[0.45,0.45,0.45];    [0.5,0.5,0.5];     [0.55,0.55,0.55]],...
            [[0.45,0.45,0.45];    [0.5,0.5,0.5];     [0.55,0.55,0.55]] };
    end
    
    % Factor 1 labels
    if strcmp(gpc.factors{1},'grp')
        gpc.xlabels={'Coupled','Uncoupled'};
    elseif strcmp(gpc.factors{1},'did')
        gpc.xlabels={'+2','+1','0_D','0_E','-1','-2'};%{'Zero','Small','Large'};
    end
end