function plot_groups(ds,factors)
    if nargin<2, factors={'idr','idl','grp'}; end 
    
    %Select  variables 
    gpc=GroupPlotConfig();
    vnames=gpc.vnames;
    vstrs=gpc.vstrs;
    units=gpc.units;
    titles=gpc.titles;
    
    %Rearrange data matrices by group if needed
    if size(ds.dataB,3)==10
        ds.dataB=ds.merge_pp_bimatrix(ds.dataB,ds.C);
        ds.dataU=ds.merge_pp_unimatrix(ds.dataU,ds.C);
    end

    %Create out dir if passed as argument
    savepath=joinpath(ds.plotpath,'groups');
    if ~isempty(savepath) && ~exist(savepath,'dir')
        mkdir(savepath);
    end

    %PLOT IT ALL
    length(vnames)    
    for v=1:length(vnames)    
        %Get index for variable in data arrays
        v_bi=strcmp(vnames{v}, ds.vnamesB);
        v_un=strcmp(vnames{v}, ds.vnamesU);
        if ~any(v_bi)
            fprintf('Error, unknown variable %s\n',vnames{v});
            continue;
        end
        %Prepare matrices
        if any(v_un)
            bi=squeeze(ds.dataB(v_bi,:,:,:,:,:,:));
            un=squeeze(ds.dataU(v_un,:,:,:,:,:)); 
        else
            bi=squeeze(ds.dataB(v_bi,1,:,:,:,:,:));
        end

        %Absolute plots
        fprintf('Plotting variable %s\n',titles{v})
        ds.plot_groups_var(GroupPlotConfig([vstrs{v},units{v}],bi,factors,savepath),titles{v});

        %Relative plots
        if any(v_un) && ds.dorel
            if strcmp(vstrs{v}(end),'}')
                vname=[vstrs{v}(1:end-1),'rel} ',units{v}];
            else
                vname=[vstrs{v},'_{rel} ',units{v}];
            end
            fprintf('Plotting variable Relative %s\n',titles{v})
            ds.plot_groups_var(GroupPlotConfig(vname,bi,un,factors,savepath),['Relative_',titles{v}]);
        end
    end
end

