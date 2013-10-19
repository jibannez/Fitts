%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p,q]=get_p_q(obj)
Lf=obj.Lf;
Rf=obj.Rf;
if abs(1-Lf/Rf)<0.05
    q=1;p=1;
elseif Lf>Rf
    if abs(1.5-Lf/Rf)<0.075
        p=3; q=2;
    elseif abs(2-Lf/Rf)<0.1
        p=2; q=1;
    elseif abs(2.5-Lf/Rf)<0.125
        p=5; q=2;
    elseif abs(3-Lf/Rf)<0.15
        p=3; q=1;
    elseif abs(3.5-Lf/Rf)<0.175
        p=7; q=2;
    elseif abs(4-Lf/Rf)<0.2
        p=7; q=2;
    elseif abs(4.5-Lf/Rf)<0.225
        p=9; q=2;
    elseif abs(5-Lf/Rf)<0.25
        p=5; q=1;
    else
        [p,q]=rat(Lf/Rf);
    end
else
    if abs(1.5-Rf/Lf)<0.075
        q=3; p=2;
    elseif abs(2-Rf/Lf)<0.1
        q=2; p=1;
    elseif abs(2.5-Rf/Lf)<0.125
        q=5; p=2;
    elseif abs(3-Rf/Lf)<0.15
        q=3; p=1;
    elseif abs(3.5-Rf/Lf)<0.175
        q=7; p=2;
    elseif abs(4-Rf/Lf)<0.2
        q=7; p=2;
    elseif abs(4.5-Rf/Lf)<0.225
        q=9; p=2;
    elseif abs(5-Rf/Lf)<0.25
        q=5; p=1;
    else
        [q,p]=rat(Rf/Lf);
    end
    
end
end