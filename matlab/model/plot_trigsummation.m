function plot_trigsummation()
    c_values=containers.Map({'e','m','d'}, { pi/2, pi/3, pi/3});
    d_values=containers.Map({'e','m','d'}, {-pi/2, 0   , 0});
    th=-pi:0.02:pi;
    figure()
    
    subplot(2,1,1); hold on;
    c=c_values('e');
    d=d_values('e');
    title('Summation of Harmonics: Easy trial')
    plot(th,2*sin(2*(th-c)+d)+1*cos(4*(th-c)),'m');
    plot(th,2*sin(2*(th-c)+d),'r--'); 
    plot(th,1*cos(4*(th-c)),'b--'); 
    hline(0,'k');
    xlim([-pi,pi]);
    legend({'\theta dot','First Harmonic','Second Harmonic'});
    
    subplot(2,1,2); hold on;
    c=c_values('d');
    d=d_values('d');
    title('Summation of Harmonics: Difficult trial')
    plot(th,2*sin(2*(th-c)+d)+1*cos(4*(th-c)),'m');
    plot(th,2*sin(2*(th-c)+d),'r--'); 
    plot(th,1*cos(4*(th-c)),'b--'); 
    hline(0,'k');
    xlim([-pi,pi]);
end