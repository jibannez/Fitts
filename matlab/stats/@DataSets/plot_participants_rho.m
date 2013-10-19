%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Auxiliar functions for controlling plotting of either uni or bi data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_participants_rho(ds,showplot) 
    if nargin < 2, showplot=1; end
    %Create out dir if passed as argument
    figname='pprho';
    figsize=ds.figsize;
    ds.figsize=[0,0,4,12/ds.aureumprop]*ds.dpi*ds.col2inches;
    savepath=joinpath(ds.plotpath,'participants');
    if ~isempty(savepath) && ~exist(savepath,'dir')
        mkdir(savepath);
    end    
    
    %Fetch data
    v=strcmp('rho',ds.vnamesB);
    data=get_data_4rho(ds,squeeze(ds.dataB(v,1,:,:,:,:,:)));    
    [ss, idl, idr, pp, reps]=size(data);
    
    %Define some globals            
    colors=get_colors();
    marker='.';
    
    %set_figtype(ds.plot_type,figname,vartype);
    create_figure(ds,savepath,figname,showplot)
    
    %Get limits for plot scaling, common to all plots
    [mindata, maxdata]=get_limits(data);

    %Iterate over session, one plot per hand
    for s=1:ss
        %Create subplots depending on configuration
        create_subplots(s,ds.plot_type);
        hold on       
        %Set Y limits in advance        
        set_limits(mindata,maxdata);        
        %Do the actual scatter plots
        for r=1:idr
            for l=1:idl
                xpos=get_xpos(r,l);
                for i=1:length(xpos)
                    scatter(xpos(i),data(s,l,r,i),...
                            'Marker',marker,...
                            'MarkerEdgeColor',colors{i},...
                            'MarkerFaceColor',colors{i});
                end
            end
        end        
        %Plot annotation for ID left level and ID right level
        plot_idl(idr,idl,maxdata);
        plot_idr(idr,maxdata);        
        %Plot lines to separate groups
        plot_lines();        
        %Plot guiding lines and remove useless ticks or add pp-based ones
        do_cosmetics(idr,idl,'\rho')
        hold off
    end
    savefig(ds,savepath, figname,showplot)
    ds.figsize=figsize;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data=get_data_4rho(ds,datain)
    %For variables defined over two hands relations, like ls, ph...
    [pp, ss, idl, idr, reps]=size(datain); 
    data = zeros(ss,idl,idr,pp*reps);
    for s=1:ss
        for l=1:idl
            for r=1:idr
                %all data for a certain IDL;IDL is part of the same series
                cnt=1;
                for p=ds.ppbygrp      
                    data(s,l,r,cnt:cnt+2)=squeeze(datain(p,s,l,r,:))';
                    cnt=cnt+3;
                end
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Auxiliar functions of disparate purpose...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x=get_x(r,l)
    x=12*(2.1*(r-1)+l-1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function xpos=get_xpos(r,l)
    xpos0=[1,2,3,4,5,7,8,9,10,11]+get_x(r,l);
    xpos=[];
    spos=[-.25,0,.25];
    for p=1:10
        xpos(3*(p-1)+1:3*p)=spos+xpos0(p);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mindata, maxdata]=get_limits(data)
    idx=abs(data(:)-nanmean(data(:))) < 5*nanstd(data(:));
    mindata=nanmin(data(idx));
    maxdata=nanmax(data(idx));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function set_limits(mindata,maxdata)
    if isempty(mindata) || isempty(maxdata)
        return        
    elseif mindata>0
        ylim([0,maxdata+maxdata/10]);
    else
        ylim([mindata,maxdata+maxdata/10]);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_idl(idr,idl,maxdata)
    if isempty(maxdata)
        return;
    end
    labels={'Left Easy','Left Difficult'};
    for r=1:idr
        for l=1:idl
            text(4+get_x(r,l),maxdata,labels{l});
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_idr(idr,maxdata)
    if isempty(maxdata)
        return;
    end
    labels={'Right Easy','Right Medium','Right Difficult'};
    %labels={'RD','RM','RE'};
    for r=1:idr
        text(9.5+get_x(r,1),maxdata+maxdata/10,labels{r},'FontWeight','bold');
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function subplottight(n,m,i)
    [c,r] = ind2sub([m n], i);
    subplot('Position', [(c-1)/m, 1-(r)/n, 1/m, 1/n])
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function colors=get_colors()
% colors= {   [0.45,0.45,0.45],...
%             [0.45,0.45,0.45],...
%             [0.45,0.45,0.45],...
%             [0.45,0.45,0.45],...
%             [0.45,0.45,0.45],...
%             
%             [0.65,0.65,0.65],...
%             [0.65,0.65,0.65],...
%             [0.65,0.65,0.65],...
%             [0.65,0.65,0.65],...
%             [0.65,0.65,0.65],...
%         };
colors= {   [0.45,0.45,0.45],[0.45,0.45,0.45],[0.45,0.45,0.45],...
            [0.45,0.45,0.45],[0.45,0.45,0.45],[0.45,0.45,0.45],...
            [0.45,0.45,0.45],[0.45,0.45,0.45],[0.45,0.45,0.45],...
            [0.45,0.45,0.45],[0.45,0.45,0.45],[0.45,0.45,0.45],...
            [0.45,0.45,0.45],[0.45,0.45,0.45],[0.45,0.45,0.45],...
            
            [0.65,0.65,0.65],[0.65,0.65,0.65],[0.65,0.65,0.65],...
            [0.65,0.65,0.65],[0.65,0.65,0.65],[0.65,0.65,0.65],...
            [0.65,0.65,0.65],[0.65,0.65,0.65],[0.65,0.65,0.65],...
            [0.65,0.65,0.65],[0.65,0.65,0.65],[0.65,0.65,0.65],...
            [0.65,0.65,0.65],[0.65,0.65,0.65],[0.65,0.65,0.65],...
        };
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_lines()
    %First, IDR lines, thick
    vline(get_x(1,1)-0.5,'k')
    vline(get_x(2,1)-0.5,'k')
    vline(get_x(3,1)-0.5,'k')
    vline(get_x(4,1)-0.5,'k')
    %Now, IDL lines, lighter
    vline(get_x(1,2),'k--')
    vline(get_x(2,2),'k--')
    vline(get_x(3,2),'k--')
    %Participant lines, disabled
