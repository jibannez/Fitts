function plot_var_did(phoc)
   
    vstr=phoc.vstr;
    
    %Create directory to store plots if needed
    if  ~exist(phoc.savepath,'dir')
        mkdir(phoc.savepath);
    end
    
    %Iterate over interactions
    for f=1:length(phoc.flists)
       %Hard coded custom sorting of groups
       res=phoc.results{f};
       factors=res.factors;
       vdata = res.data;
       phgrps=res.phgrps;
       phgrplabels=res.phgrplabels;
       f1mat=res.f1mat;
       f2mat=res.f2mat;
       yrange=get_yrange(vdata);
       
       %Print some nice header
       if phoc.verbose
           fprintf(phoc.fid,'\n');
           fprintf(phoc.fid,[repmat('=',1,80),'\n']);
           fprintf(phoc.fid,'Post-hoc analysis using Holm-Sidak pairwise comparisons on factors\n');
           fprintf(phoc.fid,factors{:});
       end
       
	   %Check all returned data is numeric, catches errors in the input
       if ~all(isfinite(vdata(:))) || ~all(isnumeric(vdata(:)))
            fprintf(phoc.fid,'Warning: all X values must be numeric and finite. vname=%s\n ',vname);
            continue
       end
       
       %Choose plotting according to number and type of factors
       switch length(factors)
           case 1        
               continue
               create_fig(phoc,factors);
               ax=subplot(1,1,1);
               plot_bw(phoc,vdata,factors{1},vstr,ax);
               save_fig(phoc,factors);                    
           case 2
               create_fig(phoc,factors);
               ax=subplot(1,1,1);
               [bar_data,gp]=plot_interaction(phoc,vdata,factors,vstr,ax);
               if phoc.do_anotations
                    add_anotations(bar_data,gp,f1mat,f2mat,yrange);
               end
               save_fig(phoc,factors);			   
           case 3
               continue
               create_fig(phoc,factors);
               for g=1:2
                   if g==1
                       do_ylabel=1;
                       do_legend=1;
                   else
                       do_ylabel=0;
                       do_legend=0;
                   end
                   ax=subplot(1,2,g);
                   [bar_data,gp]=plot_interaction(phoc,squeeze(vdata(g,:,:,:)),factors(2:end),vstr,ax,do_legend,do_ylabel);
                   title(sprintf('%s Coupling',phoc.ds.cnames{g}));
                   if phoc.do_anotations
                        add_anotations(bar_data,gp,squeeze(f1mat(g,:,:)),squeeze(f2mat(g,:,:)),yrange);
                   end
                   ylim(yrange);
               end
               save_fig(phoc,factors)			   
       end

    end
end


function resize_fonts(fontsize)
    textobj = findobj('type', 'text');
    set(textobj, 'fontunits', 'points');
    set(textobj, 'fontsize', fontsize);
    set(textobj, 'fontweight', 'normal');
end

