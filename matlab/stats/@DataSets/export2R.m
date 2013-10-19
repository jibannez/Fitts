function export2R(ds,filename,savepath)
    if nargin<2, filename='fitts.dat';end
    if nargin<3, savepath=ds.savepathR;end


    %Fetch and export Bimanual header and matrix
    [header,vnames2]=build_headers({'grp' 'pp' 'S' 'IDL' 'IDR'},ds.vnamesB,ds.vtypesB,ds.excludeVars);
    out = get_rowdata(ds.dataB,ds.vtypesB,ds.vnamesB,vnames2,header,ds.pp_by_groups);  
    export_matrix(out,header,joinpath(savepath,['Bi_' filename]));
    
    %Fetch and export Bimanual Delta ID header and matrix
    [header,vnames2]=build_headers({'grp' 'pp' 'S' 'DID'},ds.varsDID,ds.vtypesB,ds.excludeVars);
    out = get_rowdata(ds.dataD,ds.vtypesB,ds.vnamesB,vnames2,header,ds.pp_by_groups);  
    export_matrix(out,header,joinpath(savepath,['BiDelta_' filename]));
    
    %Fetch and export Unimanual header and matrix
    [header,vnames2]=build_headers({'grp' 'pp' 'S' 'ID'},ds.vnamesU,ds.vtypesU,ds.excludeVars);
    out = get_rowdata(ds.dataL,ds.vtypesU,ds.vnamesU,vnames2,header,ds.pp_by_groups);
    export_matrix(out,header,joinpath(savepath,['UniL_' filename]));
    out = get_rowdata(ds.dataR,ds.vtypesU,ds.vnamesU,vnames2,header,ds.pp_by_groups);
    export_matrix(out,header,joinpath(savepath,['UniR_' filename]));
    
    %Create source file with Rname
    rfilepath=joinpath(ds.Rpath,'get_Rname.R');
    fd = fopen(rfilepath, 'w+');
    fprintf(fd,'Rname="%s"\n',ds.conf.branch_path);
    fclose(fd);
end

function export_matrix(matrix,header,filepath)
    %Open file
    fd = fopen(filepath, 'w+');
    %Print header
    fprintf(fd, '%s,',header{:});
    fseek(fd, -1, 0);
    fprintf(fd,'\n');
    fclose(fd);
    %Print the real data, much faster this way
    dlmwrite (filepath,matrix,'-append');
end

function out = get_rowdata(data,vartypes,varnames1,varnames2,header,pp_by_groups)    
    %Build output data frames
    grp=size(pp_by_groups,1);
    bimanual=0;
    did=0;
    idl=0;
    if length(size(data))==7
        [vno,h,pp,ss,idl,idr,reps]=size(data);
        out =zeros(grp*ss*idl*idr*reps,length(header));
        bimanual=1;
    elseif length(size(data))==6
        [vno,h,pp,ss,id,reps]=size(data);
        out =zeros(grp*ss*id*reps,length(header));
        bimanual=0;
        did=1;
    else 
        [vno,pp,ss,id,reps]=size(data);
        out =zeros(grp*ss*id*reps,length(header)); 
    end
    
    %Iterate!!
    idx=0;
    for g=1:grp
        for p=pp_by_groups(g,:)
            for s=1:ss
                %Unimanual and ID diff blocks
                if ~idl && bimanual==0
                    for i=1:id
                       for rep=1:reps
                            idx=idx+1;
                            %Fetch bimanual data
                            row=[g,p,s,i];
                            for v=1:length(varnames2)
%                                 header
%                                 v                                
%                                 varnames2{v}
%                                 varnames1
                                v2=strmatch(varnames2{v},varnames1,'exact');
                                %ID diff blocks
                                if did
                                    %'did'
                                    row=[row,squeeze(data(v2,1,p,s,i,rep))];
                                %Unimanual blocks
                                else
                                    %'un'
                                   row=[row,squeeze(data(v2,p,s,i,rep))];
                                end
                            end
%                             size(row)
%                             size(out(idx,:))                        
                            out(idx,:)=row;
                       end
                    end
                %Bimanual blocks
                else
                    for l=1:idl
                        for r=1:idr
                            for rep=1:reps
                                idx=idx+1;
                                %Fetch bimanual data
                                row=[g,p,s,l,r];
                                for v=1:length(varnames2)
                                    v2=strmatch(varnames2{v},varnames1,'exact');
                                    if strcmp(vartypes{v2},'ls')
                                        %only one meaningful data per variable
                                        row=[row,data(v2,1,p,s,l,r,rep)];
                                    else
                                        %Each hand has a value per variable
                                        row=[row,squeeze(data(v2,:,p,s,l,r,rep))];
                                    end
                                end                                
                                out(idx,:)=row(:);
                            end
                        end
                    end
                end
            end
        end
    end
    out=remove_NaNs(out);
end

function [header,varnames2]=build_headers(factors,varnames,vartypes,excludeVars)
    header=factors;
    isdid=0;
    if any(strcmp('DID',factors))
        isdid=1;
    end
    varnames2 = varnames(~ismember(varnames,excludeVars));
    for v=1:length(varnames2)        
        v2=strmatch(varnames2{v},varnames,'exact');
        if isdid
            header{end+1}=varnames{v2};
        elseif strcmp(vartypes{v2},'ls')
            %only one meaningful data per variable
            header{end+1}=varnames{v2};
        elseif any(strcmp('IDL',factors)) || any(strcmp('DID',factors))
            %Each hand has a value per variable
            header{end+1}=[varnames{v2} 'L'];
            header{end+1}=[varnames{v2} 'R'];            
        else
            header{end+1}=varnames{v2};
        end
    end
end


        
