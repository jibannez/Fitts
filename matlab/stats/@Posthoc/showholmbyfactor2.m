function showholmbyfactor2(phoc,rno)
    res=phoc.results{rno};
    holmmat=res.Holmmat;
    data=res.data;
    factors=res.factors;
    
    flen=size(data);
    reps=flen(end);

    disp(repmat('=',1,60))
    switch length(factors)
        case 1
            disp('Not necessary to do a cross level analysis');
            f1mat=[];
            f2mat=[];
        case 2
            if flen(2)==2
                f1mat=zeros(flen(1),1);                
            elseif flen(2)==2
                f1mat=zeros(flen(1),3);
            else
                f1mat=zeros(flen(1),15);
            end
            if flen(1)==2
                f2mat=zeros(flen(2),1);                
            elseif flen(1)==2
                f2mat=zeros(flen(2),3);
            else
                f1mat=zeros(flen(2),15);    
            end
            
            fprintf('Crosslevel interactions for factors %s vs %s\n',factors{1},factors{2})
            
            for f1=1:flen(1)
                if flen(2)==2
                    f1mat(f1,1)=get_holm(holmmat,[f1,1],[f1,2],flen(1:end-1));
                    fprintf('1-2=%d\n',f1mat(f1,1)) 
                elseif flen(2)==3
                    f1mat(f1,1)=get_holm(holmmat,[f1,1],[f1,2],flen(1:end-1));
                    f1mat(f1,2)=get_holm(holmmat,[f1,2],[f1,3],flen(1:end-1));
                    f1mat(f1,3)=get_holm(holmmat,[f1,1],[f1,3],flen(1:end-1));
                    fprintf('1-2=%d 2-3=%d 1-3=%d\n',f1mat(f1,1),f1mat(f1,2),f1mat(f1,3))
                else
                    f1mat(f1,1) =get_holm(holmmat,[f1,1],[f1,2],flen(1:end-1));
                    f1mat(f1,2) =get_holm(holmmat,[f1,1],[f1,3],flen(1:end-1));
                    f1mat(f1,3) =get_holm(holmmat,[f1,1],[f1,4],flen(1:end-1));
                    f1mat(f1,4) =get_holm(holmmat,[f1,1],[f1,5],flen(1:end-1));
                    f1mat(f1,5) =get_holm(holmmat,[f1,1],[f1,6],flen(1:end-1));
                    f1mat(f1,6) =get_holm(holmmat,[f1,2],[f1,3],flen(1:end-1));
                    f1mat(f1,7) =get_holm(holmmat,[f1,2],[f1,4],flen(1:end-1));
                    f1mat(f1,8) =get_holm(holmmat,[f1,2],[f1,5],flen(1:end-1));
                    f1mat(f1,9) =get_holm(holmmat,[f1,2],[f1,6],flen(1:end-1));
                    f1mat(f1,10)=get_holm(holmmat,[f1,3],[f1,4],flen(1:end-1));
                    f1mat(f1,11)=get_holm(holmmat,[f1,3],[f1,5],flen(1:end-1));
                    f1mat(f1,12)=get_holm(holmmat,[f1,3],[f1,6],flen(1:end-1));
                    f1mat(f1,13)=get_holm(holmmat,[f1,4],[f1,5],flen(1:end-1));   
                    f1mat(f1,14)=get_holm(holmmat,[f1,4],[f1,6],flen(1:end-1));
                    f1mat(f1,15)=get_holm(holmmat,[f1,5],[f1,6],flen(1:end-1));
                    fprintf('1-2=%d 1-3=%d 1-4=%d 1-5=%d 1-6=%d\n',f1mat(f1,1),f1mat(f1,2),f1mat(f1,3),f1mat(f1,4),f1mat(f1,5))
                    fprintf('2-3=%d 2-4=%d 2-5=%d 2-6=%d \n',f1mat(f1,6),f1mat(f1,7),f1mat(f1,8),f1mat(f1,9))
                    fprintf('3-4=%d 3-5=%d 3-6=%d \n',f1mat(f1,10),f1mat(f1,11),f1mat(f1,12))
                    fprintf('4-5=%d 4-6=%d \n',f1mat(f1,13),f1mat(f1,14))
                    fprintf('5-6=%d\n',f1mat(f1,15))
                    fprintf('---\n')                    
                end
            end
            
            fprintf('Crosslevel interactions for factors %s vs %s\n',factors{2},factors{1})
            for f2=1:flen(2)
                if flen(1)==2
                    f2mat(f2,1)=get_holm(holmmat,[1,f2],[2,f2],flen(1:end-1));
                    fprintf('1-2=%d\n',f2mat(f2,1))
                elseif flen(1)==3
                    f2mat(f2,1)=get_holm(holmmat,[1,f2],[2,f2],flen(1:end-1));
                    f2mat(f2,2)=get_holm(holmmat,[2,f2],[3,f2],flen(1:end-1));
                    f2mat(f2,3)=get_holm(holmmat,[1,f2],[3,f2],flen(1:end-1));
                    fprintf('1-2=%d 2-3=%d 1-3=%d\n',f2mat(f2,1),f2mat(f2,2),f2mat(f2,3))
                else
                    f2mat(f2,1) =get_holm(holmmat,[1,f2],[2,f2],flen(1:end-1));
                    f2mat(f2,2) =get_holm(holmmat,[1,f2],[3,f2],flen(1:end-1));
                    f2mat(f2,3) =get_holm(holmmat,[1,f2],[4,f2],flen(1:end-1));
                    f2mat(f2,4) =get_holm(holmmat,[1,f2],[5,f2],flen(1:end-1));
                    f2mat(f2,5) =get_holm(holmmat,[1,f2],[6,f2],flen(1:end-1));
                    f2mat(f2,6) =get_holm(holmmat,[2,f2],[3,f2],flen(1:end-1));
                    f2mat(f2,7) =get_holm(holmmat,[2,f2],[4,f2],flen(1:end-1));
                    f2mat(f2,8) =get_holm(holmmat,[2,f2],[5,f2],flen(1:end-1));
                    f2mat(f2,9) =get_holm(holmmat,[2,f2],[6,f2],flen(1:end-1));
                    f2mat(f2,10)=get_holm(holmmat,[3,f2],[4,f2],flen(1:end-1));
                    f2mat(f2,11)=get_holm(holmmat,[3,f2],[5,f2],flen(1:end-1));
                    f2mat(f2,12)=get_holm(holmmat,[3,f2],[6,f2],flen(1:end-1));
                    f2mat(f2,13)=get_holm(holmmat,[4,f2],[5,f2],flen(1:end-1));   
                    f2mat(f2,14)=get_holm(holmmat,[4,f2],[6,f2],flen(1:end-1));
                    f2mat(f2,15)=get_holm(holmmat,[5,f2],[6,f2],flen(1:end-1));
                    fprintf('1-2=%d 1-3=%d 1-4=%d 1-5=%d 1-6=%d\n',f2mat(f2,1),f2mat(f2,2),f2mat(f2,3),f2mat(f2,4),f2mat(f2,5))
                    fprintf('2-3=%d 2-4=%d 2-5=%d 2-6=%d \n',f2mat(f2,6),f2mat(f2,7),f2mat(f2,8),f2mat(f2,9))
                    fprintf('3-4=%d 3-5=%d 3-6=%d \n',f2mat(f2,10),f2mat(f2,11),f2mat(f2,12))
                    fprintf('4-5=%d 4-6=%d \n',f2mat(f2,13),f2mat(f2,14))
                    fprintf('5-6=%d\n',f2mat(f2,15))
                    fprintf('---\n')
                end
            end
            
            
        case 3
            if flen(3)==2
                f1mat=zeros(flen(1),flen(2),1);                
            elseif flen(3)==2
                f1mat=zeros(flen(1),flen(2),3);
            else
                f1mat=zeros(flen(1),flen(2),15);
            end
            
            if flen(2)==2
                f2mat=zeros(flen(1),flen(3),1);                
            elseif flen(2)==3
                f2mat=zeros(flen(1),flen(3),3);
            else
                f2mat=zeros(flen(1),flen(3),15);
            end
            

            for g1=1:flen(1)
                fprintf('Crosslevel interactions for factors %s vs %s with factor %s = %d\n',factors{2},factors{3},factors{1},g1)
                for f1=1:flen(2)
                    if flen(3)==2
                        f1mat(g1,f1,1)=get_holm(holmmat,[g1,f1,1],[g1,f1,2],flen(1:end-1));
                        fprintf('1-2=%d\n',f1mat(g1,f1,1))                        
                    elseif flen(3)==3
                        f1mat(g1,f1,1)=get_holm(holmmat,[g1,f1,1],[g1,f1,2],flen(1:end-1));
                        f1mat(g1,f1,2)=get_holm(holmmat,[g1,f1,2],[g1,f1,3],flen(1:end-1));
                        f1mat(g1,f1,3)=get_holm(holmmat,[g1,f1,1],[g1,f1,3],flen(1:end-1));
                        fprintf('1-2=%d 2-3=%d 1-3=%d\n',f1mat(g1,f1,1),f1mat(g1,f1,2),f1mat(g1,f1,3))
                    else
                        f1mat(g1,f1,1) =get_holm(holmmat,[g1,f1,1],[g1,f1,2],flen(1:end-1));
                        f1mat(g1,f1,2) =get_holm(holmmat,[g1,f1,1],[g1,f1,3],flen(1:end-1));
                        f1mat(g1,f1,3) =get_holm(holmmat,[g1,f1,1],[g1,f1,4],flen(1:end-1));
                        f1mat(g1,f1,4) =get_holm(holmmat,[g1,f1,1],[g1,f1,5],flen(1:end-1));
                        f1mat(g1,f1,5) =get_holm(holmmat,[g1,f1,1],[g1,f1,6],flen(1:end-1));
                        f1mat(g1,f1,6) =get_holm(holmmat,[g1,f1,2],[g1,f1,3],flen(1:end-1));
                        f1mat(g1,f1,7) =get_holm(holmmat,[g1,f1,2],[g1,f1,4],flen(1:end-1));
                        f1mat(g1,f1,8)=get_holm(holmmat,[g1,f1,2],[g1,f1,5],flen(1:end-1));
                        f1mat(g1,f1,9)=get_holm(holmmat,[g1,f1,2],[g1,f1,6],flen(1:end-1));
                        f1mat(g1,f1,10)=get_holm(holmmat,[g1,f1,3],[g1,f1,4],flen(1:end-1));
                        f1mat(g1,f1,11)=get_holm(holmmat,[g1,f1,3],[g1,f1,5],flen(1:end-1));
                        f1mat(g1,f1,12)=get_holm(holmmat,[g1,f1,3],[g1,f1,6],flen(1:end-1));
                        f1mat(g1,f1,13)=get_holm(holmmat,[g1,f1,4],[g1,f1,5],flen(1:end-1));   
                        f1mat(g1,f1,14)=get_holm(holmmat,[g1,f1,4],[g1,f1,6],flen(1:end-1));
                        f1mat(g1,f1,15)=get_holm(holmmat,[g1,f1,5],[g1,f1,6],flen(1:end-1));
                        fprintf('1-2=%d 1-3=%d 1-4=%d 1-5=%d 1-6=%d\n',f1mat(g1,f1,1),f1mat(g1,f1,2),f1mat(g1,f1,3),f1mat(g1,f1,4),f1mat(g1,f1,5))
                        fprintf('2-3=%d 2-4=%d 2-5=%d 2-6=%d \n',f1mat(g1,f1,6),f1mat(g1,f1,7),f1mat(g1,f1,8),f1mat(g1,f1,9))
                        fprintf('3-4=%d 3-5=%d 3-6=%d \n',f1mat(g1,f1,10),f1mat(g1,f1,11),f1mat(g1,f1,12))
                        fprintf('4-5=%d 4-6=%d \n',f1mat(g1,f1,13),f1mat(g1,f1,14))
                        fprintf('5-6=%d\n',f1mat(g1,f1,15))
                        fprintf('---\n')    
                    end
                end
                fprintf('Crosslevel interactions for factors %s vs %s with factor %s = %d\n',factors{3},factors{2},factors{1},g1)
                for f2=1:flen(3)
                    if flen(2)==2
                        f2mat(g1,f2,1)=get_holm(holmmat,[g1,1,f2],[g1,2,f2],flen(1:end-1));
                        fprintf('1-2=%d\n',f2mat(g1,f2,1))
                    elseif flen(2)==3
                        f2mat(g1,f2,1)=get_holm(holmmat,[g1,1,f2],[g1,2,f2],flen(1:end-1));
                        f2mat(g1,f2,2)=get_holm(holmmat,[g1,2,f2],[g1,3,f2],flen(1:end-1));
                        f2mat(g1,f2,3)=get_holm(holmmat,[g1,1,f2],[g1,3,f2],flen(1:end-1));
                        fprintf('1-2=%d 2-3=%d 1-3=%d\n',f2mat(g1,f2,1),f2mat(g1,f2,2),f2mat(g1,f2,3))
                    else
                        f2mat(g1,f2,1) =get_holm(holmmat,[g1,1,f2],[g1,2,f2],flen(1:end-1));
                        f2mat(g1,f2,2) =get_holm(holmmat,[g1,1,f2],[g1,3,f2],flen(1:end-1));
                        f2mat(g1,f2,3) =get_holm(holmmat,[g1,1,f2],[g1,4,f2],flen(1:end-1));
                        f2mat(g1,f2,4) =get_holm(holmmat,[g1,1,f2],[g1,5,f2],flen(1:end-1));
                        f2mat(g1,f2,5) =get_holm(holmmat,[g1,1,f2],[g1,6,f2],flen(1:end-1));
                        f2mat(g1,f2,6) =get_holm(holmmat,[g1,2,f2],[g1,3,f2],flen(1:end-1));
                        f2mat(g1,f2,7) =get_holm(holmmat,[g1,2,f2],[g1,4,f2],flen(1:end-1));
                        f2mat(g1,f2,8)=get_holm(holmmat,[g1,2,f2],[g1,5,f2],flen(1:end-1));
                        f2mat(g1,f2,9)=get_holm(holmmat,[g1,2,f2],[g1,6,f2],flen(1:end-1));
                        f2mat(g1,f2,10)=get_holm(holmmat,[g1,3,f2],[g1,4,f2],flen(1:end-1));
                        f2mat(g1,f2,11)=get_holm(holmmat,[g1,3,f2],[g1,5,f2],flen(1:end-1));
                        f2mat(g1,f2,12)=get_holm(holmmat,[g1,3,f2],[g1,6,f2],flen(1:end-1));
                        f2mat(g1,f2,13)=get_holm(holmmat,[g1,4,f2],[g1,5,f2],flen(1:end-1));   
                        f2mat(g1,f2,14)=get_holm(holmmat,[g1,4,f2],[g1,6,f2],flen(1:end-1));
                        f2mat(g1,f2,15)=get_holm(holmmat,[g1,5,f2],[g1,6,f2],flen(1:end-1));
                        fprintf('1-2=%d 1-3=%d 1-4=%d 1-5=%d 1-6=%d\n',f2mat(g1,f2,1),f2mat(g1,f2,2),f2mat(g1,f2,3),f2mat(g1,f2,4),f2mat(g1,f2,5))
                        fprintf('2-3=%d 2-4=%d 2-5=%d 2-6=%d \n',f2mat(g1,f2,6),f2mat(g1,f2,7),f2mat(g1,f2,8),f2mat(g1,f2,9))
                        fprintf('3-4=%d 3-5=%d 3-6=%d \n',f2mat(g1,f2,10),f2mat(g1,f2,11),f2mat(g1,f2,12))
                        fprintf('4-5=%d 4-6=%d \n',f2mat(g1,f2,13),f2mat(g1,f2,14))
                        fprintf('5-6=%d\n',f2mat(g1,f2,15))
                        fprintf('---\n')    
                    end
                end
            end
            
        case 4
            if flen(4)==2
                f1mat=zeros(flen(1),flen(2),flen(3),1);                
            else
                f1mat=zeros(flen(1),flen(2),flen(3),3);
            end
            
            if flen(3)==2
                f2mat=zeros(flen(1),flen(2),flen(4),1);              
            else
                f2mat=zeros(flen(1),flen(2),flen(4),3);
            end
            
            for g1=1:flen(1)
                for g2=1:flen(2)
                    fprintf('Crosslevel interactions for factors %s vs %s with factor %s = %d and factor %s = %d\n',factors{3},factors{4},factors{1},g1,factors{2},g2)
                    for f1=1:flen(3)
                        if flen(4)==2
                            f1mat(g1,g2,f1,1)=get_holm(holmmat,[g1,g2,f1,1],[g1,g2,f1,2],flen(1:end-1));
                            fprintf('1-2=%d\n',f1mat(g1,g2,f1,1))
                        else
                            f1mat(g1,g2,f1,1)=get_holm(holmmat,[g1,g2,f1,1],[g1,g2,f1,2],flen(1:end-1));
                            f1mat(g1,g2,f1,2)=get_holm(holmmat,[g1,g2,f1,2],[g1,g2,f1,3],flen(1:end-1));
                            f1mat(g1,g2,f1,3)=get_holm(holmmat,[g1,g2,f1,1],[g1,g2,f1,3],flen(1:end-1));
                            fprintf('1-2=%d 2-3=%d 1-3=%d\n',f1mat(g1,g2,f1,1),f1mat(g1,g2,f1,2),f1mat(g1,g2,f1,3))
                        end
                    end
                    fprintf('Crosslevel interactions for factors %s vs %s with factor %s = %d and factor %s = %d\n',factors{4},factors{3},factors{1},g1,factors{2},g2)
                    for f2=1:flen(4)
                        if flen(3)==2
                            f2mat(g1,g2,f2,1)=get_holm(holmmat,[g1,g2,1,f2],[g1,g2,2,f2],flen(1:end-1));
                            fprintf('1-2=%d\n',f2mat(g1,g2,f2,1))
                        else
                            f2mat(g1,g2,f2,1)=get_holm(holmmat,[g1,g2,1,f2],[g1,g2,2,f2],flen(1:end-1));
                            f2mat(g1,g2,f2,2)=get_holm(holmmat,[g1,g2,2,f2],[g1,g2,3,f2],flen(1:end-1));
                            f2mat(g1,g2,f2,3)=get_holm(holmmat,[g1,g2,1,f2],[g1,g2,3,f2],flen(1:end-1));
                            fprintf('1-2=%d 2-3=%d 1-3=%d\n',f2mat(g1,g2,f2,1),f2mat(g1,g2,f2,2),f2mat(g1,g2,f2,3))
                        end
                    end
                end
            end
            
    end
    disp(repmat('=',1,60))
end
function hval = get_holm(holmmat,p1,p2,flen)
   switch length(flen)
       case 2
            c1=(p1(1)-1)*flen(2)+p1(2);
            c2=(p2(1)-1)*flen(2)+p2(2);
        
       case 3
            c1=(p1(1)-1)*flen(2)*flen(3)+(p1(2)-1)*flen(3)+p1(3);
            c2=(p2(1)-1)*flen(2)*flen(3)+(p2(2)-1)*flen(3)+p2(3);
       case 4
            c1=(p1(1)-1)*flen(2)*flen(3)*flen(4)+(p1(2)-1)*flen(3)*flen(4)+(p1(3)-1)*flen(4)+p1(4);
            c2=(p2(1)-1)*flen(2)*flen(3)*flen(4)+(p2(2)-1)*flen(3)*flen(4)+(p2(3)-1)*flen(4)+p2(4);
   end
   hval=holmmat(c1,c2);
end