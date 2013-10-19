function plot_groups_var(ds,gpc,vname) 
    if gpc.two_hands
        %One-handed variables: Iterate over both hands, one plot per hand
        data_orig=gpc.data;
        for hand=1:length(gpc.hnames)
            figname = [vname,'_',gpc.hnames{hand}];                        
            gpc.data=squeeze(data_orig(hand,:,:,:,:,:));
            plot_(ds,gpc,figname);
        end
    else
        % Dual-handed variables       
        plot_(ds,gpc,vname);
    end
end

function plot_(ds,gpc,figname)
    ax={};
    legend_groups=zeros(1,gpc.franges(3));
    
    create_figure(ds,figname);
    for f1=1:gpc.franges(1)
        create_subplots(ds,gpc.franges(1),f1,figname);
        ax{f1}=gca;
        if f1==1 && gpc.do_title, title(figname); end
        hold on
        for f2=1:gpc.franges(2)
            for f3=1:gpc.franges(3)
                gap=gpc.get_gap(f2,f3);
                for s=1:gpc.ss
                    %Plot bar and error bar
                    h=bar(s+gap,squeeze(gpc.data(f1,f2,f3,s,1)),'FaceColor', gpc.colors{f3}(s,:), 'BarWidth', 1);
                    errorbar(s+gap,gpc.data(f1,f2,f3,s,1),gpc.data(f1,f2,f3,s,2),'k', 'linestyle','none', 'linewidth', 0.5);
                end
                %Store handle to generate legend
                if f2==1, legend_groups(f3)=h; end
            end
        end        
        plot_cosmetics(ds,gpc,f1);
    end
    if ds.do_legend, legend(legend_groups,gpc.legends,'Location','Best'); end
    hold off
    savefig(gpc,figname)
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
    if ds.do_ylabel, ylabel(gpc.vname); end
    
    %Plot anotations and grids if demanded by user
    if ds.do_anotations
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
    if ~isempty(ds.savepath)
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
function savefig(gpc, figname)
    if strfind('phi_{',figname)
        figname='phasediffstd';
    end
    figname = joinpath(gpc.savepath,figname);
    if ~isempty(gpc.savepath) && exist(gpc.savepath,'dir')
        if strcmp(gpc.ext,'fig')
            hgsave(gcf,figname,'all');
        else
            set(gcf, 'PaperUnits', 'inches', 'PaperPosition', gpc.figsize/gpc.dpi);
            print(gcf,['-d',gpc.ext],sprintf('-r%d',gpc.dpi),figname);     
        end           
    end
end
