classdef GroupDIDPlotConfig < handle
    properties
        data
        data_scatter
        vname
        names
        hnames
        factors
        franges
        two_hands=0
        colors
        xlabels
        ylabels
        xlabels_pos
        ylabels_pos
        ymin
        ymax
        yrange
        ylim
        yticks
        yticklabels
        xmin
        xmax
        ss    
        
        %Line plots specific
        xticks
        %yticks
        xticklabels
        yminorticks
        %yticklabels
        %colors
        f2
        f2name        
        linespec
        linewidth
        labels
        f1
        f1name
    
        %Global plot configurations 
        ext
        dpi
        col2inches
        aureumprop
        do_legend
        do_anotations
        do_title
        do_ylabel
        do_grids
        do_latex
        do_ticks
        do_yticklabels
        plot_type       
        figsize
        fontname
        fontnamelatex
        fontsize  
        
        %Define or fetch some globals PLOT_GROUPS_did
        savepath
        verbose=1
        fid=1
        order=1
        mode=3 %1=bar plots; 2=scatter plots; 3=line plots
    end

    properties (Dependent = true, SetAccess = private)
        legends
    end
    
    methods
        
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function gpc = GroupDIDPlotConfig(bi,factors,savepath,vname,mode)
            if nargin<5, mode=3;end
            gpc.factors=factors;
            gpc.vname=vname;
            gpc.mode=mode;
            gpc.savepath=savepath;
            gpc.get_properties(bi);
            gpc.fetch_data(bi);
            gpc.fetch_data2(bi);
            plotdefaults(gpc);
            get_barplotdid_props(gpc,bi);
            if gpc.mode==3
                get_lineplot_props(gpc,{'ss','did'},'3levels')
                %get_lineplot_props(gpc,{'did','ss'},'3levels')
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function get_properties(gpc,bi)
            %Diferenciate bimanual/unimanual variables
            if length(size(bi))==4
                [grp, gpc.ss, did, reps]=size(bi);
                gpc.two_hands=0;
            else
                [hno, grp, gpc.ss, did, reps]=size(bi);
                gpc.two_hands=1;
                gpc.hnames={'Left Hand','Right Hand'};
            end
            
            %Compute ranges of factors
            gpc.franges=zeros(1,length(gpc.factors));
            for i=1:length(gpc.factors)
                if strcmp(gpc.factors{i},'grp')
                    gpc.franges(i)=grp;
                elseif strcmp(gpc.factors{i},'did')
                    gpc.franges(i)=did;
                end
            end
            
            %Allocate data matrices depending on handedness
            if gpc.two_hands
                gpc.data = zeros(hno,gpc.franges(1),gpc.franges(2),gpc.ss,2);                
            else
                gpc.data = zeros(gpc.franges(1),gpc.franges(2),gpc.ss,2);
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function fetch_data(gpc,bi)            
            for f1=1:gpc.franges(1)
                for f2=1:gpc.franges(2)
                    [g,did]=gpc.get_indexes([f1,f2]);
                    for s=1:3
                        if gpc.two_hands
                            for h=1:2
                                gpc.data(h,f1,f2,s,1)=nanmean(squeeze(bi(h,g,s,did,:)));
                                gpc.data(h,f1,f2,s,2)=nanste(squeeze(bi(h,g,s,did,:)));
                            end
                        else
                            gpc.data(f1,f2,s,1)=nanmean(squeeze(bi(g,s,did,:)));
                            gpc.data(f1,f2,s,2)=nanste(squeeze(bi(g,s,did,:)));
                        end
                    end
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function fetch_data2(gpc,bi)            
            for f1=1:gpc.franges(1)
                for f2=1:gpc.franges(2)
                    [g,did]=gpc.get_indexes([f1,f2]);
                    for s=1:3
                        if gpc.two_hands
                            for h=1:2
                                for rep=1:length(bi(h,g,s,did,:))
                                    gpc.data_scatter(h,f1,f2,s,rep)=bi(h,g,s,did,rep);
                                end
                            end
                        else
                            for rep=1:length(bi(g,s,did,:))
                                gpc.data_scatter(f1,f2,s,rep)=bi(g,s,did,rep);
                            end
                        end
                    end
                end
            end
        end        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [g,did] = get_indexes(gpc,fvals)
            for i=1:length(gpc.factors)
                if strcmp(gpc.factors{i},'grp')
                    g=fvals(i);
                elseif strcmp(gpc.factors{i},'did')
                    did=fvals(i);
                end
            end
        end   
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function gap = get_gap(gpc,f1,f2)
            %   f3-blk-pos  + f2-blk-size  *  f2-blk-no
            %gap=(gpc.ss+0.5)*(f2-1)+((gpc.ss+0.5)*gpc.franges(2)+2)*(f1-1);
            gap=(gpc.ss+0.5)*(f2-1);%+((gpc.ss+0.5)*gpc.franges(2)-1)*(f1-1);
        end
        
        function get_xlabels_pos(gpc)
           gpc.xlabels_pos = zeros(gpc.franges(1),2);
           for i=1:gpc.franges(1)
               if gpc.franges(2)==2
                   gpc.xlabels_pos(i,1)=gpc.get_gap(i,1)+3;
               else
                   gpc.xlabels_pos(i,1)=gpc.get_gap(i,2)+2;
               end
               gpc.xlabels_pos(i,2)=gpc.ymax+gpc.ymax/15;
           end               
        end
    end
end