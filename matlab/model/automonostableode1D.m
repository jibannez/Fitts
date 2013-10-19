function dydt = automonostableode1D(t,y,kk,w,a,b,c,d,tau)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Model equations:
    %   dy_dt = -tau*(w + a*sin(2*(y-c)+d) + b*cos(4*(y-c)))
    %   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Compute differential equation
    dydt=-1*( w + tau*(a*sin(2*(y-c)+d) + b*cos(4*(y-c)))); 
end