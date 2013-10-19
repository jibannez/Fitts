function plotPHD(sims)
    a=0:0.01:1;
    yarr=zeros(1,length(sims)-1);
    for i=1:length(sims)-1
        yarr(i)=sims{i+1}.mdl.phDiffStd;
    end
    figure
    title('Phase Difference STD')
    scatter(a,yarr,'r.');
end
