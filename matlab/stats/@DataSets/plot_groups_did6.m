function plot_groups_did6(ds,factors,mode)
    if nargin<3, mode=3; end
    if nargin<2, factors={'grp','did'}; end

    %Rearrange data matrices by group if needed
    if size(ds.dataD,3)==10
        ds.dataD=ds.merge_pp_unimatrix(ds.dataD,ds.C);
    end
    
    %Rearrange Delta ID matrix if necessary
    if ~strcmp(ds.DIDmode,'6levels2')
        ds.DIDmode='6levels2';
        ds.merge_ID_factors();
    end
    
    %Create out dir if passed as argument
    savepath=joinpath(ds.plotpath,'groupsDID6');
    if ~isempty(savepath) && ~exist(savepath,'dir')
        mkdir(savepath);
    end
    
    %PLOT IT ALL
    for v=1:length(ds.varsGDID6)    
        %Get index for variable in data arrays
        v_bi=strcmp(ds.varsGDID6{v}, ds.vnamesB);
        v_un=strcmp(ds.varsGDID6{v}, ds.vnamesU);
        if ~any(v_bi)
            fprintf('Error, unknown variable %s\n',ds.varsGDID{v});
            continue;
        end
        
        %Prepare matrices, plot only bimanual variables
        if any(v_un)
            bi=squeeze(ds.dataD(v_bi,1,:,:,:,:)); 
        else
            continue
        end          
        
        %Plot the thing
        if mode==1
            ds.plot_groups_did_bars(GroupDID6PlotConfig(bi,factors,savepath,ds.titlesGDID6{v},1));
        else
            ds.plot_groups_did_lines(GroupDID6PlotConfig(bi,factors,savepath,ds.titlesGDID6{v},3));
        end
    end
end


