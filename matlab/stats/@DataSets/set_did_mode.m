function set_did_mode(ds)
    if strcmp(ds.DIDmode,'3levels')
        ds.deltaID=[0,1,2];
        ds.dnames=ds.dnames3;
        ds.varsDID=ds.varsGDID;
        ds.titlesDID=ds.titlesGDID;
    elseif strcmp(ds.DIDmode,'6levels')
        ds.deltaID=1:6;
        ds.dnames=ds.dnames6;        
        ds.varsDID=ds.varsGDID6;
        ds.titlesDID=ds.titlesGDID6;
    elseif strcmp(ds.DIDmode,'6levels2')
        ds.deltaID=1:6;
        ds.dnames=ds.dnames6;        
        ds.varsDID=ds.varsGDID6;
        ds.titlesDID=ds.titlesGDID6;
    elseif strcmp(ds.DIDmode,'4levels')
        ds.deltaID=[-2,-1,1,2];
        ds.dnames=ds.dnames4;        
        ds.varsDID=ds.varsGDID;
        ds.titlesDID=ds.titlesGDID;
    end
end