function plot_groups_did(ds,factors)
    if nargin<1
        error('Not enough input arguments');
    elseif nargin==1
        factors={'grp','did'};
    end

    %Rearrange data matrices by group if needed
    if size(ds.dataD,3)==10
        ds.dataD=ds.merge_pp_unimatrix(ds.dataD,ds.C);
    end
    
    %PLOT IT ALL
    for v=1:length(ds.varsGDID)    
        %Get index for variable in data arrays
        v1=strcmp(ds.varsGDID{v}, ds.vnamesB);
        
        %Prepare matrices
        bi=squeeze(ds.dataD(v1,:,:,:,:));

        %Absolute plots
        ds.plot_groups_did_var(GroupDIDPlotConfig(bi,factors),ds.titlesGDID{v});
    end
end