%     if mod(i,3)==1
%         vline(xpos(i)-0.12,'k');
%     elseif mod(i,3)==0
%         vline(xpos(i)+0.12,'k');
%     end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function create_subplots(s,plot_type)
if ~isempty(strfind(plot_type,'tight'))
    subplottight(3,1,s);
elseif ~isempty(strfind(plot_type,'subplot'))
    subplot(3,1,s);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function set_figtype(plot_type,rootname,vartype)
%     scrsz = get(0,'ScreenSize');
%     if ~isempty(strfind(plot_type,'subplot')) || ~isempty(strfind(plot_type,'tight')) && ...
%         ~isempty(strfind(vartype,'ls'))
%         figure('Position',[1 scrsz(4)/2 scrsz(3)/1 scrsz(4)/3])
%         set(gcf,'name',rootname);
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
function create_figure(ds,savepath,rootname,showplot)
    if showplot
        figure('name',rootname,'numbertitle','off','PaperUnits', 'inches', 'PaperPosition', ds.figsize/ds.dpi);
    elseif ~isempty(savepath)
        figure('name',rootname,'numbertitle','off','PaperUnits', 'inches', 'PaperPosition', ds.figsize/ds.dpi,'Visible','off');
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function do_cosmetics(idr,idl,ylabelstr)
    [xticksp,xticksl]=get_xticks(idr,idl);
    set(gca,'XTick',xticksp);
    set(gca,'XTickLabel',xticksl);
    set(gca,'box','off');
    set(gca,'XLim', [0 get_x(4,1)-0.45]);
    %Split label string in two lines if it is longer than 8 char
    if length(ylabelstr)>8
        if ~isempty(strfind(ylabelstr,' '))
            [s1,s2]=strtok(ylabelstr,' ');
            ylabelstr={s1,s2};
        else
            l=floor(length(ylabelstr)/2);
            ylabelstr={ylabelstr(1:l),ylabelstr(l+1:end)};
        end
    end
    %ylabh=ylabel(ylabelstr,'rot',0);
    ylabh=ylabel('\rho','rot',0);
    set(ylabh,'Position',get(ylabh,'Position') - [3 0 0]);
    grid off;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xticksp,xticksl]=get_xticks(idr,idl)
    xticksl=[];
    xticksp=[];
    xpos0=[1,2,3,4,5,7,8,9,10,11];
    %xlabels={'P2','P3','P6','P8','P9', 'P1','P4','P5','P7','P10'};
    xlabels={'2','3','6','8','9', '1','4','5','7','10'};
    for r=1:idr
        for l=1:idl
            xticksp=[xticksp,xpos0+get_x(r,l)];
            xticksl=[xticksl,xlabels];
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savefig(ds,savepath,figname,showplot)    
    if strfind('\phi_{SD}',figname)
        figname='phasediffstd';
    elseif strfind('\rho',figname)
        figname='rho';
    elseif strfind('D_{KL}',figname)
        figname='DKL';        
    end
    figname = joinpath(savepath,figname);
    if ~isempty(savepath) && exist(savepath,'dir')
        pos=ds.figsize/ds.dpi;
        set(gcf, 'PaperUnits', 'inches', 'PaperSize',pos(3:4),'PaperPosition', pos);
        if strcmp(ds.ext,'fig')
            hgsave(gcf,figname,'all');
        elseif strcmp(ds.ext,'pdf')
            mlf2pdf(gcf,figname);
        else
            print(gcf,['-d',ds.ext],sprintf('-r%d',ds.dpi),figname);
        end
        if ~showplot
            close gcf
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%