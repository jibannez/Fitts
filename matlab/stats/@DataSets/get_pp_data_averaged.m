function get_pp_data_averaged(ds,pp)
ds.dataU=zeros(ds.vnoB,ds.hno,ds.ss,ds.idr,ds.rep);
ds.dataB=zeros(ds.vnoU,ds.hno,ds.ss,ds.idl,ds.idr,ds.rep);
ds.dataRel=zeros(ds.vnoB,ds.hno,ds.ss,ds.idl,ds.idr,ds.rep);
%Iterate over within factors
for s=1:ds.ss  % session number
    for a=1:ds.idl % left: difficult, easy
        for b=1:ds.idr   % right: difficult, medium, easy
            for c=1:ds.rep % replication number
                %Bimanual trials
                for v=1:ds.vnoB
                    if strcmp(ds.vtypesB{v},'ls')
                        ds.dataB(v,1,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.ls.(ds.vnamesB{v}));
                        ds.dataB(v,2,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.ls.(ds.vnamesB{v}));
                    else
                        ds.dataB(v,1,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.([ds.vtypesB{v} 'L']).(ds.vnamesB{v}));
                        ds.dataB(v,2,s,a,b,c)=nanmedian(pp(s).bimanual{a,b,c}.([ds.vtypesB{v} 'R']).(ds.vnamesB{v}));
                    end
                end
                %Unimanual Trials
                for v=1:ds.vnoU
                    if b==1
                        ds.dataU(v,1,s,a,c)=nanmedian(pp(s).uniLeft{a,c}.(ds.vtypesU{v}).(ds.vnamesU{v}));
                    end
                    if a==1
                        ds.dataU(v,2,s,b,c)=nanmedian(pp(s).uniRight{b,c}.(ds.vtypesU{v}).(ds.vnamesU{v}));
                    end
                end
            end
        end
    end
end
ds.dataL = squeeze(ds.dataU(:,1,:,:,:));
ds.dataR = squeeze(ds.dataU(:,2,:,:,:));
end
