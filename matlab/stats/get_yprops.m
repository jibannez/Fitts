function gp = get_yprops(vname,gp)
    switch vname
        case {'H','Harmonicity'}
            gp.ylim=[0,1];
            gp.yticks=[0,0.25,0.5,0.75,1];
            gp.yticklabels=numarray2cellstring(gp.yticks);
            gp.yminorticks=4;
        case {'FLS','flsPC'}
            gp.ylim=[0.5,1];
            gp.yticks=[0.5,0.75,1];
            gp.yticklabels=numarray2cellstring(gp.yticks);
            gp.yminorticks=4;
        case {'\phi_{SD}','phDiffStd'}
            gp.ylim=[0,0.5];
            gp.yticks=[0,0.25,0.5];
            gp.yticklabels=numarray2cellstring(gp.yticks);
            gp.yminorticks=4;
        case {'D_{KL}','KLD'}
            gp.ylim=[0.45,0.8];
            gp.yticks=[0.5,0.6,0.7,0.8];
            gp.yticklabels=numarray2cellstring(gp.yticks);
            gp.yminorticks=4;
        case {'\rho','rho'}
            gp.ylim=[0,4];
            gp.yticks=[0,1,2,3,4];
            gp.yticklabels=numarray2cellstring(gp.yticks);
            gp.yminorticks=4;
        case {'VFC','vfCircularity'}
            gp.ylim=[1.15,1.45];
            gp.yticks=[1.15,1.25,1.35,1.45];
            gp.yticklabels=numarray2cellstring(gp.yticks);
            gp.yminorticks=4;
        case {'MT'}
            gp.ylim=[0,2.5];
            gp.yticks=[0,0.5,1,1.5,2,2.5];
            gp.yticklabels=numarray2cellstring(gp.yticks);
            gp.yminorticks=4;
    end
end

% function ylim = get_ylims(vname)
%     if any(strcmp(vname,{'FLS','flsPC','\phi_{SD}','phDiffStd','D_{KL}','KLD','H''Harmonicity',}))
%         ylim=[0,1];
%     elseif any(strcmp(vname,{'\rho','rho'}))
%         ylim=[0,4];    
%     elseif any(strcmp(vname,{'VFC','vfCircularity'}))
%         ylim=[1,1.5];
%     elseif any(strcmp(vname,{'MT'}))
%         ylim=[0,2.5];
%     else
%         ylim=[0,1];
%     end
% end
