function res = simulatepp2D(pp)
    do_plot=0;    
    m=ModelMonostable('ed1');
    res=cell([3,2,3,3]);
    for idl=1:2
        for idr=1:3
            for s=1:3
                for rep=1:3            
                    fprintf('Simulating IDL %d IDR %d ss %d rep %d\n',idl,idr,s,rep)
                    tr=pp(s).bimanual{idl,idr,rep};
                    res{s,idl,idr,rep}=cell2mat(m.fit(tr,do_plot));
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
    