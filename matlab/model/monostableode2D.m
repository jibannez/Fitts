function dydt = monostableode2D(t,y,kk,w1,w2,a1,a2,b1,b2,c1,c2,d1,d2,alpha,tau1,tau2)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Model equations:
    %   dy1_dt = -tau1*(w1 + a1*sin(2*(y1-c1)+d1) + b1*cos(4*(y1-c1)) + alpha*sin(y2-y1) )
    %   dy2_dt = -tau2*(w2 + a2*sin(2*(y2-c2)+d2) + b2*cos(4*(y2-c2)) + alpha*sin(y1-y2) ) 
    %
    % Parameter values (Easy vs Difficult):
    %   w1,   w2,  a1,  a2,  b1,  b2,  c1,     c2,      d1,      d2,   alpha
    %   11.0, 3.5, 3.0, 2.0, 1.0, 0.8, 1.5708, 1.0472, -1.5708,  0.0,  0.2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %Define and initialize persistent decay time for pulses
    persistent tpulse;
    if isempty(tpulse), tpulse=[0,0]; end
    
    %Gaussian pulse properties    
    I=[0,0];           %Pulse intensity, defaults to 0.    
    Imax=2;            %Maximal pulse intensity
    dmax=0.15;         %Maximal pulse duration
    sg=0.025;          %Pulse intensity standart deviation
    phthr=pi/3;        %Phase threshold to start a pulse
    tstart=1.5*sg;     %Advance in time to start a pulse
    
    for h=1:2
        %Intermediate variables     
        x=cos(y(h));
        v=sin(y(h));
        ph=atan2(v,x);

        %Check conditions to trigger a new pulse:
        if x*ph>0 && tpulse(h)==0
            %We are in 1st or 3rd quadrant and no pulse is active
            if x<0 && ph < phthr-pi
                %Before reaching bottom target in third quadrant
                tpulse(h)=t;
            elseif x>0 && ph < phthr
                %Before reaching top target in first quadrant
                tpulse(h)=t;
            end
        end

        %Deactivate or compute pulse intensity
        if (t-tpulse(h)) >= dmax
            tpulse(h)=0;    
        elseif tpulse(h) > 0
            I(h)=Imax*exp(-((t-(tpulse(h)+tstart))^2)/(2*sg^2));
        else
            tpulse(h)=0;
        end
    end
    
    %Compute differential equation
    dydt=[-1*( w1 + tau1*(a1*sin(2*(y(1)-c1)+d1) + b1*cos(4*(y(1)-c1))) + alpha*sin(y(2)-y(1)) + I(1)) ;...
          -1*( w2 + tau2*(a2*sin(2*(y(2)-c2)+d2) + b2*cos(4*(y(2)-c2))) + alpha*sin(y(1)-y(2)) + I(2))];

end