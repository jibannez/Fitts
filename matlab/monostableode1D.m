function dydt = monostableode1D(t,y,kk,w,a,b,c,d,tau)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Model equations:
    %   dy_dt = -tau*(w + a*sin(2*(y-c)+d) + b*cos(4*(y-c)))
    %   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %Define and initialize persistent decay time for pulses
    persistent tpulse;
    if isempty(tpulse), tpulse=0; end
    
    %Gaussian pulse properties
    I=0;                 %Pulse intensity, defaults to 0.
    Imax=1/tau;        %Maximal pulse intensity
    dmax=0.15/tau;       %Maximal pulse duration
    sg=0.025/tau;            %Pulse intensity standart deviation
    phthr=pi/3;          %Phase threshold to start a pulse
    tstart=1.5*sg;   %Advance in time to start a pulse
    
    %Intermediate variables     
    x=cos(y);
    v=sin(y);
    ph=atan2(v,x);
    
    %Check conditions to trigger a new pulse:
    if x*ph>0 && tpulse==0
        %We are in 1st or 3rd quadrant and no pulse is active
        if x<0 && ph < phthr-pi
            %Before reaching bottom target in third quadrant
            tpulse=t;
        elseif x>0 && ph < phthr
            %Before reaching top target in first quadrant
            tpulse=t;
        end
    end
    
    %Deactivate or compute pulse intensity
    if (t-tpulse) >= dmax
        tpulse=0;    
    elseif tpulse > 0
        I=Imax*exp(-((t-(tpulse+tstart))^2)/(2*sg^2));
    end

    %Compute differential equation
    dydt=-tau*( w + a*sin(2*(y-c)+d) + b*cos(4*(y-c))+ I);

end