function merge_ID_factors(ds)
    bidata=ds.dataB;
    [vno, hno, pp, ss, idl, idr, reps]=size(bidata);
    llevels=[1,3];
    
    if pp==2
        error('Need participant based data!');
    end
    
    switch ds.DIDmode
        case '3levels'
            ds.dataD=zeros(vno,hno, pp, ss, length(ds.deltaID), reps);            
            for v=1:vno                
                for h=1:hno
                    for p=1:pp
                        for s=1:ss
                            for l=1:idl
                                for r=1:idr
                                    did=abs(r-llevels(l));                                    
                                    i = ds.deltaID==did;
                                    ds.dataD(v,h,p,s,i,:)=squeeze(bidata(v,h,p,s,l,r,:));
                                end
                            end
                        end
                    end
                end
            end                
        case '4levels'
            ds.dataD=zeros(vno,hno,pp, ss, length(ds.deltaID), reps);
            for v=1:vno
                for h=1:hno
                    for p=1:pp
                        for s=1:ss
                            for l=1:idl
                                for r=1:idr
                                    if h==1
                                        i=llevels(l);
                                        j=r;
                                    else
                                        i=r;
                                        j=llevels(l);
                                    end     
                                    did=i-j;
                                    idx=find(ds.deltaID==did);  
                                    if idx
                                        ds.dataD(v,h,p,s,idx,:)=squeeze(bidata(v,h,p,s,l,r,:));
                                    end
                                end
                            end
                        end
                    end
                end
            end           
        case '6levels'
            ds.dataD=zeros(vno,hno, pp, ss, length(ds.deltaID), reps);
            %hand=1 -> Left
            %hand=2 -> Right
            for v=1:vno
                for h=1:hno
                    for p=1:pp
                        for s=1:ss
                            for l=1:idl
                                for r=1:idr
                                    did=r-llevels(l);
                                    if did>0
                                        if h==1
                                            did=4+did;  %Contra Large = 6
                                                        %Contra Small = 5
                                        else
                                            did=3-did;  %Ipsi Large   = 1
                                                        %Ipsi Small   = 2
                                        end
                                    elseif did<0
                                        if h==2
                                            did=4-did;  %Contra Large = 6
                                                        %Contra Small = 5
                                        else
                                            did=3+did;  %Ipsi Large   = 1
                                                        %Ipsi Small   = 2
                                        end                                        
                                    elseif did==0 
                                        if l==1         %Easy Both    = 4
                                            did=4;
                                        else            %Diff Both    = 3
                                            did=3;
                                        end
                                    else
                                        error('Impossible!!!')
                                    end
                                    i= ds.deltaID==did;                                    
                                    ds.dataD(v,h,p,s,i,:)=squeeze(bidata(v,h,p,s,l,r,:));
                                end
                            end
                        end
                    end
                end
            end  
        case '6levels2'
            ds.dataD=zeros(vno, hno, pp, ss, length(ds.deltaID), reps*hno);
            %hand=1 -> Left
            %hand=2 -> Right
            for v=1:vno
                isls=0;
                if strcmp(ds.vtypesB{v},'ls')
                    isls=1;
                end                
                for h=1:hno
                    for p=1:pp
                        for s=1:ss
                            for l=1:idl
                                for r=1:idr
                                    did=r-llevels(l);
                                    if did>0
                                        if h==1
                                            did=4+did;  %Contra Large = 6
                                                        %Contra Small = 5
                                        else
                                            did=3-did;  %Ipsi Large   = 1
                                                        %Ipsi Small   = 2
                                        end
                                    elseif did<0
                                        if h==2
                                            did=4-did;  %Contra Large = 6
                                                        %Contra Small = 5
                                        else
                                            did=3+did;  %Ipsi Large   = 1
                                                        %Ipsi Small   = 2
                                        end                                        
                                    elseif did==0 
                                        if l==1         %Easy Both    = 4
                                            did=4;
                                        else            %Diff Both    = 3
                                            did=3;
                                        end
                                    else
                                        error('Impossible!!!')
                                    end
                                    i= ds.deltaID==did;
                                    for rep=1:reps
                                        if isls
                                            ds.dataD(v,1,p,s,i,rep+(h-1)*reps)=bidata(v,1,p,s,l,r,rep);
                                            ds.dataD(v,2,p,s,i,rep+(h-1)*reps)=bidata(v,1,p,s,l,r,rep);
                                        else
                                            ds.dataD(v,1,p,s,i,rep+(h-1)*reps)=bidata(v,h,p,s,l,r,rep);
                                            ds.dataD(v,2,p,s,i,rep+(h-1)*reps)=bidata(v,h,p,s,l,r,rep);
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end            
        case '6levelsold'
            ds.dataD=zeros(vno,hno, pp, ss, length(ds.deltaID), reps);
            for v=1:vno
                for h=1:hno
                    for p=1:pp
                        for s=1:ss
                            for l=1:idl
                                for r=1:idr
                                    did=r-llevels(l);
                                    if did==0 && r==3
                                        did=3;
                                    end
                                    i= ds.deltaID==did;                                    
                                    ds.dataD(v,h,p,s,i,:)=squeeze(bidata(v,h,p,s,l,r,:));
                                end
                            end
                        end
                    end
                end
            end            
        case 'subsample'
            ds.dataD=zeros(vno,hno, pp, ss, length(ds.deltaID), reps);
            for v=1:vno
                for h=1:hno
                    for p=1:pp
                        for s=1:ss
                            flag=0;
                            for l=1:idl
                                for r=1:idr
                                    did=r-llevels(l);
                                    i=find(ds.deltaID==did);
                                    if i==0 && flag==0
                                        flag=1; %Whe are on first round 
                                        %Select 3 different trials out of 6
                                        sel_idx=randi([1,6],1,3);
                                        while length(unique(sel_idx))<3
                                            sel_idx=randi([1,6],1,3);
                                        end
                                        %Now save in data those smaller
                                        %than 4 (present in the first round)
                                        sel=sel_idx(sel_idx<4);
                                        for idx=1:length(sel)
                                            ds.dataD(v,h,p,s,i,idx)=bidata(v,h,p,s,l,r,sel(idx));
                                        end
                                    elseif i==0 && flag==1
                                        %We are on second round
                                        %Save in data those bigger than 3                                         
                                        sel=sel_idx(sel_idx>3)-3;
                                        offset=3-lenght(sel);                                        
                                        for idx=1:length(sel)
                                            ds.dataD(v,h,p,s,i,offset+idx)=bidata(v,h,p,s,l,r,sel(idx));
                                        end
                                    else
                                        %For all the other, just save 3 reps
                                        ds.dataD(v,h,p,s,i,:)=squeeze(bidata(v,h,p,s,l,r,:));
                                    end
                                end
                            end
                        end
                    end
                end
            end
        case 'average'
            ds.dataD=zeros(vno,hno, pp, ss, length(ds.deltaID));
            for v=1:vno
                for h=1:hno
                    for p=1:pp
                        for s=1:ss
                            for l=1:idl
                                for r=1:idr
                                    did=r-llevels(l);
                                    i=find(ds.deltaID==did);
                                    if i==0, continue; end % we deal with it later
                                    ds.dataD(v,h,p,s,i)=mean(bidata(v,h,p,s,l,r,:));
                                end
                            end
                            ds.dataD(v,h,p,s,3)=mean(cat(2,squeeze(bidata(v,h,p,s,1,1,:))',...
                                                       squeeze(bidata(v,h,p,s,2,3,:))'));
                        end
                    end
                end
            end
        case 'all'
            ds.dataD=zeros(vno,hno, pp, ss, length(ds.deltaID), reps*2)*NaN;
            for v=1:vno
                for h=1:hno
                    for p=1:pp
                        for s=1:ss
                            flag=0;
                            for l=1:idl
                                for r=1:idr
                                    did=r-llevels(l);
                                    i=find(ds.deltaID==did);
                                    if i==0 
                                        if flag==0
                                            flag=1; %Whe are on first round 
                                            ds.dataD(v,h,p,s,i,1:3)=squeeze(bidata(v,h,p,s,l,r,:));
                                        else
                                            ds.dataD(v,h,p,s,i,4:6)=squeeze(bidata(v,h,p,s,l,r,:));
                                        end
                                    else
                                        ds.dataD(v,h,p,s,i,1:3)=squeeze(bidata(v,h,p,s,l,r,:));
                                    end
                                end
                            end
                        end
                    end
                end
            end
    end
end