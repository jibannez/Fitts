classdef DataSets < handle
    
    properties
        %All data types and names
        vnamesB={}
        vtypesB={}
        vnamesU={}
        vtypesU={}

        %Data matrices
        dataU
        dataB
        dataL
        dataR
        dataRel
        dataD    
        deltaID
        
        %Posthoc variables
        posthoc=containers.Map()
        flists={}
        fvnames
        dorel=0

        %Participant based data
        ppdata=DataSets.empty(10,0)
        savepath
        savepathR
        Rpath
        Pythonpath
    end 

    properties (Hidden=true)
        %Global variables representing the structure the experiment        
        conf=Config()
        name
        vtypes={'osc','vf','ls'}
        C=[2,3,6,8,9]
        U=[1,4,5,7,10]        
        DIDmode='3levels'
        excludeVars={'MTOwn','MTOther','IDOwn','IDOther','IDOwnEf','IDOtherEf'}
        pp_by_groups=[[2,3,6,8,9];[1,4,5,7,10]]
        vnoB
        vnoU
        hands=2
        hno=2
        idl=2
        idr=3
        ss=3
        rep=3
        grps=10
        analvars={'MTL','MTR','accQL','accQR','IPerfEfR','IPerfEfL',...
                  'HarmonicityL','HarmonicityR','vfCircularityR','vfCircularityL','maxangleL','maxangleR',...
                  'rho','flsPC','phDiffStd','minPeakDelay','DID_rho','DID_flsPC','DID_phDiffStd','DID_minPeakDelay'}

        %Plot globals
        cnames={'Strong','Weak'}
        lnames={'Easy','Difficult'}
        rnames={'Easy','Medium','Difficult'}
        snames={'S1','S2','S3'}
        dnames={'Zero','Small','Large'}
        vnames={'MTL','MTR','accQL','accQR','HarmonicityL','HarmonicityR',...
                'IPerfEfL','IPerfEfR','vfCircularityL','vfCircularityR',...
                'maxangleL','maxangleR','rho','flsPC','phDiffStd',...
                'minPeakDelay','minPeakDelayNorm'}
        vstrns={'MT_L','MT_R','AQ_L','AQ_R','H_L','H_R','IPE_L','IPE_R',...
                'VFC_L','VFC_R','MA_L','MA_R','\rho','FLS',...
                '\phi_{\sigma}','dpeaks','dpeaks_{norm}'}
        
        %Define or fetch some globals PLOT_GROUPS            
        vstrs={'MT','AT','DT','AQ','IPE',...
              'MA','d3D','d4D','Circularity',...
              'VFC','VFT','H',...
              '\rho','FLS','\phi_{\sigma}','MI','dpeaks','dpeaks_{norm}'};
        units={' (s)',' (s)',' (s)','',' (bits/s)',...
              '(rad)','','','',...
              '','','',...
              '','','','','(s)','dpeaks_{norm} (s²)'};      
        titles={'Movement Time','Acceleration Time','Deceleration Time','Acceleration Ratio','Effective Index of Performace',...
                'Maximal Angle','3D Distance','4D Distance','Circularity',...
                'Vector Field Circularity','Vector Field Trajectory Circularity','Harmonicity',...
                '\rho','flsPC','\phi_{\sigma}','Mutual Information','Minimal Peak Delay','Minimal Peak Delay Normalized'};     
        
        varsGDID={'rho','flsPC','phDiffStd','MI','minPeakDelay','minPeakDelayNorm','D3D','D4D'};
        
        titlesDID={'rho','flsPC','phDiffStd','MI','minPeakDelay','minPeakDelayNorm','D3D','D4D'};                  
        
        ext='png'
        dpi=300
        verbose=1
        fid=1
        order=1
        do_legend=0
        do_anotations=0
        do_title=0
        do_ylabel=1
        plot_type='subplot'; %'tight' 'figure' 'subplot'       
        figsize=[0,0,2400,1800];

        %Flags controlling 
        fetch_grouped_data=0
        fetch_raw_data=0 %Not sure it works...
        fetch_relative_data=1        
    end
    
    
    methods
        %%%%%%%%%%%%%
        % Constructor
        %%%%%%%%%%%%%
        function ds = DataSets(arg)
            %Three type of possible initializations:
            %  1- passing Experiment object. Requieres too much memory.
            %  2- passing string with path to:
            %     2.1-Single Partipant DataStats saved mat file (*)
            %     2.2-Directory containing all participant DataStats
            %  3- passing a Participant object
            %  4- passing an integer indicating dataset or participant name
            if nargin<1, arg=joinpath(ds.conf.save_path,'ds'); end
            if ds.fetch_grouped_data, ds.grps=2; else ds.grps=10; end
            if ds.fetch_raw_data, error('Not implemented'); end   
            
            if strcmp(ds.DIDmode,'3levels')
                ds.deltaID=[0,1,2];
            elseif strcmp(ds.DIDmode,'6levels')
                ds.deltaID=-2:2;
            elseif strcmp(ds.DIDmode,'4levels')
                ds.deltaID=[-2,-1,1,2];
            end
            
            %Get essential variables and paths
            ds.get_ANOVA_variables();
            ds.name=ds.conf.name;
            ds.savepath=joinpath(ds.conf.save_path,'ds');
            ds.Rpath=joinpath(joinpath(joinpath(joinpath(getuserdir(),'Dropbox'),'dev'),'Bimanual-Fitts'),'R');
            ds.Pythonpath=joinpath(joinpath(joinpath(joinpath(getuserdir(),'Dropbox'),'dev'),'Bimanual-Fitts'),'python');
            ds.savepathR=joinpath(joinpath(ds.Rpath,'dataframes'),ds.conf.branch_path);
            if ~exist(ds.savepath,'dir'),mkdir(ds.savepath); end            
            if ~exist(ds.savepathR,'dir'),mkdir(ds.savepathR); end
            
            ds=ds.get_data(arg);
        end
        
        function ds = get_data(ds,arg)
            if nargin<2, arg=ds.conf.save_path; end
            
            if isa(arg,'Experiment')
                ds.get_all_data_averaged(arg);
                ds.get_all_data_rel();
                ds.merge_ID_factors();
            elseif ischar(arg)
                if exist(arg,'dir')
                    %load and merge all participant data from directory.
                    ds.merge_pp_dir(arg);
                elseif exist(arg,'file')
                    %load and merge participant data.
                    obj = load(arg);
                    ds = obj.ds;
                end
            elseif isnumeric(arg)
                dspath=joinpath(ds.savepath, snprintf('participant%03d',arg));
                if exist(dspath,2)
                    obj=load(dspath);
                    ds = obj.ds;
                else
                    pp=Participant(arg);
                    ds.name=pp.conf.name;
                    ds.get_pp_data_averaged(pp);
                    ds.get_data_rel();
                end
            elseif isa(arg,'Participant')
                pp=arg;
                ds.name=pp.conf.name;
                ds.get_pp_data_averaged(pp);
                ds.get_data_rel();
            end
        end

        function save(ds)
            filepath=joinpath(ds.savepath,ds.name);
            save(filepath, 'ds');
        end
        
        function plot(ds)
            ds.plot_posthoc()
            ds.plot_groups()
            ds.plot_participants()
        end
            
        function plot_posthoc(ds)
            keys=ds.posthoc.keys;
            for k=1:length(keys)
                plot(ds.posthoc(keys{k}))
            end
        end
