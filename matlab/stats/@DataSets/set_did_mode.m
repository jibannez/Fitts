function set_did_mode(ds)
    if strcmp(ds.DIDmode,'3levels')
        ds.deltaID=[0,1,2];
    elseif strcmp(ds.DIDmode,'6levels')
        ds.deltaID=-2:2;
    elseif strcmp(ds.DIDmode,'4levels')
        ds.deltaID=[-2,-1,1,2];
    end
end