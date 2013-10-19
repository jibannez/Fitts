function [resB,resR,resL] = fitpp(pp,do_plot)
    if nargin<2, do_plot=0; end
    
    %Create data structures
    m1=ModelMonostable('d');
    m2=ModelMonostable('ed1');
    resB=cell([3,2,3,3,3]);    
    resR=cell([3,3,3,3]);
    resL=cell([3,2,3,3]);
    
    
    %Fit bimanual trials
    for idl=1:2
        for idr=1:3
            for s=1:3
                for rep=1:3            
                    fprintf('Simulating IDL %d IDR %d ss %d rep %d\n',idl,idr,s,rep)
                    tr=pp(s).bimanual{idl,idr,rep};
                    resB{s,idl,idr,rep,1}=cell2mat(m2.fit(tr,do_plot));
                    if tr.info.LID < tr.info.RID
                        resB{s,idl,idr,rep,2}=[std(tr.ts.Lomega),std(tr.ts.Romega),std(m2.phdot(:,1)),std(m2.phdot(:,2))];
                        resB{s,idl,idr,rep,3}=[tr.ts.Lf*2*pi, tr.ts.Rf*2*pi,-mean(m2.phdot(:,1)),-mean(m2.phdot(:,2))];
                    else
                        resB{s,idl,idr,rep,2}=[std(tr.ts.Romega),std(tr.ts.Lomega),std(m2.phdot(:,1)),std(m2.phdot(:,2))];
                        resB{s,idl,idr,rep,3}=[tr.ts.Rf*2*pi, tr.ts.Lf*2*pi,-mean(m2.phdot(:,1)),-mean(m2.phdot(:,2))];
                    end
                end
                if do_plot
                    disp(resB{s,idl,idr,1})
                    disp(resB{s,idl,idr,2})
                    disp(resB{s,idl,idr,3})
                    disp('Paused')
                    pause;
                    close all
                end
            end
        end
    end
    
    %Fit right handed trials
    for id=1:3
        for s=1:3
            for rep=1:3           
                fprintf('Simulating Right ID %d ss %d rep %d\n',id,s,rep)
                tr=pp(s).uniRight{id,rep};                
                resR{s,id,rep,1}=cell2mat(m1.fit(tr,do_plot));
                resR{s,id,rep,2}=[std(tr.ts.omega),std(m1.phdot)];
                resR{s,id,rep,3}=[tr.ts.f*2*pi,-mean(m1.phdot)];
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
                resL{s,id,rep,1}=cell2mat(m1.fit(tr,do_plot));
                resL{s,id,rep,2}=[std(tr.ts.omega),std(m1.phdot)];
                resL{s,id,rep,3}=[tr.ts.f*2*pi,-mean(m1.phdot)];
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
    
