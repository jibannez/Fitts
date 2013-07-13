function plot_participants(ds)
    if nargin<6, error('Not enough input arguments'); end
    
    %Do bimanual plots
    for v=1:length(ds.vnamesB)
        if strcmp(ds.vnamesB{v},'d2D')
            continue
        end
        %fetch all data for scatter plots
        if strcmp(vartype,'ls') || ~isempty(strfind(ds.vnamesB{v},'minPeakDistance'))
            data=get_data_dual(squeeze(ds.dataB(1,:,:,:,:,:)));
        else
            data=get_data_bi(ds.dataB);
        end
        ds.plot_participants_scatter_bimanual(data,ds.vnamesB{v},ds.vtypesB{v})    
    end
    
    %Do relative plots
    for v=1:length(ds.vnamesU)
        if ~isempty(strmatch(ds.vnamesU{v},ds.excludeVars,'exact'));
            continue
        end
        %fetch all data for scatter plots        
        v2=strcmp(ds.vnamesU{v}, ds.vnamesB);
        data=get_data_rel(squeeze(ds.dataB(v2,:,:,:,:,:,:),squeeze(ds.dataU(v ,:,:,:,:,:))));   
        ds.plot_participants_scatter_bimanual(data,ds.vnamesU{v},ds.vtypesU{v},1);
    end
    
    %Do unimanual plots
    for v=1:length(ds.vnamesU)
        %fetch all data for scatter plots
        data=get_data_uni(squeeze(ds.dataU(v,:,:,:,:,:)));    
        plot_participants_scatter_unimanual(data,ds.vnamesU{v},ds.vtypesU{v})
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Auxiliar functions to fetch and sort data for scatter plots
%First one plots variables with values for each hand, 
%Second plots variables defined over both hands.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data=get_data_bi(bidata)
    %Define or get some globals
    global ppbygrp;    
    [hands, pp, ss, idl, idr, reps]=size(bidata);
    data = zeros(hands,idl,idr,pp*ss,reps);
    for r=1:idr
        for l=1:idl
            %all data for a certain IDL;IDL is part of the same series
            cnt=0;
            for p=ppbygrp                
                for s=1:ss
                    cnt=cnt+1;
                    for h=1:hands
                        data(h,l,r,cnt,1:3)=squeeze(bidata(h,p,s,l,r,:))';
                    end
                end
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data=get_data_dual(datain)
    %For variables defined over two hands relations, like ls, ph...
    %Define or get some globals
    global ppbygrp;
    [pp, ss, idl, idr, reps]=size(datain); 
    data = zeros(idl,idr,pp*ss,reps);
    for l=1:idl
        for r=1:idr
            %all data for a certain IDL;IDL is part of the same series
            cnt=0;
            for p=ppbygrp                
                for s=1:ss
                    cnt=cnt+1;
                    data(l,r,cnt,1:3)=squeeze(datain(p,s,l,r,:))';
                end
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data=get_data_rel(bidata,udata)
    %Define or get some globals
    global ppbygrp;
    [h, pp, ss, idl, idr, reps]=size(bidata); 
    data = zeros(h,idl,idr,pp*ss,reps);   
    
    %Sigmoid variables are substracted instead of divided by unimanual.
    eps=0.05;
    if min(bidata(:))<=eps && (1-max(bidata(:)))<=eps
        is_sigmoid=1;
    else
        is_sigmoid=0;
    end

    %Iterate and order data for scatter plots
    for l=1:idl
        for r=1:idr
            %all data for a certain IDL;IDL is part of the same series in
            %scatter plots, cnt keeps account of how many data we have.
            cnt=0;
            for p=ppbygrp                
                for s=1:ss
                    cnt=cnt+1;
                    if is_sigmoid
                        data(1,l,r,cnt,1:3)=squeeze(bidata(1,p,s,l,r,:))'-nanmedian(squeeze(udata(1,p,s,l,:)));
                        data(2,l,r,cnt,1:3)=squeeze(bidata(2,p,s,l,r,:))'-nanmedian(squeeze(udata(2,p,s,r,:))); 
                    else
                        data(1,l,r,cnt,1:3)=squeeze(bidata(1,p,s,l,r,:))'./nanmedian(squeeze(udata(1,p,s,l,:)));
                        data(2,l,r,cnt,1:3)=squeeze(bidata(2,p,s,l,r,:))'./nanmedian(squeeze(udata(2,p,s,r,:)));
                    end                    
                end
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data=get_data_uni(udata)
    %Define or get some globals
    global ppbygrp;    
    [hands, pp, ss, ids, reps]=size(udata);
    data = zeros(hands,ids,pp*ss,reps);
    for id=1:ids
        %all data for a certain IDL;IDL is part of the same series
        cnt=0;
        for p=ppbygrp
            for s=1:ss
                cnt=cnt+1;
                for h=1:hands
                    data(h,id,cnt,1:3)=squeeze(udata(h,p,s,id,:))';
                end
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%