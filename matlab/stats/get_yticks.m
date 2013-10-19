function [yticks,yticklabels] = get_yticks(vname)
    switch vname
        case {'H','Harmonicity','FLS','flsPC','\phi_{SD}','phDiffStd','D_{KL}','KLD'}
            yticks=[0,.5,1];
            yticklabels={'0','0.5','1'};
        case 'MT'        
            yticks=[0,.5,1,1.5,2];
            yticklabels={'0','0.5','1','1.5','2'};
        case {'rho','\rho'}
            yticks=[0,1,2,3,4];
            yticklabels={'0','1','2','3','4'};            
        case {'vfCircularity','VFC'}
            yticks=[1,1.25,1.5];
            yticklabels={'1','1.25','1.5'};
        otherwise            
            yticks=[];
            yticklabels={};
    end
end

