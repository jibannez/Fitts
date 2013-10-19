function dydt = automonostableode2D(t,y,kk,w1,w2,a1,a2,b1,b2,c1,c2,d1,d2,alpha,tau1,tau2)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Model equations:
    %   dy1_dt = -(w1 + tau1*(a1*sin(2*(y1-c1)+d1) + b1*cos(4*(y1-c1))) + alpha*sin(y2-y1) + I1)
    %   dy2_dt = -(w2 + tau2*(a2*sin(2*(y2-c2)+d2) + b2*cos(4*(y2-c2))) + alpha*sin(y1-y2) + I2) 
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
   
    
    %Compute differential equation
    dydt=[-1*( w1 + tau1*(a1*sin(2*(y(1)-c1)+d1) + b1*cos(4*(y(1)-c1))) + alpha*sin(y(1)-y(2))) ;...
          -1*( w2 + tau2*(a2*sin(2*(y(2)-c2)+d2) + b2*cos(4*(y(2)-c2))) + alpha*sin(y(2)-y(1)))];

end 