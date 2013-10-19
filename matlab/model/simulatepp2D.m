function res = simulatepp2D(pp,do_plot)
    if nargin<2, do_plot=0; end
    
    m=ModelMonostable('ed1');
    res=cell([3,2,3,3,2]);
    for idl=1:2
        for idr=1:3
            for s=1:3
                for rep=1:3            
                    fprintf('Simulating IDL %d IDR %d ss %d rep %d\n',idl,idr,s,rep)
                    tr=pp(s).bimanual{idl,idr,rep};
                    res{s,idl,idr,rep,1}=cell2mat(m.fit(tr,do_plot));
                    if tr.info.LID < tr.info.RID
                        res{s,idl,idr,rep,2}=[std(tr.ts.Lomega),std(tr.ts.Romega),std(m.phdot(:,1)),std(m.phdot(:,2))];
                    else
                        res{s,idl,idr,rep,2}=[std(tr.ts.Romega),std(tr.ts.Lomega),std(m.phdot(:,1)),std(m.phdot(:,2))];
                    end
                end
                if do_plot
                    disp(res{s,idl,idr,1})
                    disp(res{s,idl,idr,2})
                    disp(res{s,idl,idr,3})
                    disp('Paused')
                    pause;
                    close all
                end
            end
        end
    end
end
    