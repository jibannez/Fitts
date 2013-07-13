function get_all_data_averaged(ds)
    ds.dataU=zeros(ds.vnoU,ds.hands,ds.grps,ds.ss,ds.idr,ds.rep);
    ds.dataB=zeros(ds.vnoB,ds.hands,ds.grps,ds.ss,ds.idl,ds.idr,ds.rep);
    ds.dataRel=zeros(ds.vnoB,ds.hands,ds.grps,ds.ss,ds.idl,ds.idr,ds.rep);
                
    %Prepare indexes for group-based or participant-based sorting. 
    if ds.grps==10
        i=zeros(10,1);
    else    
        i=zeros(2,1);        
    end

    for p=1:10     % participant number
        %Load participant p from disk
        display(['Now processing participant ' num2str(p)])
        pp=ds.xp(p);        
        
        %Choose between group-based or participant-based sorting. 
        if ds.grps==10          %Participant-based sorting            
            g=p;
        elseif any(ds.C==p) %Group based sorting                      
            g=1;                %Coupled group = 1
        else                    
            g=2;                %Uncoupled group = 2
        end
        
        %Increase count for this participant/group
        i(g)=i(g)+1;

        %Iterate over within factors
        for s=1:ds.ss  % session number
            for a=1:ds.idl % left: difficult, easy
                for b=1:ds.idr   % right: difficult, medium, easy
                    for c=1:ds.rep % replication number
                        %Compute index based on i vector and actual replication
                        %For participant-based sorting, it equals to reps
                        idx=(i(g)-1)*3+c;
                        %Bimanual trials
                        for v=1:length(ds.vnamesB)
                            if strcmp(ds.vtypesB{v},'ls')
                                ds.dataB(v,1,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.ls.(ds.vnamesB{v}));
                                ds.dataB(v,2,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.ls.(ds.vnamesB{v}));
                            else
                                ds.dataB(v,1,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.([ds.vtypesB{v} 'L']).(ds.vnamesB{v}));
                                ds.dataB(v,2,g,s,a,b,idx)=nanmedian(pp(s).bimanual{a,b,c}.([ds.vtypesB{v} 'R']).(ds.vnamesB{v}));
                            end
                        end
                        %Unimanual Trials
                        for v=1:length(ds.vnamesU)
                            if b==1
                                ds.dataU(v,1,g,s,a,idx)=nanmedian(pp(s).uniLeft{a,c}.(ds.vtypesU{v}).(ds.vnamesU{v}));
                            end
                            if a==1
                                ds.dataU(v,2,g,s,b,idx)=nanmedian(pp(s).uniRight{b,c}.(ds.vtypesU{v}).(ds.vnamesU{v}));
                            end
                        end
                    end
                end
            end
        end
    end
    ds.dataL = squeeze(ds.dataU(:,1,:,:,:,:));
    ds.dataR = squeeze(ds.dataU(:,2,:,:,:,:));
end
