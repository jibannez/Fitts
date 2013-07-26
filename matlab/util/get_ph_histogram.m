function tshist = get_ph_histogram(ts,ph,bins,iscircular)
    if nargin<4, iscircular=0; end
    if nargin<3, bins=500;end
    
    phbins=linspace(-pi,pi,bins+1);
    tshist=zeros([bins,1]);
       
    %Average over complete cycles
    for l=1:bins
        d=ts(ph>=phbins(l) & ph<phbins(l+1));
        if iscircular
            tshist(l)=circstat(d);
        else
            tshist(l)=median(d);
        end
    end
    %Solve a boundary problem
    tshist(end)=tshist(end-1);
end