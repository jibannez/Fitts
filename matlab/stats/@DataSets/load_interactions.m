function load_interactions(ds)
    % open the file
    fid = fopen(joinpath(ds.Rpath,'anova.out'));
    ds.flists={};
    
    % read the file
    tline = fgetl(fid);
    while ischar(tline)
        a=strread(tline,'%s','delimiter',' ');
        if length(a)==1
            ds.flists{end+1}=a;
        else
            fl={};
            for f=1:length(a)-1
                modifiedStr = lower(strrep(a{f+1}, 'S', 'SS'));                
                fl{f}=strread(modifiedStr,'%s','delimiter',':');
            end
            ds.flists{end+1}={a{1},fl};
        end
        tline = fgetl(fid);
    end
    
    % close the file
    fclose(fid);
    
    ds.fvnames = cellfun(@(x) x(1),ds.flists);
end