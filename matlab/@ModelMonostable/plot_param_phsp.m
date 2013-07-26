function plot_param_phsp(mdl,no)    
    if isempty(mdl.pset)
        error('You have to run at least one parametrization')    
    elseif nargin<2 || no==0
        pname=mdl.pset{end}{1};
        prange=mdl.pset{end}{2};
        %p0=mdl.pset{end}{3};
        pset=mdl.pset{end}{4};
    elseif no>0 && no<=length(mdl.pset)
        pname=mdl.pset{no}{1};
        prange=mdl.pset{no}{2};
        %p0=mdl.pset{no}{3};
        pset=mdl.pset{no}{4};
    else
        error('Invalid number of simulation!')
    end

    figtit=sprintf('Parametrization of variable %s: Phase Space', pname);
    figure('name',figtit);
    if mdl.stype<2
        hold on
    else
        ax1=subplot(1,2,1); hold on;
        ax2=subplot(1,2,2); hold on;
    end    
    legnames=cell(length(pset),1);
    for i=1:length(pset)
        mdl.load_ppset(pset{i});
        if mdl.stype<2
            scatter(mdl.ph,abs(mdl.phdot),'.');
        else
            %scatter(ax1,mdl.ph(:,1),abs(mdl.phdot(:,1)),'.');
            %scatter(ax2,mdl.ph(:,2),abs(mdl.phdot(:,2)),'.');
            scatter(ax1,mdl.ph1_phhist,abs(mdl.omega1_phhist),'.');
            scatter(ax2,mdl.ph2_phhist,abs(mdl.omega2_phhist),'.');
        end
        legnames{i}=sprintf('%s=%1.3f',pname,prange(i));
    end

    legend(legnames);
    hline(0,'k-')
end