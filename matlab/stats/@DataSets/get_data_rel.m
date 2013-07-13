function get_data_rel(ds)
if length(size(ds.dataB))==7
    for p=1:ds.grps        
        for s=1:ds.ss  % session number
            for a=1:ds.idl % left: difficult, easy
                for b=1:ds.idr   % right: difficult, medium, easy
                    for c=1:ds.rep % replication number
                        %Bimanual trials
                        for v=1:ds.vnoB
                            if strcmp(ds.vtypesB{v},'ls')
                                continue
                            else
                                vu=strcmp(ds.vnamesB{v},ds.vnamesU);
                                if any(vu)
                                    ds.dataRel(v,1,p,s,a,b,c)=squeeze(ds.dataB(v,1,p,s,a,b,c))/nanmean(squeeze(ds.dataU(vu,1,p,s,a,:))); 
                                    ds.dataRel(v,2,p,s,a,b,c)=squeeze(ds.dataB(v,2,p,s,a,b,c))/nanmean(squeeze(ds.dataU(vu,2,p,s,b,:)));
                                end
                            end
                        end                                    
                    end
                end
            end
        end
    end
else
    for s=1:ds.ss  % session number
        for a=1:ds.idl % left: difficult, easy
            for b=1:ds.idr   % right: difficult, medium, easy
                for c=1:ds.rep % replication number
                    %Bimanual trials
                    for v=1:ds.vnoB
                        if strcmp(ds.vtypesB{v},'ls')
                            continue
                        else
                            vu=strcmp(ds.vnamesB{v},ds.vnamesU);
                            if any(vu)
                                ds.dataRel(v,1,s,a,b,c)=squeeze(ds.dataB(v,1,s,a,b,c))/nanmean(squeeze(ds.dataU(vu,1,s,a,:)));
                                ds.dataRel(v,2,s,a,b,c)=squeeze(ds.dataB(v,2,s,a,b,c))/nanmean(squeeze(ds.dataU(vu,2,s,b,:)));
                            end
                        end
                    end
                end
            end
        end
    end
end
end
