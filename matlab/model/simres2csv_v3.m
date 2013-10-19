function simres2csv_v3(res,filepath)
    if nargin < 2, filepath='modeltables_v3.csv'; end


    header=get_header_averaged(res);
    matrix=get_row_data_averaged(res);    
    printtable(matrix,header,filepath)
end

%---------------------------------------------------------------------
function header = get_header_averaged(res)
    if length(size(res))==5
        header=['DID,S,',...
                'thetadot1exp,theta1th,thetadot1sim,',...
                'thetadot2exp,theta2th,thetadot2sim,',...        
                'w1,w2,nl1,nl2,ghdist1,ghdist2'];
    else
        error('This function only supports bimanual conditions')
    end
end

%---------------------------------------------------------------------
function row_data=get_row_data_averaged(res)
    row=0;
    did=3;
    dids={{[1,1]},...        %Symmetric Easy
          {[2,3]},...        %Asymmetric Easy
          {[1,3],[2,1]}};    %Large Asymmetry 
    %Bimanual averaged data
    [ss,idl,idr,reps,kk]=size(res);
    row_data=zeros([did*ss,14]);
    for d=1:did
        tdid=dids{d};
        for s=1:ss
            pptmp=zeros([12,3*length(tdid)]);
            rep=0;
            for i=1:length(tdid)
                for rept=1:reps                
                    rep=rep+1;
                    tdidtmp=num2cell(tdid{i});
                    [l,r]=tdidtmp{:};
                    %Create temporal matrices
                    ppar=res{s,l,r,rept,1};
                    %pstd=res{s,l,r,rep,2};
                    pmean=res{s,l,r,rept,3};


                    %Theta dot 1 mean
                    pptmp(1,rep)=pmean(1);
                    if l==1
                        pptmp(2,rep)=sqrt(ppar(1)^2-(3*ppar(12))^2);
                    else
                        pptmp(2,rep)=sqrt(ppar(1)^2-(1.5*ppar(12))^2);
                    end
                    pptmp(3,rep)=pmean(3);

                    %Theta dot 2 mean
                    pptmp(4,rep)=pmean(2);
                    if r==1
                        pptmp(5,rep)=sqrt(ppar(2)^2-(3*ppar(13))^2);
                    else
                        pptmp(5,rep)=sqrt(ppar(2)^2-(1.5*ppar(13))^2);
                    end
                    pptmp(6,rep)=pmean(4);

                    % w params
                    pptmp(7,rep)=ppar(1);
                    pptmp(8,rep)=ppar(2);

                    % NL max params 1
                    if l==1
                        pptmp(9,rep)=3*ppar(12);
                    else
                        pptmp(9,rep)=1.5*ppar(12);
                    end

                    % NL max params 2
                    if r==1
                        pptmp(10,rep)=3*ppar(13);
                    else
                        pptmp(10,rep)=1.5*ppar(13);
                    end

                    %Ghost Distance 1
                    if l==1
                        pptmp(11,rep)=ppar(1)-ppar(12)*3;
                    else
                        pptmp(11,rep)=ppar(1)-ppar(12)*1.5;
                    end

                    %Ghost Distance 2
                    if r==1
                        pptmp(12,rep)=ppar(2)-ppar(13)*3;
                    else
                        pptmp(12,rep)=ppar(2)-ppar(13)*1.5;
                    end
                end
            end
            row=row+1;
            row_data(row,1)=d;
            row_data(row,2)=s;
            row_data(row,3:end)=mean(pptmp,2);
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