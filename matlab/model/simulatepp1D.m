function [resR,resL] = simulatepp1D(pp,do_plot)
    if nargin<2, do_plot=0; end
    
    %Create data structures
    m=ModelMonostable('d');
    resR=cell([3,3,3,2]);
    resL=cell([3,2,3,2]);
    
    %Fit right handed trials
    for id=1:3
        for s=1:3
            for rep=1:3           
                fprintf('Simulating Right ID %d ss %d rep %d\n',id,s,rep)
                tr=pp(s).uniRight{id,rep};                
                resR{s,id,rep,1}=cell2mat(m.fit(tr,do_plot));
                resR{s,id,rep,2}=[std(tr.ts.omega),std(m.phdot)];
            end
            if do_plot
                disp(resR{s,id,1})
                disp(resR{s,id,2})
                disp(resR{s,id,3})
                disp('Paused')
                pause
                close all
            end
        end
    end
    
    %Fit left handed trials
    for id=1:2
        for s=1:3
            for rep=1:3           
                fprintf('Simulating Left ID %d ss %d rep %d\n',id,s,rep)
                tr=pp(s).uniLeft{id,rep};                
                resL{s,id,rep,1}=cell2mat(m.fit(tr,do_plot));
                resL{s,id,rep,2}=[std(tr.ts.omega),std(m.phdot)];
            end
            if do_plot
                disp(resL{s,id,1})
                disp(resL{s,id,2})
                disp(resL{s,id,3})
                disp('Paused')
                pause
                close all
            end
        end
    end    
end
    