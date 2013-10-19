function plot_groups_did_bars(ds,gpc)
    %Each of the groups in 3rd factor is a different coloured data-series    
    legend_groups=zeros(1,gpc.franges(2)); 
    
    %Create figure and setup properties
    create_figure(gpc);
    
    %Plot loop
    for f1=1:gpc.franges(1)
        create_subplots(gpc,gpc.franges(1),f1);
        hold on
        for f2=1:gpc.franges(2)
            gap=gpc.get_gap(f1,f2);
            for s=1:gpc.ss
                if gpc.mode==1 
                    h=bar(s+gap,squeeze(gpc.data(f1,f2,s,1)),'FaceColor', gpc.colors{f2}(s,:), 'BarWidth', 1);
                else
                    dpoints=squeeze(gpc.data_scatter(f1,f2,s,:));                          
                    h=scatter((s+gap).*ones(size(dpoints))+normrnd(0,.1,size(dpoints)),dpoints,'Marker','.','SizeData',8,'MarkerFaceColor', gpc.colors{f2}(s,:),'MarkerEdgeColor', gpc.colors{f2}(s,:));
                end
                herr=errorbar(s+gap,gpc.data(f1,f2,s,1),gpc.data(f1,f2,s,2),'k');%, 'linestyle','none', 'linewidth', 0.5);
                errorbarT(herr,0.5,0.1)
            end
            %Store handle to later generate legend
            if f1==1, legend_groups(f2)=h; end
        end        
        %Improve graphics appearance per subplot
        plot_cosmetics(gpc,f1); 
        hold off        
    end 

    %Plot legend if demanded
    if gpc.do_legend, legend(legend_groups,get_legend(gpc),'Location','Best'); end
    savefig(gpc)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_cosmetics(gpc,f1)  
    %ticks, box and limits    
    if gpc.do_latex
        format_ticks(gca,[],gpc.yticklabels,[],gpc.yticks,[],[],[],'interpreter','latex','FontName',gpc.fontnamelatex,'FontSize',gpc.fontsize);        
    else
        format_ticks(gca,[],gpc.yticklabels,[],gpc.yticks,[],[],[],'FontName',gpc.fontname,'FontSize',gpc.fontsize);
    end
    add_minor_ticks(gpc.yminorticks,[0,0.1],'y');
    set(gca,'XTick',[]);
    set(gca,'ylim',gpc.ylim);
    set(gca,'box','on');
    
    %Plot y label if demanded
    if gpc.do_ylabel
        if gpc.do_latex
            ylabel(gca,gpc.vname,'rotation',90,'interpreter','latex','FontSize',gpc.fontsize+2,'FontName',gpc.fontnamelatex);
        else
            ylabel(gca,gpc.vname,'rotation',90,'FontSize',gpc.fontsize+2,'FontName',gpc.fontname);
        end
        moveLabel('y',30,gcf,gca)
    end
    
    %Plot grid and guiding lines  
    if gpc.do_grids
        %only plot a line in y=1 if relative variables are being plotted
        if strfind(gpc.vname,'rel}'), hline(1,'k-'); end
        hline([0.5,1],{'k--','k--'}) %,{'0.5s','1s'})
        hline(1,'k-')
        grid on;
    end
        
    %Plot anotations and grids if demanded by user
    if gpc.do_anotations
        %Plot anottation for 2nd factor
        for i=1:gpc.franges(2)
            if f1==1 && ~isnan(gpc.ymin) && ~isnan(gpc.ymin) && gpc.ymin+gpc.ymax~=0
                text(gpc.xlabels_pos(i,1),gpc.xlabels_pos(i,2),gpc.xlabels{i},...
                    'EdgeColor','black','BackgroundColor',[.7 .9 .7],'FontSize',12,'FontWeight','bold');        
            end
        end        
        %Trick for a right handed 1st factor annotation
        if gpc.do_ylabel
            text(gpc.ylabels_pos(1),gpc.ylabels_pos(2),gpc.ylabels(f1),...
                'rot',0,'EdgeColor','black','BackgroundColor',[.7 .9 .7],'FontSize',12,'FontWeight','bold');
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
function create_figure(gpc,rootname)   
    if nargin < 2, rootname=gpc.vname; end
    if ~isempty(gpc.savepath)
        figure('name',rootname,'numbertitle','off','PaperUnits', 'inches', 'PaperPosition', gpc.figsize/gpc.dpi,'Visible','off');
    else
        figure('name',rootname,'numbertitle','off','PaperUnits', 'inches', 'PaperPosition', gpc.figsize/gpc.dpi);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function create_subplots(gpc,vno,v)
    %Create subplots depending on configuration
    if ~isempty(strfind(gpc.plot_type,'tight')) 
        [c,r] = ind2sub([1 vno], v);
        subplot('Position', [(c-1)/1, 1-(r)/vno, 1/1, 1/vno])
    elseif ~isempty(strfind(gpc.plot_type,'subplot'))
        subplot(vno,1,v);
    elseif ~isempty(strfind(gpc.plot_type,'figure'))
        create_figure(gpc.vname);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savefig(gpc,figname)
    if nargin<2, figname=gpc.vname; end
    
    if strfind('\phi_{SD}',figname)
        figname='phasediffstd';
    elseif strfind('\rho',figname)
        figname='rho';
    elseif strfind('D_{KL}',figname)
        figname='DKL';        
    end
    
    figname = joinpath(gpc.savepath,figname);
    if ~isempty(gpc.savepath) && exist(gpc.savepath,'dir')
        pos=gpc.figsize/gpc.dpi;
        set(gcf, 'PaperUnits', 'inches', 'PaperSize',pos(3:4),'PaperPosition', pos);
        if strcmp(gpc.ext,'fig')
            hgsave(gcf,figname,'all');
        elseif strcmp(gpc.ext,'pdf')
            mlf2pdf(gcf,figname);
        else
            print(gcf,['-d',gpc.ext],sprintf('-r%d',gpc.dpi),figname);
        end
        close gcf
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function leg = get_legend(gpc)
    leg={};
    for i=1:length(gpc.names)
        leg{i}=gpc.names{i};
    end
end
       