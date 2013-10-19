function sims = simulamil(tr,reps)
    if nargin<2, reps=1; end
    %if nargin<2, a=0:0.01:1; end

    a=0:0.01:2;
    ar=length(a);
    sims=cell(1,ar*reps+1);
    sims{1}=tr;
    idx=1;
    for i=1:ar
        for r=1:reps
            idx=idx+1;
            res=struct();
            res.mdl=ModelMonostable('ed1');
            res.pfit=res.mdl.fit(tr,0,a(i));
            res.a=a(i);
            res.phDiffStd=res.mdl.phDiffStd;
            res.KLD=res.mdl.KLD;
            sims{idx}=res;
        end
    end
end