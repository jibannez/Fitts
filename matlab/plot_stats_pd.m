function plot_stats_pd(pp1,pp2)
    [idl,idr,reps]=size(pp1.s1);
    idlstrs={'E','D'};
    idrstrs={'E','M','D'};
    for l=1:idl
        for r=1:idr
            fprintf('\n\t\t\tIDL=%s \t\t IDR=%s\n',idlstrs{l},idrstrs{r});
            fprintf('----------------------------------------------------------------------------------\n')
            fprintf('\t\t\t Coupled \t\t Uncoupled\n');
            for s=1:3                
                %d1=pp1.(['s',num2str(s)]){l,r,end}.ls.minPeakDelay;
                %d2=pp2.(['s',num2str(s)]){l,r,end}.ls.minPeakDelay;
                d1=mpd(pp1.(['s',num2str(s)]){l,r,end});
                d2=mpd(pp2.(['s',num2str(s)]){l,r,end});
                fprintf('\tSession %d:\t %+0.3f +/- %0.3f \t %+0.3f +/- %0.3f\n',s,mean(d1),std(d1),mean(d2),std(d2));
            end
            fprintf('----------------------------------------------------------------------------------\n')
        end
    end
end


%-----TODOOOOO
%Corregir y reanalizar minpeaks, phase diffs y d4D
