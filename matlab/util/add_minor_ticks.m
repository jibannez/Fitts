function h_minorgrid =add_minor_ticks(majorticks,minticks,tickprops,ax)
    if nargin<4, ax='x'; end
    if nargin<3, tickprops=[0,0.1]; end
    
    ticks=ones(0,(length(majorticks)-1)*minticks);
    for i=1:length(majorticks)-1
        tmp=linspace(majorticks(i),majorticks(i+1),minticks+2);
        ticks(1+(i-1)*minticks:i*minticks)=tmp(2:end-1);
    end
    xx = reshape([ticks;ticks;NaN(1,length(ticks))],1,length(ticks)*3);
    yy = repmat([tickprops NaN],1,length(ticks));
    if strcmp(ax,'x')
        h_minorgrid = plot(xx,yy,'k');
    elseif strcmp(ax,'y')
        h_minorgrid = plot(yy,xx,'k');
    else 
        error('wrong axes label')
    end
end