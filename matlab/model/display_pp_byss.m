function display_pp_byss(res,average_rep)
if nargin < 2, average_rep=1; end

if length(size(res))==5
    [ss,idl,idr,reps,kk]=size(res);
    
    fprintf('\n\nResults \n')
    fprintf('--------------------------------------------------------------------------------------------------------------------------\n')
    if average_rep
        fprintf(' IDL \t IDR \t Ss \t w1 \t w2 \t nl1 \t nl2 \t sE1 \t sE2 \t sS1 \t sS2 \t ghdist1 ghdist2\n');
    else
        fprintf(' IDL \t IDR \t Ss \t rep \t w1 \t w2 \t nl1 \t nl2 \t sE1 \t sE2 \t sS1 \t sS2 \t ghdist1 ghdist2\n');
    end
    fprintf('--------------------------------------------------------------------------------------------------------------------------\n')
    for l=1:idl
        for r=1:idr
            for s=1:ss
                if average_rep
                    pp=zeros([10,1]);
                    for rep=1:reps
                        ps=res{s,l,r,rep,1};
                        sg=res{s,l,r,rep,2};
                        pp(1)=pp(1)+ps(1)/rep;
                        pp(2)=pp(2)+ps(2)/rep;
                        pp(3)=pp(3)+5*ps(12)/rep;
                        pp(4)=pp(4)+5*ps(13)/rep;
                        pp(5)=pp(5)+4*sg(1)/rep;
                        pp(6)=pp(6)+4*sg(2)/rep;
                        pp(7)=pp(7)+4*sg(3)/rep;
                        pp(8)=pp(8)+4*sg(4)/rep;
                        if l==1
                            pp(9)=pp(9)+(ps(1)-ps(12)*3)/rep;
                        else
                            pp(9)=pp(9)+(ps(1)-ps(12)*1.5)/rep;
                        end
                        if r==1
                            pp(10)=pp(10)+(ps(2)-ps(13)*3)/rep;
                        else
                            pp(10)=pp(10)+(ps(2)-ps(13)*1.5)/rep;
                        end
                    end
                    pp=num2cell(pp);
                    fprintf(' %d \t %d \t %d \t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f\n',...
                        l,   r,  s, pp{:});
                else
                    for rep=1:reps
                        ps=res{s,l,r,rep,1};
                        sg=res{s,l,r,rep,2};
                        if l==1
                            ghdist1=ps(1)-ps(12)*3;
                        else
                            ghdist1=ps(1)-ps(12)*1.5;
                        end
                        if r==1
                            ghdist2=ps(2)-ps(13)*3;
                        else
                            ghdist2=ps(2)-ps(13)*1.5;
                        end
                        fprintf(' %d \t %d \t %d \t %d \t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f\n',...
                            l,   r,  s,  rep,  ps(1),ps(2),5*ps(12),5*ps(13),4*sg(1),4*sg(2),4*sg(3),4*sg(4),ghdist1,ghdist2);
                    end
                    if r<idr
                        fprintf('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n')
                    end
                end
            end
            if (r~=idr)
                fprintf('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n')
            else
                fprintf('--------------------------------------------------------------------------------------------------------------------------\n')
            end
        end
    end
else
    [ss,id,reps,kk]=size(res);
    fprintf('\n\n Unimanual Results\n')
    fprintf('---------------------------------------------------------------------\n')
    if average_rep
        fprintf(' ID \t Ss \t w \t nl \t sE \t sS \t ghdist\n');
    else
        fprintf(' ID \t Ss \t rep \t w \t nl \t sE \t sS \t ghdist\n');
    end
    fprintf('---------------------------------------------------------------------\n')
    for i=1:id
        for s=1:ss
            if average_rep
                pp=zeros([4,1]);
                for rep=1:reps
                    ps=res{s,i,rep,1};
                    sg=res{s,i,rep,2};
                    pp(1)=pp(1)+ps(1)/rep;
                    pp(2)=pp(2)+5*ps(end)/rep;
                    pp(3)=pp(3)+4*sg(1)/rep;
                    pp(4)=pp(4)+4*sg(2)/rep;
                    if i==1
                        ghdist=ps(1)-ps(end)*3;
                    else
                        ghdist=ps(1)-ps(end)*1.5;
                    end
                end
                pp=num2cell(pp);
                fprintf('%d  \t %d \t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f\n',i,s,pp{:},ghdist);
            else
                for rep=1:reps
                    ps=res{s,i,rep,1};
                    sg=res{s,i,rep,2};
                    if i==1
                        ghdist=ps(1)-ps(end)*3;
                    else
                        ghdist=ps(1)-ps(end)*1.5;
                    end
                    fprintf('%d \t %d \t %d \t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f\n',...
                        i, s,  rep,  ps(1),5*ps(end),4*sg(1),4*sg(2),ghdist);
                end
                if s<ss
                        fprintf('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .\n')
                end
            end            
        end
        fprintf('---------------------------------------------------------------------\n')
    end
end
    