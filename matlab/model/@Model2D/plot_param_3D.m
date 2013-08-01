function plot_param_3D(mdl)
%function [omega,ph,prange]=plot_param_omega2D(mdl,no)

    pname=mdl.pset{end}{1};
    prange=mdl.pset{end}{2};
    parval=mdl.pset{end}{3};
    pset=mdl.pset{end}{4};
    
    %Prepare model and ranges
    p0=mdl.params;
    mdl.load_param(parval);
    ph=mdl.ph1_phhist;
    omega1=zeros(length(prange),length(ph));
    omega2=zeros(length(prange),length(ph));
    
    %Fetch data
    for i=1:length(prange)
        mdl.load_ppset(pset{i});        
        omega1(i,:)=abs(mdl.omega1_phhist);
        omega2(i,:)=abs(mdl.omega2_phhist);
    end
    
    mdl.load_param(p0);    
    figure;     
    surf(ph,prange,omega1)
    colormap(bluewhitered(256))
    shading interp
    %alpha(.51)
    ylabel([pname, ' parameter']);
    xlabel('phase')
    zlabel('phase velocity');
    title('First hand parametrization')
    
    figure;    
    surf(ph,prange,omega2)
    colormap(bluewhitered(256))
    shading interp
    %alpha(.51)
    ylabel([pname, ' parameter']);
    xlabel('phase')
    zlabel('phase velocity');    
    title('Second hand parametrization')
end
%     pranges={ph,prange,min(omega):0.01:max(omega)};
%     %axislabels={'Phase',[pname, ' parameter'],'omega'};    
%     %animate_surf(omega,ranges,axislabels);
%     anymate(@plot_surf,omega);
%     
%     function plot_surf(m)
%         surf(ph,pranges{1},m);
%         colormap(bluewhitered(256));
%         xlabel('phase');
%         ylabel([pname, ' parameter']);
%         zlabel('omega');    
%     end    
% end
        
    %Prepare figures and do plotting
%     figtit=sprintf('Parametrization of variable %s: Theoretical Phase~Omega functional dependence', pname);
%     figure('name',figtit);
%     hold on;
%     surf(ph,prange,omega);
%     title(['Phase-Omega relationship for varying ',pname]);
%     xlabel('Phase');
%     ylabel([pname ' parameter']);
%     zlabel('omega');
%end
