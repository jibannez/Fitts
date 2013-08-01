function plot_single_phsp(mdl)
    if isempty(mdl.t)
        mdl.run()
    end

    %Phase planes
    if mdl.stype<2
        %Phase planes on angular variables (ph,phdot)
        figure('name','Phase phane of angular and cartesian variables');
        subplot(1,2,1);hold on;
        title('Angular phase plane');
        scatter(mdl.ph_phhist,abs(mdl.omega_hist),'.')        
        qz=zeros(length(mdl.vf{1}),1)';
        quiver(mdl.vf{1},qz,mdl.vf{2},qz)
        xlabel('ph')
        ylabel('phdot')
        xlim([-pi,pi])
        ylim([-1 -min(mdl.phdot)])
        hline(0,'k');
        
        %Phase planes on cartesian coordinates (x,v)
        subplot(1,2,2);
        title('Cartesian phase plane');
        scatter(mdl.phcos,mdl.phcosdot,'.')
        xlabel('position')
        ylabel('velocity')
        xlim([-1,1]);
        hline(0,'k');
        vline(0,'k');
    else
        %Phase planes on angular variables (ph,phdot)
        figure('name','Phase phane of ph1 and ph2');
        subplot(2,1,1);
        %scatter(mdl.phmod(:,1),-mdl.phdot(:,1),'.')
        scatter(mdl.ph1_phhist,-mdl.omega1_phhist,'.')
        xlabel('ph1')
        ylabel('ph1dot')
        xlim([-pi,pi])
        ylim([-1 -min(mdl.phdot(:,1))])

        subplot(2,1,2);
        %scatter(mdl.phmod(:,2),-mdl.phdot(:,2),'.')
        scatter(mdl.ph2_phhist,-mdl.omega2_phhist,'.')
        xlabel('ph2')
        ylabel('ph2dot')
        xlim([-pi,pi])
        ylim([-1 -min(mdl.phdot(:,2))])

        %Phase planes on cartesian coordinates (x,v)
        figure('name','Phase phanes  of (x1,v1) and (x2,v2)');        
        subplot(2,2,1);
        scatter(mdl.x1,mdl.v1,'.')
        xlabel('Left position')
        ylabel('Left velocity')
        %xlim([-1,1]);
        %ylim([-1,1]);

        subplot(2,2,2);
        scatter(mdl.x2,mdl.v2,'.')
        xlabel('Right position')
        ylabel('Right velocity')
        %xlim([-1,1]);
        %ylim([-1,1]);
        
        %Normalized Phase planes on cartesian coordinates (x,v)
        %figure('name','Normalized phase phane  of (x1,v1) and (x2,v2)');
        subplot(2,2,3);
        scatter(mdl.xnorm1,mdl.vnorm1,'.')
        xlabel('Normalized Left position')
        ylabel('Normalized Left velocity')

        subplot(2,2,4);
        scatter(mdl.xnorm2,mdl.vnorm2,'.')
        xlabel('Normalized Right position')
        ylabel('Normalized Right velocity')
    end
end        