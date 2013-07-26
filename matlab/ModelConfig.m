classdef ModelConfig < handle
    
    properties
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                          
        %%%%%%%%   Model Equations    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                          
        
        %%%%%%%%   Model Equations    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fit1D= @(p, y) -1.1*( p(1) + p(2)*sin(2*(y-p(4))+p(5)) + p(3)*cos(4*(y-p(4))));
        ode1D=inline('-1.1*(w + a*sin(2*(y-c) + d) + b*cos(4*(y-c)))',...
                    't','y','kk','w','a','b','c','d')         
        vf1D=inline('-1.1*(w + a*sin(2*(y-c)+d) + b*cos(4*(y-c)));',...
                    'y','w','a','b','c','d')        
        potencial1D=inline('-1.1*(w*y-a/2*cos(2*(y-c)+d)+4*b*cos(4*(y-c)))','y','w','a','b','c','d')                 
        
        
        %%%%%%%%   Model Equations    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fit11D= @(p, y) -1.1*( p(1) + p(2)*cos(2*(y-p(4))+p(5)) + p(3)*sin(4*(y-p(4))));
        ode11D=inline('-1.1*(w + a*cos(2*(y-c) + d) + b*sin(4*(y-c)))',...
                    't','y','kk','w','a','b','c','d')         
        vf11D=inline('-1.1*(w + a*cos(2*(y-c)+d) + b*sin(4*(y-c)));',...
                    'y','w','a','b','c','d')        
        potencial11D=inline('-1.1*(w*y-a/2*cos(2*(y-c)+d)+4*b*cos(4*(y-c)))','y','w','a','b','c','d')             
        
        
        %%%%%%%%   Model Equations    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fit12D= @(p, y) -1.1*( p(1) + p(2)*cos(2*(y-p(4))+p(5)) + p(3)*cos(4*(y-p(4))));
        ode12D=inline('-1.1*(w + a*cos(2*(y-c) + d) + b*cos(4*(y-c)))',...
                    't','y','kk','w','a','b','c','d')         
        vf12D=inline('-1.1*(w + a*cos(2*(y-c)+d) + b*cos(4*(y-c)));',...
                    'y','w','a','b','c','d')        
        potencial12D=inline('-1.1*(w*y-a/2*sin(2*(y-c)+d)+4*b*sin(4*(y-c)))','y','w','a','b','c','d')               
                
        %%%%%%%%   Model Equations    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fit13D= @(p, y) -1.1*( p(1) + p(2)*sin(2*(y-p(4))+p(5)) + p(3)*sin(4*(y-p(4))));
        ode13D=inline('-1.1*(w + a*sin(2*(y-c) + d) + b*sin(4*(y-c)))',...
                    't','y','kk','w','a','b','c','d')         
        vf13D=inline('-1.1*(w + a*sin(2*(y-c)+d) + b*sin(4*(y-c)));',...
                    'y','w','a','b','c','d')        
        potencial13D=inline('-1.1*(w*y-a/2*cos(2*(y-c)+d)+4*b*cos(4*(y-c)))','y','w','a','b','c','d')             
        
        
        %%%%%%%%   Model Equations    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fit14D= @(p, y) -1.1*( p(1) + p(2)*cos(2*(y-p(4))+p(5)) + p(3)*cos(4*(y-p(4))));
        ode14D=inline('-1.1*(w + a*cos(2*(y-c) + d) + b*cos(4*(y-c)))',...
                    't','y','kk','w','a','b','c','d')         
        vf14D=inline('-1.1*(w + a*cos(2*(y-c)+d) + b*cos(4*(y-c)));',...
                    'y','w','a','b','c','d')        
        potencial14D=inline('-1.1*(w*y-a/2*sin(2*(y-c)+d)+4*b*sin(4*(y-c)))','y','w','a','b','c','d')       
        
        
        %%%%%%%%   Model Equations    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fit15D= @(p, y) -( p(2)/p(1) + p(3)/p(1)*sin(2*(y-p(5))+p(6)) + p(4)*p(1)*cos(4*(y-p(5))));
        ode15D=inline('-(w/id + a/id*sin(2*(y-c) + d) + b*id*cos(4*(y-c)))',...
                     't','y','kk','id','w','a','b','c','d') 
        vf15D=inline('-(w/id + a/id*sin(2*(y-c)+d) + b*id*cos(4*(y-c)));',...
                     'y','id','w','a','b','c','d')
        potencial15D=inline('-(w*y-a/(2*id)*cos(2*(y-c)+d)+b*id/4*cos(4*(y-c)))','y','id','w','a','b','c','d')                
        
        
        %%%%%%%%   Model Equations    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fit16D= @(p, y) -1.1*( p(1) + p(2)*sin(2*(y-p(4))) + p(3)*cos(4*(y+p(4))));
        ode16D=inline('-1.1*(w + a*sin(2*(y-c)) + b*cos(4*(y+c)))',...
                    't','y','kk','w','a','b','c')         
        vf16D=inline('-1.1*(w + a*sin(2*(y-c)) + b*cos(4*(y+c)));',...
                    'y','w','a','b','c')        
        potencial16D=inline('-1.1*(w*y-a/2*cos(2*(y-c))+4*b*sin(4*(y+c)))','y','w','a','b','c')                 

        %%%%%%%%   Model Equations    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fit17D= @(p, y) -1.1*( p(1) + p(2)*sin(2*y+p(4)) + p(3)*cos(4*y));
        ode17D=inline('-1.1*(w + a*sin(2*y+d) + b*cos(4*y))',...
                    't','y','kk','w','a','b','d')         
        vf17D=inline('-1.1*(w + a*sin(2*y+d) + b*cos(4*y));',...
                    'y','w','a','b','d')        
        potencial17D=inline('-1.1*(w*y-a/2*cos(2*y+d)+4*b*cos(4*y))','y','w','a','b','d')
        
         
 
        
