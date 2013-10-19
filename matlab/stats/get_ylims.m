function [ylim,yticks,yticklabels,yminorticks] = get_ylims(vname)
    switch vname
        case {'H','Harmonicity'}
            ylim=[0,1];
            yticks=[0,0.25,0.5,0.75,1];
            yticklabels=num2str(yticks);
            yminorticks=4;
        case {'FLS','flsPC'}
            ylim=[0.5,1];
            yticks=[0.5,0.75,1];
            yticklabels=numarray2cellstring(yticks);
            yminorticks=4;
        case {'\phi_{SD}','phDiffStd'}
            ylim=[0,0.5];
            yticks=[0,0.25,0.5];
            yticklabels=numarray2cellstring(yticks);
            yminorticks=4;
        case {'D_{KL}','KLD'}
            ylim=[0.5,0.8];
            yticks=[0.5,0.6,0.7,0.8];
            yticklabels=numarray2cellstring(yticks);
            yminorticks=4;
        case {'\rho','rho'}
            ylim=[0,4];
            yticks=[0,1,2,3,4];
            yticklabels=numarray2cellstring(yticks);
            yminorticks=4;
        case {'VFC','vfCircularity'}
            ylim=[0.6,1];
            yticks=[0.6,0.8,1];
            yticklabels=numarray2cellstring(yticks);
            yminorticks=4;
        case {'MT'}
            ylim=[1.15,1.45];
            yticks=[1.15,1.25,1.35,1.45];
            yticklabels=numarray2cellstring(yticks);
            yminorticks=4;
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
