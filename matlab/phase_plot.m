function m=phase_plot(tr,diffs)
    if nargin<2, diffs=[0,0.2,0.5,1,5]; end
    
    %Get properties of the plot and prepare models 
    dno=length(diffs);    
    if isa(tr,'Trial')
        m=cell(1,dno+1);
        m{1}=struct();
        for i=1:dno
            mdl=ModelMonostable('ed1');
            mdl.fit(tr,0,diffs(i)); 
            m{i+1}=mdl;
        end
        m{1}.phDiff=resize_vector(tr.ls.phDiff,length(tr.ls.phDiff)*m{2}.fs/tr.conf.fs);
        m{1}.KLD=tr.ls.KLD;
        m{1}.phDiffStd=tr.ls.phDiffStd;
    else
        m=tr;
        tr=m{1};
        m{1}=struct();
        m{1}.phDiff=resize_vector(tr.ls.phDiff,length(tr.ls.phDiff)*m{2}.fs/tr.conf.fs);
        m{1}.KLD=tr.ls.KLD;
        m{1}.phDiffStd=tr.ls.phDiffStd;
    end
    
    %Prepare figure titles
    titles=cell(1,dno+1);
    KLDS=cell(1,dno+1);
    PHDS=cell(1,dno+1);    
    tslen=10^8;
    for i=1:dno+1
        KLDS{i}=sprintf('$KLD=%1.2f$',m{i}.KLD);
        PHDS{i}=sprintf('$\\phi_{SD}=%1.2f$',m{i}.phDiffStd);
        if i==1
            titles{i}='$Experimental \phi$';            
        else
            titles{i}=sprintf('$\\alpha=%1.2f$',diffs(i-1));
        end
        if tslen>length(m{i}.phDiff)
            tslen=length(m{i}.phDiff);
        end
    end
    
    %Prepare limits and do plotting
    idx=1:tslen;
    ylimits=[-4,4];
    cutoff=2;
    xmsg=0.12;
    figure;
    for i=1:dno+1
        subplot(1,dno+1,i);
        hold on;
        title(titles{i},'interpreter','latex')
        plot(m{i}.phDiff(idx),'k')
        plot(filterdata(m{i}.phDiff(idx),cutoff),'r');
        hline(0,'-k')
        text(xmsg,3.9,KLDS{i},'interpreter','latex')
        text(xmsg,3.7,PHDS{i},'interpreter','latex')
        xlim([0,tslen])
        ylim(ylimits)
    end
    m{1}=tr;
end
