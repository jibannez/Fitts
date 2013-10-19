function plot_groups_did_lines(ds,gpc)    
    %Create figure and setup properties
    create_figure(gpc);
    %Plot loop
    for f1=1:2
        create_subplots(gpc,2,f1);
        plot_interaction(gpc,squeeze(gpc.data(f1,:,:,:))); 
        %Title
        if gpc.do_latex
            title(sprintf('%s Coupling Group',ds.cnames{f1}),'interpreter','latex','FontName',gpc.fontnamelatex,'FontSize',gpc.fontsize+4,'FontWeight','bold');
        else
            title(sprintf('%s Coupling Group',ds.cnames{f1}),'FontName',gpc.fontname,'FontSize',gpc.fontsize+4,'FontWeight','bold');
        end
        gpc.do_legend=0;
    end 
    savefig(gpc)
end

function plot_interaction(gpc,bar_data)
    %Interaction plot for 2D tests
    [~,f1,~]=size(bar_data);

    %Plot lines and error bars
    h=cell(f1,1);
    maxmv=0.033*f1;
    mv=linspace(-maxmv,maxmv,f1);
    hold on
    for i=1:f1 
        h{i}=errorbar(gca,gpc.xticks+mv(i),bar_data(:,i,1),bar_data(:,i,2),...
                      gpc.linespec{i},'MarkerFaceColor','k',...
                      'LineWidth',gpc.linewidth(i),'MarkerSize',3);     
    end
    plot_cosmetics(gpc)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_cosmetics(gp)  
    %limits
    xmax=gp.xticks(end)+1;
    ylim(gca,gp.ylim)
    xlim(gca,[0,xmax])
    
    %ticks
    if gp.do_latex
        format_ticks(gca,gp.xticklabels,gp.yticklabels,gp.xticks,gp.yticks,[],[],[],'interpreter','latex','FontName',gp.fontname,'FontSize',gp.fontsize);
    else
        format_ticks(gca,gp.xticklabels,gp.yticklabels,gp.xticks,gp.yticks,[],[],[],'FontName',gp.fontnamelatex,'FontSize',gp.fontsize);
    end
    set(gca,'TickLength',[0.025,0.025])
    add_minor_ticks(gp.yticks,gp.yminorticks,[0,0.1],'y');
    add_minor_ticks(gp.yticks,gp.yminorticks,[xmax,xmax-0.1],'y');
    set(gca,'box','on'); 
   
    %y labels
    if gp.do_ylabel
        if gp.do_latex
            ylabel(['$',gp.vname,'$'],'rotation',90,'interpreter','latex','FontName',gp.fontnamelatex,'FontSize',gp.fontsize+3,'FontWeight','bold');
        else            
            ylabel(gp.vname,'rotation',90,'FontName',gp.fontname,'FontSize',gp.fontsize+3,'FontWeight','bold');
        end
        moveLabel('y',10,gcf,gca)
    end
    
    %legend
    if gp.do_legend
        if gp.do_latex
            legend(gp.labels','interpreter','latex','FontName',gp.fontnamelatex,'FontSize',gp.fontsize,'Location','Best');
        else
            legend(gp.labels','FontName',gp.fontname,'FontSize',gp.fontsize,'Location','Best');
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
function create_figure(gpc,rootname)   
    if nargin < 2, rootname=gpc.vname; end
    pos=gpc.figsize/gpc.dpi;
    if ~isempty(gpc.savepath)
        figure('name',rootname,'numbertitle','off','PaperUnits', 'inches', 'PaperSize',pos(3:4),'PaperPosition', pos,'Visible','off');
    else
        figure('name',rootname,'numbertitle','off','PaperUnits', 'inches', 'PaperSize',pos(3:4),'PaperPosition', pos);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function create_subplots(gpc,vno,v)
subaxis(1,vno,v, 'Spacing', 0, 'Padding', 0.04, 'Margin', 0.04);
%subplot(1,vno,v);
return
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

       