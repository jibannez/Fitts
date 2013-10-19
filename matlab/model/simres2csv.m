function simres2csv(res,average_rep,filepath)
    if nargin < 3, filepath='modeltables.txt'; end
    if nargin < 2, average_rep=1; end


    if average_rep
        header=get_header_averaged(res);
        matrix=get_row_data_averaged(res);    
    else
        header=get_header(res);
        matrix=get_row_data(res);
    end
    printtable(matrix,header,filepath)
end

%---------------------------------------------------------------------
function header = get_header_averaged(res)
    if length(size(res))==5
        header=['IDL,IDR,S,',...
                'thetadot1exp_m,thetadot1exp_s,theta1th,kk1,thetadot1sim_m,thetadot1sim_s,',...
                'thetadot2exp_m,thetadot2exp_s,theta2th,kk2,thetadot2sim_m,thetadot2sim_s,',...
                'thetadot1expVAR_m,thetadot1expVAR_s,thetadot1simVAR_m,thetadot1simVAR_s,',...
                'thetadot2expVAR_m,thetadot2expVAR_s,thetadot2simVAR_m,thetadot2simVAR_s,',...                
                'w1_m,w1_s,w2_m,w2_s,nl1_m,nl1_s,nl2_m,nl2_s,',...
                'ghdist1_m,ghdist1_s,ghdist2_m,ghdist2_s'];
    else
        header=['ID,S,',...
                'thetadotexp_m,thetadotexp_s,thetath,thetadotsim_m,thetadotsim_s,',...                
                'thetadotexpVAR_m,thetadotexpVAR_s,thetadotsimVAR_m,thetadotsimVAR_s,',...                
                'w_m,w_s,nl_m,nl_s,ghdist_m,ghdist_s'];
    end
end

%---------------------------------------------------------------------
function header = get_header(res)
    if length(size(res))==5
        header=['IDL,IDR,Ss,',...
                'thetadot1exp,theta1th,thetadot1sim,',...
                'thetadot2exp,theta2th,thetadot2sim,',...
                'thetadot1expVAR,thetadot1simVAR,',...
                'thetadot2expVAR,thetadot2simVAR,',...                
                'w1,w2,nl1,nl2,ghdist1,ghdist2'];
    else
        header=['ID,Ss,',...
                'thetadotexp,thetath,thetadotsim,',...                
                'thetadotexpVAR,thetadotsimVAR',...  
                'w,nl,ghdist'];
    end
end

%---------------------------------------------------------------------
function row_data=get_row_data(res)
    row=0;
    if length(size(res))==5
        %Bimanual non averaged data
        [ss,idl,idr,reps,kk]=size(res);
        row_data=zeros([idl*idr*ss*reps,19]);
        for l=1:idl
            for r=1:idr
                for s=1:ss                
                    for rep=1:reps
                        %Create temporal matrices
                        ppar=res{s,l,r,rep,1};
                        pstd=res{s,l,r,rep,2};
                        pmean=res{s,l,r,rep,3};
                        row=row+1;
                    
                        %Trial information
                        row_data(row,1)=l;
                        row_data(row,2)=r;
                        row_data(row,3)=s;      
                        
                        %Theta dot 1 mean
                        row_data(row,4)=pmean(1);
                        row_data(row,5)=sqrt(ppar(1)^2-(2.5*ppar(12))^2);
                        row_data(row,6)=pmean(3);

                        %Theta dot 2 mean
                        row_data(row,7)=pmean(2);
                        row_data(row,8)=sqrt(ppar(2)^2-(2.5*ppar(13))^2);
                        row_data(row,9)=pmean(4);

                        %Theta dot 1 variance
                        row_data(row,10)=pstd(1);
                        row_data(row,11)=pstd(3);

                        %Theta dot 2 variance
                        row_data(row,12)=pstd(2);
                        row_data(row,13)=pstd(4);

                        % w params
                        row_data(row,14)=ppar(1);
                        row_data(row,15)=ppar(2);

                        % NL max params
                        row_data(row,16)=5*ppar(12);
                        row_data(row,17)=5*ppar(13);

                        %Ghost Distance 1
                        if l==1
                            row_data(row,18)=ppar(1)-ppar(12)*3;
                        else
                            row_data(row,18)=ppar(1)-ppar(12)*1.5;
                        end
                        
                        %Ghost Distance 2
                        if r==1
                            row_data(row,19)=ppar(2)-ppar(13)*3;
                        else
                            row_data(row,19)=ppar(2)-ppar(13)*1.5;
                        end
                    end
                end
            end
        end
    else
        %Unimanual non averaged data
        [ss,id,reps,kk]=size(res);
        row_data=zeros([id*ss,9]);
        for i=1:id
            for s=1:ss
                for rep=1:reps
                    %Select matrices
                    ppar=res{s,i,rep,1};
                    pstd=res{s,i,rep,2};
                    pmean=res{s,i,rep,3};
                    row=row+1;
                    
                    %Trail info
                    row_data(row,1)=i;
                    row_data(row,2)=s;
                    
                    %Theta dot mean
                    row_data(row,3)=pmean(1);
                    row_data(row,4)=sqrt(ppar(1)^2-(2.5*ppar(6))^2);
                    row_data(row,5)=pmean(2);
                    
                    %Theta dot variance
                    row_data(row,6)=pstd(1);
                    row_data(row,7)=pstd(2);
  
                    % w params
                    row_data(row,8)=ppar(1);
                    
                    % NL max params
                    row_data(row,9)=5*ppar(6);
                    
                    %Ghost Distance 1
                    if i==1
                        row_data(row,10)=ppar(1)-ppar(6)*3;
                    else
                        row_data(row,10)=ppar(1)-ppar(6)*1.5;
                    end                    
                end
            end
        end
    end   

