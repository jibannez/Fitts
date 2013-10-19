function plot_groups_did(ds,factors,mode)
    if nargin<3, mode=3; end
    if nargin<2, factors={'grp','did'}; end

    %Rearrange data matrices by group if needed
    if size(ds.dataD,3)==10
        ds.dataD=ds.merge_pp_unimatrix(ds.dataD,ds.C);
    end
    
    %Rearrange Delta ID matrix if necessary
    if ~strcmp(ds.DIDmode,'3levels')
        ds.DIDmode='3levels';
        ds.merge_ID_factors();
    end
    
    %Create out dir if passed as argument
    savepath=joinpath(ds.plotpath,'groupsDID3');
    if ~isempty(savepath) && ~exist(savepath,'dir')
        mkdir(savepath);
    end
    
    %PLOT IT ALL
    for v=1:length(ds.varsGDID)    
        %Get index for variable in data arrays
        v_bi=strcmp(ds.varsGDID{v}, ds.vnamesB);
        v_un=strcmp(ds.varsGDID{v}, ds.vnamesU);
        if ~any(v_bi)
            fprintf('Error, unknown variable %s\n',ds.varsGDID{v});
            continue;
        end
        
        %Prepare matrices
        if any(v_un)
            bi=squeeze(ds.dataD(v_bi,:,:,:,:,:)); 
        else
            bi=squeeze(ds.dataD(v_bi,1,:,:,:,:));
        end        
        
        %Absolute plots
        if mode==1
            ds.plot_groups_did_bars(GroupDIDPlotConfig(bi,factors,savepath,ds.titlesGDID{v},1));
        else
            ds.plot_groups_did_lines(GroupDIDPlotConfig(bi,factors,savepath,ds.titlesGDID{v},3));
        end
    end
end


