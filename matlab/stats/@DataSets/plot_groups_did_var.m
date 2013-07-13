%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_groups_did_var(ds,gpc,vname)
    ax={};
    
    %Each of the groups in 3rd factor is a different coloured data-series    
    legend_groups=zeros(1,gpc.franges(2)); 
    
    %Create figure and setup properties
    set_figtype(vname);
    
    %Plot loop
    for f1=1:gpc.franges(1)
        create_subplots(gpc.franges(1),f1,vname);
        ax{f1}=gca;
        hold on
        for f2=1:gpc.franges(2)
            gap=gpc.get_gap(f1,f2);
            for s=1:gpc.ss
                h=bar(s+gap,squeeze(gpc.data(f1,f2,s,1)),'FaceColor', gpc.colors{f2}(s,:), 'BarWidth', 1);
                errorbar(s+gap,gpc.data(f1,f2,s,1),gpc.data(f1,f2,s,2),'k', 'linestyle','none', 'linewidth', 0.5);
            end
            %Store handle for later generate legend
            if f1==1, legend_groups(f2)=h; end
        end
    end 
    
    %Improve graphics visibility
    plot_cosmetics(gpc,f1);
    
    %Plot legend if demanded
    if ds.do_legend, legend(legend_groups,get_legend(gpc),'Location','Best'); end
    savefig(ds,figname)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_cosmetics(ds,gpc,f1)  
    %remove useless ticks, box, and set y limits
    set(gca,'XTick',[]);
    set(gca,'ylim',gpc.ylim);
    set(gca,'box','off');
    
    %only plot a line in y=1 if relative variables are being plotted
    if strfind(gpc.vname,'rel}'), hline(1,'k-'); end
    
    %Plot y label if demanded
    if do_ylabel, ylabel(gpc.vname); end
    
    %Plot anotations and grids if demanded by user
    if do_anotations
        %Plot grid and guiding lines  
        hline([0.5,1],{'k--','k--'}) %,{'0.5s','1s'})
        hline(1,'k-')
        grid on;
        %Plot anottation for 2nd factor
        for i=1:gpc.franges(2)
            if f1==1 && ~isnan(gpc.ymin) && ~isnan(gpc.ymin) && gpc.ymin+gpc.ymax~=0
                text(gpc.xlabels_pos(i,1),gpc.xlabels_pos(i,2),gpc.xlabels{i},...
                    'EdgeColor','black','BackgroundColor',[.7 .9 .7],'FontSize',12,'FontWeight','bold');        
            end
        end
        
        %Trick for a right handed 1st factor annotation
        text(gpc.ylabels_pos(1),gpc.ylabels_pos(2),gpc.ylabels(f1),...
            'rot',0,'EdgeColor','black','BackgroundColor',[.7 .9 .7],'FontSize',12,'FontWeight','bold');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
function create_figure(ds,rootname)   
    if ~isempty(savepath)
        figure('name',rootname,'numbertitle','off','PaperUnits', 'inches', 'PaperPosition', ds.figsize/ds.dpi,'Visible','off');
    else
        figure('name',rootname,'numbertitle','off','PaperUnits', 'inches', 'PaperPosition', ds.figsize/ds.dpi);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function create_subplots(ds,vno,v,rootname)
    %Create subplots depending on configuration
    if ~isempty(strfind(ds.plot_type,'tight')) 
        [c,r] = ind2sub([1 vno], v);
        subplot('Position', [(c-1)/1, 1-(r)/vno, 1/1, 1/vno])
    elseif ~isempty(strfind(ds.plot_type,'subplot'))
        subplot(vno,1,v);
    elseif ~isempty(strfind(ds.plot_type,'figure'))
        create_figure(rootname);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savefig(ds,figname)    
    if strfind('\phi_{\sigma}',figname)
        figname='phasediffstd';
    end
    figname = joinpath(ds.savepath,figname);
    if ~isempty(ds.savepath) && exist(ds.savepath,'dir')
        if strcmp(ds.ext,'fig')
            hgsave(gcf,figname,'all');
        else
            set(gcf, 'PaperUnits', 'inches', 'PaperPosition', ds.figsize/ds.dpi);
            print(gcf,['-d',ds.ext],sprintf('-r%d',ds.dpi),figname);     
        end
           
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function leg = get_legend(gpc)
    leg={};
    for i=1:length(gpc.names)
        leg{i}=gpc.names{i};
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function do_cosmetics(gpc)
    %Plot guiding lines and remove useless ticks      
    hline([0.5,1],{'k--','k--'}) %,{'0.5s','1s'})
    hline(1,'k-')
    set(gca,'XTick',[]);
    set(gca,'ylim',[gpc.ymin-abs(gpc.ymin/10),gpc.ymax+abs(gpc.ymax/10)]);
    set(gca,'box','off');
    grid on;
    for i=1:gpc.franges(1)
        xlabh=text(gpc.xlabels_pos(i,1),gpc.ymax,gpc.xlabels{i},'EdgeColor','black','BackgroundColor',[.7 .9 .7],'FontSize',12,'FontWeight','bold');
        s = struct(handle(xlabh));
        s.Position=s.Position - [0 1 0 ];
    end
end
                    