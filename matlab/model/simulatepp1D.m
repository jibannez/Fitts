function res = simulatepp1D(pp)
    do_plot=1;    
    m=ModelMonostable('d');
    res=cell([3,3,3]);
    for id=1:3
        for s=1:3
            for rep=1:3            
                fprintf('Simulating ID %d ss %d rep %d\n',id,s,rep)
                tr=pp(s).uniRight{id,rep};
                pfit=cell2mat(m.fit(tr,do_plot));
                res{s,id,rep}=pfit;
            end
            if do_plot
                disp(res{s,id,1})
                disp(res{s,id,2})
                disp(res{s,id,3})
                disp('Paused')
                pause
                close all
            end
        end
    end
end
    