end


%---------------------------------------------------------------------
function row_data=get_row_data_averaged(res)
    row=0;
    
    
    if length(size(res))==5
        %Bimanual averaged data
        [ss,idl,idr,reps,kk]=size(res);
        row_data=zeros([idl*idr*ss,35]);
        for l=1:idl
            for r=1:idr
                for s=1:ss                
                    pptmp=zeros([16,3]);
                    for rep=1:reps
                        %Create temporal matrices
                        ppar=res{s,l,r,rep,1};
                        pstd=res{s,l,r,rep,2};
                        pmean=res{s,l,r,rep,3};

                        %Theta dot 1 mean
                        pptmp(1,rep)=pmean(1);
                        pptmp(2,rep)=sqrt(ppar(1)^2-(2.5*ppar(12))^2);
                        pptmp(3,rep)=pmean(3);

                        %Theta dot 2 mean
                        pptmp(4,rep)=pmean(2);
                        pptmp(5,rep)=sqrt(ppar(2)^2-(2.5*ppar(13))^2);
                        pptmp(6,rep)=pmean(4);

                        %Theta dot 1 variance
                        pptmp(7,rep)=pstd(1);
                        pptmp(8,rep)=pstd(3);

                        %Theta dot 2 variance
                        pptmp(9,rep)=pstd(2);
                        pptmp(10,rep)=pstd(4);

                        % w params
                        pptmp(11,rep)=ppar(1);
                        pptmp(12,rep)=ppar(2);

                        % NL max params
                        pptmp(13,rep)=5*ppar(12);
                        pptmp(14,rep)=5*ppar(13);

                        %Ghost Distance 1
                        if l==1
                            pptmp(15)=ppar(1)-ppar(12)*3;
                        else
                            pptmp(15)=ppar(1)-ppar(12)*1.5;
                        end
                        
                        %Ghost Distance 2
                        if r==1
                            pptmp(16)=ppar(2)-ppar(13)*3;
                        else
                            pptmp(16)=ppar(2)-ppar(13)*1.5;
                        end
                    end
                    row=row+1;
                    row_data(row,1)=l;
                    row_data(row,2)=r;
                    row_data(row,3)=s;
                    row_data(row,4:2:end)=mean(pptmp,2);
                    row_data(row,5:2:end)=ste(pptmp,2);
                end
            end
        end      
    else
        %Unimanual averaged data      
        [ss,id,reps,kk]=size(res);
        row_data=zeros([id*ss,18]);
        for i=1:id
            for s=1:ss
                pptmp=zeros([8,3]);
                for rep=1:reps
                    %Create temporal matrices
                    ppar=res{s,i,rep,1};
                    pstd=res{s,i,rep,2};
                    pmean=res{s,i,rep,3};
                    
                    %Theta dot mean
                    pptmp(1,rep)=pmean(1);
                    pptmp(2,rep)=sqrt(ppar(1)^2-(2.5*ppar(6))^2);
                    pptmp(3,rep)=pmean(2);
                    
                    %Theta dot variance
                    pptmp(4,rep)=pstd(1);
                    pptmp(5,rep)=pstd(2);
  
                    % w params
                    pptmp(6,rep)=ppar(1);
                    
                    % NL max params
                    pptmp(7,rep)=5*ppar(6);
                    
                    %Ghost Distance 1
                    if i==1
                        pptmp(8)=ppar(1)-ppar(6)*3;
                    else
                        pptmp(8)=ppar(1)-ppar(6)*1.5;
                    end                    
                end
                row=row+1;
                row_data(row,1)=i;
                row_data(row,2)=s;
                row_data(row,3:2:end)=mean(pptmp,2);
                row_data(row,4:2:end)=ste(pptmp,2);
            end
        end
    end   
end

%---------------------------------------------------------------------
function printtable(matrix,header,filepath)
    %Open file
    fd = fopen(filepath, 'w+');
    %Print header
    fprintf(fd, '%s',header);
    fprintf(fd,'\n');
    fclose(fd);
    %Print the real data, much faster this way
    dlmwrite (filepath,matrix,'-append','precision', '%2.2f');
end