%         
%         function plot_groups(ds)
%         end
%         
%         function plot_participants(ds)
%         end
        
        function analyze_all(ds)
            ds.export2R()
            ds.doRstats()
            ds.parsestats()            
            ds.get_posthoc()
        end
        
        function analyze_skipR(ds)
            ds.parsestats()
            ds.get_posthoc()
        end   
        
        function analyze(ds)
            ds.get_posthoc()
        end
        
        function doRstats(ds)            
            cmdpath=joinpath(ds.Rpath,'main.R');
            command=sprintf('Rscript %s',cmdpath);
            status = system(command);
            if status==1
                disp('no errors reported\n')
            else
                fprintf('Exit status=%d\n',status)
            end
        end
        
        function parsestats(ds)
            command=joinpath(ds.Pythonpath,'parse_stats.py');
            status = system(command);
            if status==1
                disp('no errors reported\n')
            else
                fprintf('Exit status=%d\n',status)
            end
            ds.load_interactions();
        end
        
        function get_posthoc(ds)
            if isempty(ds.analvars) | strcmp(ds.analvars,'all')
                %Plot all variables if vnames were not selected by user
                for v=1:length(ds.flists)
                    flist=ds.flists{v};
                    vname=flist{1};
                    %fprintf(fid,'Analysis of variable %s\n',vname);
                    if length(flist)==1
                        continue;
                    elseif length(vname)>3 && strcmp(vname(1:3),'Uni')
                        continue
                    elseif length(vname)>3 && strcmp(vname(end-2:end),'rel')
                        ds.posthoc(vname)=PostHoc(ds,vname(1:end-3), ds.dataRel,flist{2:end},1);
                    elseif length(vname)>3 && strcmp(vname(1:4),'DID_')
                        ds.posthoc(vname)=PostHoc(ds,vname(5:end), ds.dataD, flist{2:end},0,1);           
                    else
                        ds.posthoc(vname)=PostHoc(ds, vname, ds.dataB, flist{2:end});
                    end
                end
            else
                %Plot variables selected by user
                for v=1:length(ds.analvars)
                    vname=ds.analvars{v};
                    idx=strcmp(vname,ds.fvnames);                    
                    if length(ds.flists{idx})==1
                        continue;
                    else
                        interactions=ds.flists{idx}{2};
                    end
                    if any(idx)
                        %fprintf(fid,'Analysis of variable %s\n',vname);
                        if length(vname)>3 && strcmp(vname(1:4),'DID_')  
                            ds.posthoc(vname)=PostHoc(ds,vname(5:end), ds.dataD, interactions, 0, 1);
                        else      
                            ds.posthoc(vname)=PostHoc(ds,vname, ds.dataB, interactions);
                            if ds.dorel
                                idx=strcmp([vname,'rel'], ds.fvnames);
                                if length(ds.flists{idx})==1
                                    continue;
                                else
                                    interactions=ds.flists{idx}{2};
                                end
                                if any(idx)
                                    %fprintf(fid,'Analysis of variable %srel\n',vname);
                                    ds.posthoc(vname)=PostHoc(ds,vname, ds.dataRel, interactions, 1);
                                end
                            end
                        end
                    else
                        disp(['unknown variable ',vname])
                    end
                end
            %fclose(fid);    
            end    
            
        end
    end
    
    methods(Static)
        dataout=merge_pp_bimatrix(datain,C)
        dataout=merge_pp_unimatrix(datain,C)
    end
        
    methods(Access = private)
        get_all_data_averaged(ds)
        get_all_data_raw(ds)
        get_data_rel(ds)
        get_pp_data_averaged(ds,pp)
        set_did_mode(ds)        
        get_ANOVA_variables(ds)        
        merge_pp_dir(ds,dirpath)
        load_interactions(ds)
    end
    
end
