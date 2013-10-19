function res = mpd(tr,do_rel)
%Compute minimal peak delay, absolute and relative
    if nargin<2, do_rel=1; end
    
    if length(tr.ts.Lpeaks)<length(tr.ts.Rpeaks)
        Fastpks=tr.ts.Rpeaks;
        Slowpks=tr.ts.Lpeaks;
        MT=tr.oscR.MT*1000;
    else
        Fastpks=tr.ts.Lpeaks;
        Slowpks=tr.ts.Rpeaks;
        MT=tr.oscL.MT*1000; 
    end
    
    SlowLen = length(Slowpks)-1;
    res=zeros(SlowLen-2,1);
    for i=2:SlowLen-1
        S=Slowpks(i);
        idx=abs(Fastpks-S)<mean(MT);        
        if ~any(idx)
            idx=abs(Fastpks-S)<(2*mean(MT));
        end
        
        F=Fastpks(idx);
        M=MT(idx);
        [d,j]=min(abs(S-F));
        if do_rel
            res(i-1)=d*sign(S-F(j))/M(j);
        else
            res(i-1)=d*sign(S-F(j))/1000;
        end
    end
end