%         %%%%%%%%   Model Equations    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         fit2D= @(p, y) [ -1.1*( p(1) + p(3)*sin(2*(y(1)-p(5))+p(6)) + p(4)*cos(4*(y(1)-p(5))))+ p(7)*sin(y(2)-y(1)) ;...
%                          -1.1*( p(2) + p(3)*sin(2*(y(2)-p(5))+p(6)) + p(4)*cos(4*(y(2)-p(5))))+ p(7)*sin(y(1)-y(2))];
%         ode2D=inline([ '[-1.1*( w1 + a*sin(2*(y(1)-c)+d) + b*cos(4*(y(1)-c)) + alpha*sin(y(2)-y(1))) ;' ...
%                       '  -1.1*( w2 + a*sin(2*(y(2)-c)+d) + b*cos(4*(y(2)-c)) + alpha*sin(y(1)-y(2))) ]'],...
%                       't','y','kk','w1','w2','a','b','c','d','alpha')
%         vf2D=inline(' -1.1*( w + a*sin(2*(y1-c)+d) + b*cos(4*(y1-c)) + alpha*sin(y1-y2))',...
%                     'y1','y2','w','a','b','c','d','alpha')
%         nc1 =inline(' -1.1*( y - asin(-(w + a*sin(2*(y-c)+d) + b*cos(4*(y-c))) / (alpha)) + pi*n)','y','w','alpha','a','b','c','d','n')
%         nc2 =inline(' -1.1*( y + asin(-(w + a*sin(2*(y-c)+d) + b*cos(4*(y-c))) / (alpha)) + pi*n)','y','w','alpha','a','b','c','d','n')
% 

        %%%%%%%%   Model Equations    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fit2D= @(p, y) [ -0.8*( p(1) + p(3)*sin(2*(y(1)-p(7))+p(9)) + p(5)*cos(4*(y(1)-p(7))))+ p(11)*sin(y(2)-y(1)) ;...
                         -0.8*( p(2) + p(4)*sin(2*(y(2)-p(8))+p(10)) + p(6)*cos(4*(y(2)-p(8))))+ p(11)*sin(y(1)-y(2))];
        ode2D=inline([ '[-1*( w1 + a1*sin(2*(y(1)-c1)+d1) + b1*cos(4*(y(1)-c1)) + alpha*sin(y(2)-y(1))) ;' ...
                      '  -1*( w2 + a2*sin(2*(y(2)-c2)+d2) + b2*cos(4*(y(2)-c2)) + alpha*sin(y(1)-y(2))) ]'],...
                      't','y','kk','w1','w2','a1','a2','b1','b2','c1','c2','d1','d2','alpha')
        vf2D=inline(' -1*( w + a*sin(2*(y1-c)+d) + b*cos(4*(y1-c)) + alpha*sin(y1-y2))',...
                    'y1','y2','w','a','b','c','d','alpha')
        nc1 =inline(' -1*( y - asin(-(w + a*sin(2*(y-c)+d) + b*cos(4*(y-c))) / (alpha)) + pi*n)','y','w','alpha','a','b','c','d','n')
        nc2 =inline(' -1*( y + asin(-(w + a*sin(2*(y-c)+d) + b*cos(4*(y-c))) / (alpha)) + pi*n)','y','w','alpha','a','b','c','d','n')

        
        %%%%%%%%   Model Equations    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        fit25D= @(p, y) [-1.1*( p(3)/p(1) + p(5)*sin(2*(y(1)-p(7))+p(8)) + p(6)*cos(4*(y(1)-p(7))))+ p(8)*sin(y(2)-y(1)) ;...
                         -1.1*( p(4)/p(2) + p(5)*sin(2*(y(2)-p(7))+p(8)) + p(6)*cos(4*(y(2)-p(7))))+ p(8)*sin(y(1)-y(2))];
        ode25D=inline([ '[-1.1*(w1/id1 + a/id1*sin(2*(y(1)-c)+d) + b*id1*cos(4*(y(1)-c)) + alpha*sin(y(2)-y(1))) ;' ...
                      '   -1.1*(w2/id2 + a/id2*sin(2*(y(2)-c)+d) + b*id2*cos(4*(y(2)-c)) + alpha*sin(y(1)-y(2))) ]'],...
                      't','y','kk','id1','id2','w1','w2','alpha','a','b','c','d')
        vf25D=inline('-(w/id + a*sin(2*(y1-c)+d) + b*id*cos(4*(y1-c)) + alpha*sin(y1-y2))',...
                     'y1','y2','id','w','alpha','a','b','c','d')
        nc1_25D =inline('-(y - asin(-(w/id + a/id*sin(2*(y-c)+d) + b*id*cos(4*(y-c))) / (alpha)) + pi*n)','y','id','w','alpha','a','b','c','d','n')
        nc2_25D =inline('-(y + asin(-(w/id + a/id*sin(2*(y-c)+d) + b*id*cos(4*(y-c))) / (alpha)) + pi*n)','y','id','w','alpha','a','b','c','d','n')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%   Model Equations    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fit3D= @(p, y) [-1.1*( p(1) + p(3)*sin(2*(y(1)-p(7))+p(9 )) + p(5)*cos(4*(y(1)-p(7))) + p(11)*sin(y(2)-y(1)) ) ;...
                        -1.1*( p(2) + p(4)*sin(2*(y(2)-p(8))+p(10)) + p(6)*cos(4*(y(2)-p(8))) + p(12)*sin(y(1)-y(2)) )];
        ode3D=inline([ '[-1.1*( w1 + a1*sin(2*(y(1)-c1)+d1) + b1*cos(4*(y(1)-c1)) + alpha1*sin(y(2)-y(1)) ) ;' ...
                      '  -1.1*( w2 + a2*sin(2*(y(2)-c2)+d2) + b2*cos(4*(y(2)-c2)) + alpha2*sin(y(1)-y(2)) ) ]'],...
                      't','y','kk','w1','w2','a1','a2','b1','b2','c1','c2','d1','d2','alpha1','alpha2')
        vf3D=inline('-(w + a*sin(2*(y1-c)+d) + b*cos(4*(y1-c)) + alpha*sin(y1-y2))',...
                    'y1','y2','w','alpha','a','b','c','d')
        nc1_3D =inline('-(y - asin(-(w + a*sin(2*(y-c)+d) + b*cos(4*(y-c))) / (alpha)) + pi*n)','y','w','alpha','a','b','c','d','n')
        nc2_3D =inline('-(y + asin(-(w + a*sin(2*(y-c)+d) + b*cos(4*(y-c))) / (alpha)) + pi*n)','y','w','alpha','a','b','c','d','n')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%           Model Parameters          %%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                                        %
        parnames1D={'w','a','b','c','d'}                                %
                                                                        %
        parnames15D={'id','w','a','b','c','d'}                          %
                                                                        %
        parnames16D={'w','a','b','c'}                                   %
                                                                        %
        parnames17D={'w','a','b','d'}                                   %
                                                                        %                                                                                                                                                
        %parnames2D={'w1','w2','a','b','c','d','alpha'}                  %
        parnames2D={'w1','w2','a1','a2','b1','b2','c1','c2','d1','d2','alpha'} %
                                                                        %
        parnames25D={'id1','id2','w1','w2','a','b','c','d','alpha'}     %
                                                                        %
        %%%%%%%%   id1  id2   w1   w2    a    b     c     d  alpha %%%%%%
        %params1D= {          3.8,       1,  1,   0,    0}              %
        params1D= {           6,         2.5, 2, pi/3,    0}            %
                                                                        %
        params11D={           6,         2.5, 2,    0,    0}            %
                                                                        % 
        params12D={           6,         2.5, 2,    0,    0}            %  
                                                                        %         
        params13D={           6,         2.5, 2, pi/3,    0}            %
                                                                        %
        params14D={           6,         2.5, 2, pi/3,    0}            %
                                                                        %                                                                        
        params15D={ 5,        20,        5,   0.5,  0,    0}            %
                                                                        %
        params16D={           6,         2.5, 2,    0,    0}            %
                                                                        % 
        params17D={           6,         2.5, 2,    0,    0}            %  
                                                                        %
        params2D= {          1.8,  1.7,  1,   2,    0,    0,     0}     %
                                                                        %
        params25D={ 5,   5,  1.8,  1.7,  1,   2,    0,    0,     0}     %
                                                                        %
        params2Dc={          1.8,  1.7,  1,   2,    0,    0,     0.2}   %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
        %%%%%%%%           w    a    b    c     d       tau          %%%%
        params1Dbyname=containers.Map({'e','m1','m3','d'},...     
                        {[11.0, 3.0, 1.0, pi/2, -pi/2],...
                         [ 4.5, 0.5, 0.5, pi/2, -pi/4],...
                         [ 5.0, 0.8, 0.8, pi/3, -pi/4],...
                         [ 3.2, 1.5, 1.0,  1.0,   0.0]});        
        params1Dmonostablebyname=containers.Map({'e','m1','m3','d'},...     
                        {[11.0, 3.0, 1.0, pi/2, -pi/2, 1],...
                         [ 4.5, 0.5, 0.5, pi/2, -pi/4, 1],...
                         [ 5.0, 0.8, 0.8, pi/3, -pi/4, 1],...
                         [ 3.2, 2.0, 1.0,  1.0,   0.0, 1]});
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%          w1    w2    a1    a2    b1   b2     c1    c2     d1     d2   alpha1  %%%%
        params2Dbyname=containers.Map({'ee','em','ed','dm','dd'},...                    
                       {[11.0, 11.0,  3.0,  3.0,  1.0, 1.0, pi/2,  pi/2, -pi/2, -pi/2,  0.2],...
                        [11.0,  4.5,  3.0,  0.5,  1.0, 0.5, pi/2,  pi/2, -pi/2, -pi/4,  0.2],...
                        [11.0,  3.2,  3.0,  1.5,  1.0, 0.8, pi/2,  pi/3, -pi/2,   0.0,  0.2],...
                        [ 3.2,  4.5,  1.5,  0.5,  1.0, 0.5,  pi/3, pi/2,  0.0,  -pi/4,  0.2],...
                        [ 3.2,  3.2,  1.5,  1.5,  1.0, 1.0,  pi/3, pi/3,  0.0,   0.0,   0.2]})
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%          w1    w2    a1    a2    b1   b2     c1    c2     d1     d2   alpha1 tau%
        params2Dmonostablebyname=containers.Map({'ee','em','ed1','ed3','md3','dd'},...                    
                       {[11.0,11.0,  3.0,  3.0,  1.0, 1.0, pi/2,  pi/2, -pi/2, -pi/2,  0.2,   1],...
                        [11.0, 4.5,  3.0,  0.5,  1.0, 0.5, pi/2,  pi/2, -pi/2, -pi/4,  0.2,   1],...
                        [11.0, 2.0,  3.0,  1.1,  1.0, 0.5, pi/2,  pi/3, -pi/2,   0.0,  0.2,   1],...
                        [11.0, 3.2,  3.0,  2.0,  1.0, 1.0, pi/2,  pi/3, -pi/2,   0.0,  0.2,   1],...                        
                        [ 4.5, 3.2,  0.5,  1.5,  0.5, 1.0, pi/2,  pi/3, -pi/4,   0.0,  0.2,   1],...
                        [ 3.2, 3.2,  2.0,  2.0,  1.0, 1.0, pi/3,  pi/3,  0.0,    0.0,  0.2,   1]})
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        parnames3D={         'w1','w2','a1','a2','b1','b2','c1','c2','d1','d2','alpha1','alpha2'}%
        %%%%%%%%   id1  id2   w1   w2    a1    a2    b1   b2    c1   c2   d1   d2  alpha1 alpha2 %
        params3D= {          3.0,  6.0,  1.0,  2.0,  0.0, 0.0,  0.0  0.0  0.0  0.0   0.2    0.2 }%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%          w1    w2    a1    a2    b1   b2     c1    c2     d1     d2   alpha1  alpha2 %%%%
        params3Dbyname=containers.Map({'ee','em','ed','dm','dd'},...                    
                       {[11.0, 11.0,  3.0,  3.0,  1.0, 1.0, pi/2,  pi/2, -pi/2, -pi/2,  0.2,    0.2],...
                        [11.0,  4.5,  3.0,  0.5,  1.0, 0.5, pi/2,  pi/2, -pi/2, -pi/4,  0.2,    0.2],...
                        [11.0,  3.2,  3.0,  1.5,  1.0, 0.8, pi/2,  pi/3, -pi/2,   0.0,  0.2,    0.2],...
                        [ 3.2,  4.5,  1.5,  0.5,  1.0, 0.5,  pi/3, pi/2,  0.0,  -pi/4,  0.2,    0.2],...
                        [ 3.2,  3.2,  1.5,  1.5,  1.0, 1.0,  pi/3, pi/3,  0.0,   0.0,   0.2,    0.2]})
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%    SEMINAR-SPECIFIC FUNCTIONS                       %%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                %    
        %%%%%%%%   Model Equations and Parameters                    %%%%%
                                                                         %
        ode1Da=inline('omega + a*sin(y)',...                             %
                     't','y','kk','omega','a')                           %
        ode1Db=inline('omega + a*sin(2*(y-c) + d)',...                   %
                     't','y','kk','omega','a','c','d')                   %
                                                                         %
        vf1Da=inline('omega + a*sin(y)',...                              %
                     'y','omega','a');                                   %
                                                                         %
        vf1Db=inline('omega + a*sin(2*(y-c) + d)',...                    %
                     'y','omega','a','c','d');                           %
                                                                         %
        %%%%%%%%    Parameters for the seminar                     %%%%%%%        
                                                                         %
        parnames1Da={'omega','a'}                                        %
                                                                         %
        parnames1Db={'omega','a','c','d'}                                %
                                                                         %        
        %%%%%%%%   omega1  omega2  alpha    a    b    c     d      %%%%%%%   
                                                                         %
        params1Da= { 1.8,                   1,                }          %
                                                                         %
        params1Db= { 1.8,                   1,         .5,   0}          %
                                                                         %        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%       Integration Parameters        %%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                                        %
        IC1D=[0]                                                        %
                                                                        %
        IC2D=[0,0]                                                      %
                                                                        %
        tspan=[0,6*pi]                                                  %
                                                                        %
        ode                                                             %
                                                                        %
        options                                                         %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%           Torus Configurations      %%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        r1=5                                                            %
                                                                        %
        r2=10;                                                          %
                                                                        %
        n=30;                                                           %
                                                                        %
        cm=[1 1 0];                                                     %
                                                                        %    
        deltator=0.1;                                                   %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%           Other Configurations      %%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot=0                                                          %
                                                                        %
        vfrange1D=-pi:pi/16:pi;                                         %
                                                                        %
        vfrange2D={-2*pi:0.2:2*pi+0.1;-2*pi:0.2:2*pi+0.1};              %
                                                                        %
        ncrange={-2*pi:0.001:2*pi+0.1;-2*pi:0.001:2*pi+0.1};            %
                                                                        %    
        ph_periods=-2:1:2;                                              %
                                                                        %
        bins=1000;                                                      %
                                                                        %
        peak_size=0.1                                                   %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%          Ploting configurations            %%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        savepath='./modelplots'                                         %
                                                                        %
        ext='png'                                                       %
                                                                        %
        dpi=300                                                         %
                                                                        %
        figsize=[0,0,2400,1800]                                         %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end % properties
    
    properties(SetObservable = true)
      stoch=0
    end
    
    events
      PostSet
    end
    
    methods
        %%%%%%%%%%%%%
        % Constructor
        %%%%%%%%%%%%%
        function mdlcfg = ModelConfig()            
            mdlcfg.options = odeset('MaxStep',.01); % maximal time integration step
            
            if mdlcfg.stoch==1
                mdlcfg.ode=@ode15sn;        
                mdlcfg.options.Q = 0.005;              % noise strength with same dimension as variable
                mdlcfg.options.NoiseFn = 'ynoise';      % Noise function
            else
                mdlcfg.ode=@ode23;
            end
            
            if ~isempty(mdlcfg.savepath) && ~exist(mdlcfg.savepath,'dir') 
                mkdir(mdlcfg.savepath);
            end
            addlistener(mdlcfg,'stoch','PostSet',@(src,evnt)update_stoch(mdlcfg,src,evnt));
            
        end
        
        function update_stoch(mdlcfg,src,evnt)
            mdlcfg.options = odeset('MaxStep',.01);
            if mdlcfg.stoch==1
                mdlcfg.ode=@ode15sn;        
                mdlcfg.options.Q = 0.005;              
                mdlcfg.options.NoiseFn = 'ynoise';      
            else
                mdlcfg.ode=@ode23;
            end
            if ~isempty(mdlcfg.savepath) && ~exist(mdlcfg.savepath,'dir') 
                mkdir(mdlcfg.savepath);
            end
            notify(mdlcfg,'PostSet');
        end
            
    end

end