function plot_bw(phoc,data,factor,vname,ax)
    %Box and whiskers plot for 1D tests
    if nargin<4, figure;ax=subplot(1,1,1); end
    gp=get_props({'',factor},phoc);
    boxplot(ax,data')
    title(gp.f2name,'interpreter','latex')
    ylabel(vname,'rot',90,'interpreter','latex');
    format_ticks(ax,gp.xticklabels,[],gp.x,[]);
    %set(ax,'XTick',gp.x,'XTicklabel',gp.xticklabels,'interpreter','latex');    
end


function [bar_data,gp]=plot_interaction(phoc,data,factors,vname,ax,do_legend,do_ylabel)
    %Interaction plot for 2D tests
    if nargin<7, do_ylabel=1; end
    if nargin<6, do_legend=1; end
    if nargin<5, figure;ax=subplot(1,1,1); end

    %Get bar groups for plotting
    [f1,f2,kk]=size(data);
    bar_data=zeros(f1,f2,2);
    for i=1:f1
        for j=1:f2
            bar_data(i,j,1)=mean(squeeze(data(i,j,:)));
            bar_data(i,j,2)=ste(squeeze(data(i,j,:)));
        end
    end

    %Get graphic properties of factors
    gp=get_props(factors,phoc);
    
    %Plot lines and error bars
    h=cell(f1,1);
    maxmv=0.033*f1;
    mv=linspace(-maxmv,maxmv,f1);
    hold on
    for i=1:f1  
        h{i}=errorbar(ax,gp.x+mv(i),bar_data(i,:,1),bar_data(i,:,2),gp.linespec{i});     
    end
    ylim(gca,gp.ylim)
    set(gca,'box','on'); 
    if phoc.ds.do_latex
        format_ticks(gca,gp.xticklabels,gp.yticklabels,gp.x,gp.y,[],[],[],'interpreter','latex','FontName',phoc.ds.fontname,'FontSize',phoc.ds.fontsize);
    else
        format_ticks(gca,gp.xticklabels,gp.yticklabels,gp.x,gp.y,[],[],[],'FontName',phoc.ds.fontnamelatex,'FontSize',phoc.ds.fontsize);
    end
    set(gca,'YMinorTick','on')
    %set(gca,'YTicksNumber','Low')    
    if do_ylabel
        if phoc.ds.do_latex
            ylabel(['$',vname,'$'],'rotation',0,'interpreter','latex','FontName',phoc.ds.fontnamelatex);
        else            
            ylabel(vname,'rotation',0,'FontName',phoc.ds.fontname,'FontSize',phoc.ds.fontsize);
        end
        moveLabel('y',20,gcf,gca)
    end
    if do_legend
        if phoc.ds.do_latex
            legend(gp.labels','interpreter','latex','FontName',phoc.ds.fontnamelatex,'FontSize',phoc.ds.fontsize,'Location','Best');
        else
            legend(gp.labels','FontName',phoc.ds.fontname,'FontSize',phoc.ds.fontsize,'Location','Best');
        end
    end
    if phoc.ds.do_latex
        title(sprintf('%s vs %s',gp.f1name,gp.f2name),'interpreter','latex','FontName',phoc.ds.fontnamelatex,'FontSize',phoc.ds.fontsize);
    else
        title(sprintf('%s vs %s',gp.f1name,gp.f2name),'FontName',phoc.ds.fontname,'FontSize',phoc.ds.fontsize);
    end
    %hold off
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%AUXILIAR FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function add_anotations(bardata,gp,f1mat,f2mat,ylimits)
    [f1,f1i]=size(f1mat);
    [f2,f2i]=size(f2mat);
    ymin=ylimits(1);
    ymax=ylimits(2);
    yrange=ymax-ymin;
    
    %horizontal location of messages varies with number of levels
    if f2==2
        xmsg=0.9;
    else
        xmsg=0.55;
    end
	
	%Check for homogeneous matrices to avoid overcrowding plots
	
	%Factor 1
	do_f1=1;    
    if ~any(f1mat(:)~=1)
        msg=sprintf('All significant for %s',gp.f2name);
        text(xmsg,ymax,msg)
        do_f1=0;
    elseif ~any(f1mat(:)~=0)
        msg=sprintf('All non significant for %s',gp.f2name);
        text(xmsg,ymax,msg)
        do_f1=0;
    end
	
	%Factor2
	do_f2=1;
    if ~any(f2mat(:)~=1)
        msg=sprintf('All significant for %s',gp.f1name);
        text(xmsg,ymax-yrange/12,msg)
        do_f2=0;
    elseif ~any(f2mat(:)~=0)
        msg=sprintf('All non significant for %s',gp.f1name);
        text(xmsg,ymax-yrange/12,msg)
        do_f2=0;
    end
    
    %Plot interaction of factor 1 across levels of factor 2
    if do_f1
        for i=1:f1            
            for j=1:f1i
                if f1mat(i,j)==0, continue; end
                [g1,g2]=get_groups(j,f2);
                if g1==1 && g2==3
                    x=g1-g1/3;
                    y=bardata(i,g1,1);
                    msg=sprintf('%s-%s',gp.f2{g1},gp.f2{g2});
                    text(x,y,msg,'BackgroundColor',[.3 .9 .3]);
                else
                    y=(bardata(i,g1,1)+bardata(i,g2,1))/2;
                    x=(g1+g2)/2-0.1;
                    msg=sprintf('%s-%s',gp.f2{g1},gp.f2{g2});
                    text(x,y,msg,'BackgroundColor',[.3 .9 .3]);
                end
            end
        end
    end
    
    %Plot interaction of factor 2 across levels of factor 1
    if do_f2
        for i=1:f2
            for j=1:f2i
                if f2mat(i,j)==0, continue; end
                [g1,g2]=get_groups(j,f1);
                if g1==1 && g2==3
                    if bardata(g1,i,1)<bardata(g2,i,1)
                        y=bardata(g1,i,1)-yrange/10;
                    else
                        y=bardata(g2,i,1)-yrange/10;
                    end
                    x=i-0.1;
                    msg=sprintf('%s|%s',gp.f1{g1},gp.f1{g2});
                    text(x,y,msg,'BackgroundColor',[.7 .9 .7]);
                else
                    y=(bardata(g1,i,1)+bardata(g2,i,1))/2;
                    x=i-0.1;
                    msg=sprintf('%s|%s',gp.f1{g1},gp.f1{g2});
                    text(x,y,msg,'BackgroundColor',[.7 .9 .7]);
                end
            end
        end
    end
end

function [g1,g2]=get_groups(j,flen)
    if flen==2
        g1=1;
        g2=2;
    elseif j==1
        g1=1;
        g2=2;
    elseif j==2
        g1=2;
        g2=3;
    elseif j==3
        g1=1;
        g2=3;
    else
        error('Something went wrong with posthoc matrices')
    end
end


function save_fig(phoc,factors) 	
	if ~isempty(phoc.savepath)
		figname = joinpath(phoc.savepath,[factors{:}]);
        pos=get_fig_position(phoc,factors)/phoc.ds.dpi;
        set(gcf, 'PaperUnits', 'inches', 'PaperSize',pos(3:4),'PaperPosition', pos);
        if strcmp(phoc.ds.ext,'fig')
            hgsave(gcf,figname,'all');
        elseif strcmp(phoc.ds.ext,'pdf')
            mlf2pdf(gcf,figname);
        else
            print(gcf,['-d',phoc.ds.ext],sprintf('-r%d',phoc.ds.dpi),figname);
        end
        close gcf
	end
end

function create_fig(phoc,factors)	
    if ~isempty(phoc.savepath)
        figure('name',[factors{:}],'numbertitle','off','PaperUnits', 'inches', 'PaperPosition', floor(get_fig_position(phoc,factors)./phoc.ds.dpi),'Visible','off');
    else
        figure('name',[factors{:}],'numbertitle','off');
    end
end

function rect=get_fig_position(phoc,factors)
   switch length(factors)
       case 1
           cols=1;
       case 2
           cols=1;
       case 3
           cols=2;
   end
   rect=floor([0,0,cols,cols/phoc.ds.aureumprop]*phoc.ds.col2inches*phoc.ds.dpi);
end
    
function gp = get_props(factors,ds)
    gp=struct();
    %Fill factor 1 related graphic properties
    if strcmp('grp',factors{1}) 
        gp.colors={[1,0.2,0.2],[0.2,0.2,1]};
        gp.linespec={'-ok','-.xk'};
        gp.labels={'Strong Coupling','Weak Coupling'};
        gp.f1={'ST','WK'};
        gp.f1name='Group';
    elseif strcmp('ss',factors{1})
        gp.colors={[1,0.2,0.2],[0.2,0.2,1],[0.2,1,0.2]};
        gp.linespec={'-ok','-.xk','--dk'};
        gp.labels={'S1','S2','S3'};
        gp.f1=gp.labels;
        gp.f1name='Session';
    elseif strcmp(ds.DIDmode,'3levels')
        gp.colors={[1,0.2,0.2],[0.2,0.2,1],[0.2,1,0.2]};
        gp.linespec={'-ok','-.xk','--dk'};
        gp.labels={'Zero','Small','Large'};
        gp.f1={'Zero','Small','Large'};
        gp.f1name='ID_{diff}';
    elseif strcmp(ds.DIDmode,'6levels2')
        gp.colors={[0.2,1,1],[0.2,0.2,1],[0.2,0.2,0.2],[0.4,0.4,0.4],[0.4,0.4,1],[0.4,1,1]};
        gp.linespec={'-ok','-.xk','--dk','-^k','-.vk','--*k'};
        %gp.labels={'LI','SI','ZE','ZD','SC','LC'};
        gp.labels={'+2','+1','0_D','0_E','-1','-2'};
        gp.f1={'+2','+1','0_D','0_E','-1','-2'};
        gp.f1name='ID_{diff}';
    end
    %Fill factor 2 related graphic properties
    if strcmp('grp',factors{2}) 
        gp.x=[1,2];     
        gp.xticklabels={'Strong Coupling','Weak Coupling'};
        gp.f2={'ST','WK'};
        gp.f2name='Group';
    elseif strcmp('ss',factors{2})
        gp.x=[1,2,3];
        gp.xticklabels={'S1','S2','S3'};
        gp.f2=gp.xticklabels;
        gp.f2name='Session';
    elseif strcmp(ds.DIDmode,'3levels')
        gp.x=[1,2,3];        
        gp.xticklabels={'Zero','Small','Large'};
        gp.f2={'Zero','Small','Large'};
        gp.f2name='ID_{diff}';
    elseif strcmp(ds.DIDmode,'6levels2')
        gp.x=[1,2,3,4,5,6];        
        gp.xticklabels={'+2','+1','0_D','0_E','-1','-2'};
        gp.f2={'+2','+1','0_D','0_E','-1','-2'};
        gp.f2name='ID_{diff}';
    end
    %Fill ylabel information
    [gp.y,gp.yticklabels]=get_yticks(ds.vname);
    gp.ylim=get_ylims(ds.vname);
end

function yrange=get_yrange(vdata)
    vsize=size(vdata);
    yrange=[];
    switch length(vsize)
       case 2    
            for i=1:vsize(1)
                d=squeeze(vdata(i,:));
                yrange=compare_range(d,yrange);
            end
        case 3
            for i=1:vsize(1)
                for j=1:vsize(2)
                    d=squeeze(vdata(i,j,:));
                    yrange=compare_range(d,yrange);
                end
            end
            
        case 4
            for i=1:vsize(1)
                for j=1:vsize(2)
                    for k=1:vsize(3)
                        d=squeeze(vdata(i,j,k,:));
                        yrange=compare_range(d,yrange);
                    end
                end
            end            
    end
end

function yrange = compare_range(data,yrange)
    ymin=mean(data(:))-ste(data(:));    
    ymax=mean(data(:))+ste(data(:));    
    if isempty(yrange)
        yrange=[ymin,ymax];
    else
        if yrange(1)>ymin
            yrange(1)=ymin;
        end
        if yrange(2)<ymax
            yrange(2)=ymax;
        end
    end
end