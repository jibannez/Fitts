function plotPHDKLD(sims)
    phdarr=zeros(1,length(sims)-1);
    kldarr=zeros(1,length(sims)-1);
    aarr=zeros(1,length(sims)-1);
    for i=1:length(sims)-1
        phdarr(i)=sims{i+1}.phDiffStd;
        kldarr(i)=sims{i+1}.KLD;
        aarr(i)=sims{i+1}.a;
    end
    figure
    hold on;
    title('Phase Difference STD')
    scatter(aarr,phdarr,'r.');
    scatter(aarr,kldarr,'b.');
    hline(sims{1}.ls.phDiffStd,'r')
    hline(sims{1}.ls.KLD,'b')
    ylim([0,1]);
    legend({'PHD','KLD'})
end
