classdef GroupPlotConfig < handle
    properties
        data
        vname
        names
        hnames
        factors
        franges
        two_hands
        colors
        xlabels
        ylabels
        xlabels_pos
        ylabels_pos
        ymin
        ymax
        yrange
        ylim
        xmin
        xmax
        ss
        
        %Define or fetch some globals PLOT_GROUPS_did
        savepath
        ext='png'
        dpi=300
        verbose=1
        fid=1
        order=1
        do_relative=1;    
        do_legend=0
        do_anotations=0
        do_title=0
        do_ylabel=1
        plot_type='subplot'; %'tight' 'figure' 'subplot'       
        figsize=[0,0,1600,1000];
        fontname='Arial'
        fontsize=10


        %Define or fetch some globals PLOT_GROUPS
        
        vnames={'MT','accTime','decTime','accQ','IPerfEf',...
              'maxangle','d3D','d4D','Circularity',...
              'vfCircularity','vfTrajCircularity','Harmonicity',...
              'rho','flsPC','phDiffStd','phDiffChiSq','KLD','minPeakDelay','minPeakDelayNorm'};      
        vstrs={'MT','AT','DT','AQ','IPE',...
              'MA','d3D','d4D','Circularity',...
              'VFC','VFT','H',...
              '\rho','FLS','\phi_{\sigma}','phDiffChiSq','KLD','MPD','MPD_{norm}'};
        units={' (s)',' (s)',' (s)','',' (bits/s)',...
              '(rad)','','','',...
              '','','',...
              '','','','','(s)','dpeaks_{norm} (s²)'};      
        titles={'Movement Time','Acceleration Time','Deceleration Time','Acceleration Ratio','Effective Index of Performace',...
                'Maximal Angle','3D Distance','4D Distance','Circularity',...
                'Vector Field Circularity','Vector Field Trajectory Circularity','Harmonicity',...
                '\rho','flsPC','\phi_SD','\phi_SD \chi test','Mutual Information','Minimal Peak Delay','Minimal Peak Delay Normalized'};

    end
    
    properties (Dependent = true, SetAccess = private)
        legends
    end
    
    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function legends = get.legends(ds)
            legends={};
            for i=1:length(ds.names)
                legends{i}=ds.names{i};
            end            
        end
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function gpc = GroupPlotConfig(vname,bi,un,factors,savepath)
            if nargin==4
                gpc.factors=un;
                gpc.savepath=factors;
                gpc.get_properties(bi);
                gpc.fetch_data(bi);
                gpc.ymin = nanmin(filterOutliers(bi(:)));
                gpc.ymax = nanmax(filterOutliers(bi(:)));
                gpc.yrange=gpc.ymax-gpc.ymin;
                gpc.ylim=[gpc.ymin-gpc.yrange/10,gpc.ymax+gpc.yrange/10];
                if gpc.ylim(1)<0 & gpc.ymin>=0
                    gpc.ylim(1)=0;
                end
            elseif nargin==5
                gpc.factors=factors;
                gpc.savepath=savepath;
                gpc.get_properties(bi);
                gpc.fetch_relative_data(bi,un);
                if strfind(vname,'{rel}')
                    means=squeeze(gpc.data(:,:,:,:,:,1));
                    stdes=squeeze(gpc.data(:,:,:,:,:,2));
                    mmax=means+stdes;
                    mmin=means-stdes;
                    gpc.ymin = min(mmin(:));
                    gpc.ymax = max(mmax(:));
                    gpc.yrange=gpc.ymax-gpc.ymin;
                    gpc.ylim=[gpc.ymin,gpc.ymax];     
                    if (gpc.ylim(1)<0 & ~any(means<0))
                        gpc.ylim(1)=0;
                    end
                else
                    gpc.ymin = nanmin(filterOutliers(bi(:)));
                    gpc.ymax = nanmax(filterOutliers(bi(:)));
                    gpc.yrange=gpc.ymax-gpc.ymin;
                    gpc.ylim=[gpc.ymin-gpc.yrange/10,gpc.ymax+gpc.yrange/10];
                    if gpc.ylim(1)<0 & gpc.ymin>0
                        gpc.ylim(1)=0;
                    end
                end
            elseif nargin==0
                return
            end            
            
            gpc.vname= vname;            
            gpc.xmin = 0;
            gpc.xmax = (3*gpc.franges(3)+1)*gpc.franges(2)+2;
            gpc.get_labels_pos();            
            
            %Factor 3, determines legend names and coloring scheme
            if strcmp(gpc.factors{end},'grp')
                gpc.names ={'Strong','Weak'};
                gpc.colors={[[1,0.2,0.2]   ;[0.8,0.2,0.2];[0.6,0.2,0.2]],...
                           [[0.2,0.2,1]   ;[0.2,0.2,0.8];[0.2,0.2,0.6]]};
            elseif strcmp(gpc.factors{end},'idr')
                gpc.names ={'ID_R Easy','ID_R Medium','ID_R Difficult'};
                gpc.colors={[[1,0.2,0.2]   ;[0.8,0.2,0.2];[0.6,0.2,0.2]],...
                           [[0.2,0.2,1]   ;[0.2,0.2,0.8];[0.2,0.2,0.6]],...
                           [[0.2,1,0.2]   ;[0.2,0.8,0.2];[0.2,0.6,0.2]]};
            else
                gpc.names ={'ID_L Easy','ID_L Difficult'};
                gpc.colors={[[1,0.2,0.2]   ;[0.8,0.2,0.2];[0.6,0.2,0.2]],...
                           [[0.2,0.2,1]   ;[0.2,0.2,0.8];[0.2,0.2,0.6]]};
            end

            %Factor 2 labels
            if strcmp(gpc.factors{2},'grp')
                gpc.xlabels={'Strong','Weak'};
            elseif strcmp(gpc.factors{2},'idl')
                gpc.xlabels={'LE','LD'};
            else
                gpc.xlabels={'RE','RM','RD'};
            end

            %Factor 1 labels
            if strcmp(gpc.factors{1},'grp')
                gpc.ylabels={'Strong','Weak'};
            elseif strcmp(gpc.factors{1},'idl')
                gpc.ylabels={'LE','LD'};
            else
                gpc.ylabels={'RE','RM','RD'};
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function get_properties(ds,bi)
            %Diferenciate bimanual/unimanual variables
            if length(size(bi))==5
                [grp, ds.ss, idl, idr, reps]=size(bi);
                ds.two_hands=0;
            else
                [hno, grp, ds.ss, idl, idr, reps]=size(bi);
                ds.two_hands=1;
                ds.hnames={'Left Hand','Right Hand'};
            end
            
            %Compute ranges of factors
            ds.franges=zeros(1,length(ds.factors));
            for i=1:length(ds.factors)
                if strcmp(ds.factors{i},'grp')
                    ds.franges(i)=grp;
                elseif strcmp(ds.factors{i},'idl')
                    ds.franges(i)=idl;
                elseif strcmp(ds.factors{i},'idr')
                    ds.franges(i)=idr;
                end
            end
            
            %Allocate data matrices depending on handedness
            if ds.two_hands
                ds.data = zeros(hno,ds.franges(1),ds.franges(2),ds.franges(3),ds.ss,2);                
            else
                ds.data = zeros(ds.franges(1),ds.franges(2),ds.franges(3),ds.ss,2);
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function fetch_relative_data(ds,bi,un)
            for f1=1:ds.franges(1)
                for f2=1:ds.franges(2)
                    for f3=1:ds.franges(3)
                        [g,r,l]=ds.get_indexes([f1,f2,f3]);
                        for h=1:2               
                            for s=1:ds.ss
                                if h==1 %left hand
                                    unirep=squeeze(un(h,g,s,l,:));
                                    birep=squeeze(bi(h,g,s,l,r,:));
                                    if any(unirep==0), continue; end
                                    relmean=nanmean(birep./unirep);
                                    relste=nanste(birep./unirep);
                                else
                                    unirep=squeeze(un(h,g,s,r,:));
                                    birep=squeeze(bi(h,g,s,l,r,:));
                                    if any(unirep==0), continue; end
                                    relmean=nanmean(birep./unirep);
                                    relste=nanste(birep./unirep);
                                end
                                ds.data(h,f1,f2,f3,s,1)=relmean;
                                ds.data(h,f1,f2,f3,s,2)=relste;
                            end
                        end
                    end
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function fetch_data(ds,bi)            
            for f1=1:ds.franges(1)
                for f2=1:ds.franges(2)
                    for f3=1:ds.franges(3)
                        [g,r,l]=ds.get_indexes([f1,f2,f3]);
                        if ds.two_hands
                            for h=1:2                 
                                for s=1:ds.ss
                                    ds.data(h,f1,f2,f3,s,1)=nanmean(squeeze(bi(h,g,s,l,r,:)));
                                    ds.data(h,f1,f2,f3,s,2)=nanste(squeeze(bi(h,g,s,l,r,:)));
                                end
                            end
                        else
                            for s=1:3
                                ds.data(f1,f2,f3,s,1)=nanmean(squeeze(bi(g,s,l,r,:)));
                                ds.data(f1,f2,f3,s,2)=nanste(squeeze(bi(g,s,l,r,:)));
                            end
                        end
                    end
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [g,r,l] = get_indexes(ds,fvals)
            for i=1:length(ds.factors)
                if strcmp(ds.factors{i},'grp')
                    g=fvals(i);
                elseif strcmp(ds.factors{i},'idl')
                    l=fvals(i);
                elseif strcmp(ds.factors{i},'idr')
                    r=fvals(i);
                end
            end
        end   
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function gap = get_gap(ds,f2,f3)
            %   f3-blk-pos  + f2-blk-size  *  f2-blk-no
            gap=(ds.ss+0.5)*(f3-1)+((ds.ss+0.5)*ds.franges(3)+2)*(f2-1);
        end
        
        function get_labels_pos(ds)
           ds.xlabels_pos = zeros(ds.franges(2),2);
           ds.ylabels_pos = [ds.xmax+1,ds.ymax/2];
           for i=1:ds.franges(2)
               if ds.franges(3)==2
                   ds.xlabels_pos(i,1)=ds.get_gap(i,1)+3;
               else
                   ds.xlabels_pos(i,1)=ds.get_gap(i,2)+2;
               end
               ds.xlabels_pos(i,2)=ds.ymax+ds.ymax/10;
           end               
        end
    end
end