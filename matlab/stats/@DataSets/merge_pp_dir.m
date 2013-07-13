function merge_pp_dir(ds,datapath)
    %Recommended method to group per-participant data
    %Does not support raw data, but it is not really usefull.
    
    %Fetch data files in a single cell array
    %ds=DataSets();
    if nargin < 2, datapath=ds.savepath; end
    data_files=dir2(datapath);
    pp=length(data_files);

    for g=1:pp
        ds.ppdata(g)=DataSets(joinpath(datapath,data_files(g).name));
    end

    %Create output matrices
    ds.dataU=zeros(ds.vnoB, ds.hno, ds.grps, ds.ss, ds.idr, ds.rep)*NaN;
    ds.dataB=zeros(ds.vnoU, ds.hno, ds.grps, ds.ss, ds.idl, ds.idr, ds.rep)*NaN;

    %Merge bimanual data
    for v=1:ds.vnoB
        for h=1:ds.hno
            for g=1:ds.grps
                for s=1:ds.ss
                    for rid=1:ds.idr
                        for lid=1:ds.idl
                            ds.dataB(v,h,g,s,lid,rid,:)=ds.ppdata(g).dataB(v,h,s,lid,rid,:);
                        end
                    end
                end
            end
        end
    end

    %Merge unimanual data
    for v=1:ds.vnoU
        for h=1:ds.hno
            for g=1:ds.grps        
                for s=1:ds.ss
                    for i=1:h+1
                        ds.dataU(v,h,g,s,i,:)=ds.ppdata(g).dataU(v,h,s,i,:);
                    end
                end
            end
        end
    end
    ds.dataL = squeeze(ds.dataU(:,1,:,:,1:2,:));
    ds.dataR = squeeze(ds.dataU(:,2,:,:,1:3,:));
    ds.get_data_rel();
    ds.merge_ID_factors();
end
