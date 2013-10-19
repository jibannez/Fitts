function plot_block_pd(ds)
    [idl,idr,reps]=size(ds);
    figure();
    colrs={'r','g','b'};
    for l=1:idl
        for r=1:idr
            idx=idl*(r-1)+l;
            ax=subplot(idr,idl,idx);            
            for rep=1:reps
                %hist(ax,ds{l,r,rep}.ls.minPeakDelay);
                hist(ax,mpd2(ds{l,r,rep}));
                xlim([-.5,.5])
                hold on
            end
            h = findobj(ax,'Type','patch');
            for rep=1:reps-1
                set(h(rep),'FaceColor',colrs{rep},'EdgeColor','k','facealpha',0.5);
            end
        end
    end
end
