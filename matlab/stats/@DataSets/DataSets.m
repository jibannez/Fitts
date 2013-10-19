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
        statspath
        plotpath
        Rpath
        Pythonpath
    end
    
    properties(SetObservable = true)
        DIDmode='6levels2'
    end
    properties (Hidden=true)
        %Global configurations for plots
        ext
        dpi
        col2inches
        aureumprop
        do_legend
        do_anotations
        do_title
        do_ylabel
        do_grids
        do_latex
        do_ticks
        do_yticklabels
        plot_type       
        figsize
        fontname
        fontnamelatex
        fontsize         
        
        %Global variables representing the structure the experiment        
        conf=Config()
        name
        vtypes
        C
        U       
        pp_by_groups
        ppbygrp
        vnoB
        vnoU
        hands
        hno
        idl
        idr
        ss
        rep
        grps
        
        
        %Plot globals
        cnames
        lnames
        rnames
        snames
        dnames
        dnames3
        dnames6
        vnames
        vstrns
        
        %Define or fetch some globals for DID PLOT_GROUPS            
        vstrs
        units
        titles
        
        varsDID
        titlesDID
        varsGDID
        titlesGDID
        varsGDID6
        titlesGDID6
        excludeVars
        analvars
        
        %Flags
        verbose=1
        fid=1
        order=1
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
            if nargin<1, arg=''; end
            if ds.fetch_grouped_data, ds.grps=2; else ds.grps=10; end
            if ds.fetch_raw_data, error('Not implemented'); end   
            
            ds.set_did_mode()            
            addlistener(ds,'DIDmode','PostSet',@(src,evnt)set_did_mode(ds));
            
            %Get essential variables and paths
            experimentdefaults(ds);
            plotdefaults(ds);
            %ds.figsize=floor([0,0,1,1/ds.aureumprop]*ds.col2inches*ds.dpi);
            %set(0,'defaulttextinterpreter','latex')
            set(0,'DefaultTextFontname', ds.fontname)
            set(0,'DefaultAxesFontName', ds.fontname)
            ds.get_ANOVA_variables();
            ds.name=ds.conf.name;
            ds.plotpath=ds.conf.plot_path;
            ds.savepath=joinpath(ds.conf.rout_path,'ds');
            ds.savepathR=joinpath(ds.conf.rout_path,'dataframes');
            ds.statspath=joinpath(ds.conf.rout_path,'stats');
            ds.Rpath=joinpath(joinpath(joinpath(joinpath(getuserdir(),'Dropbox'),'dev'),'Bimanual-Fitts'),'R');
            ds.Pythonpath=joinpath(joinpath(joinpath(joinpath(getuserdir(),'Dropbox'),'dev'),'Bimanual-Fitts'),'python');
            
            if ~exist(ds.savepath,'dir'),mkdir(ds.savepath); end            
            if ~exist(ds.savepathR,'dir'),mkdir(ds.savepathR); end
            if ~exist(ds.statspath,'dir'),mkdir(ds.statspath); end
            
            %Get data
            if isempty(arg)
                ds=ds.get_data(ds.savepath);
                ds.name='all';
            else
                ds=ds.get_data(arg);
            end
        end
        
        function ds = get_data(ds,arg)
            if nargin<2, arg=ds.savepath; end
            
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
            ds.plot_participants()
            ds.plot_groups()
            ds.plot_posthoc()
        end
            
        function plot_posthoc(ds)
            keys=ds.posthoc.keys;
            for k=1:length(keys)
                plot(ds.posthoc(keys{k}))
            end
        end
        
        function analyze_all(ds)
            ds.analyze_R()
            ds.parsestats()     
            ds.load_interactions()
            ds.analyze_posthoc()
        end
        
        function analyze_R(ds)
            modes={'3levels','6levels2'};
            for idx=1:2
                ds.DIDmode=modes{idx};   
                ds.merge_ID_factors();
                ds.export2R()
                ds.doRstats()
            end
        end
        
        function analyze_noR(ds)
            ds.parsestats()
            ds.load_interactions()
            ds.analyze_posthoc()
        end   
        
        
        function doRstats(ds)
            cmdpath=joinpath(ds.Rpath,'main.R');
            command=sprintf('Rscript %s',cmdpath);  
            status = system(command);
            if status==1
                disp('no errors reported\n')
            else
                fprintf('R script exit status=%d\n',status)
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
        end
        
        function analyze_posthoc(ds)
            %if ~isempty(ds.analvars) | strcmp(ds.analvars,'all')
            %Plot all variables if vnames were not selected by user
                for v=1:length(ds.flists)
                    flist=ds.flists{v};
                    vname=flist{1};
                    if ~any(strcmp(vname,ds.analvars))
                        continue
                    end
                    %fprintf(fid,'Analysis of variable %s\n',vname);
                    if length(flist)==1
                        continue;
                    elseif length(vname)>3 && strcmp(vname(1:3),'Uni')
                        continue
                    elseif length(vname)>3 && strcmp(vname(end-2:end),'rel')
                        vn=vname(1:end-3);
                        ds.posthoc(vname)=PostHoc(ds,vn,vn, ds.dataRel,flist{2:end},1,0);
                    elseif length(vname)>3 && strcmp(vname(1:5),'DID6_')
                        ds.DIDmode='6levels2';
                        vn=vname(6:end);
                        vs=ds.titlesGDID6{strcmp(vn,ds.varsGDID6)};
                        ds.merge_ID_factors();
                        ds.posthoc(vname)=PostHoc(ds,vn,vs, ds.dataD, flist{2:end},0,1);           
                    elseif length(vname)>3 && strcmp(vname(1:5),'DID3_')
                        ds.DIDmode='3levels';                        
                        vn=vname(6:end);
                        vs=ds.titlesGDID{strcmp(vn,ds.varsGDID)};
                        ds.merge_ID_factors();
                        ds.posthoc(vname)=PostHoc(ds,vn,vs, ds.dataD, flist{2:end},0,1);    
                    else
                        ds.posthoc(vname)=PostHoc(ds, vname,vname, ds.dataB, flist{2:end},0,0);
                    end
                end
%             else
%             %Plot variables selected by user
%                 for v=1:length(ds.analvars)
%                     vname=ds.analvars{v};
%                     idx=strcmp(vname,ds.fvnames);                    
%                     if length(ds.flists{idx})==1
%                         continue;
%                     else
%                         interactions=ds.flists{idx}{2};
%                     end
%                     if any(idx)
%                         %fprintf(fid,'Analysis of variable %s\n',vname);
%                         if length(vname)>3 && strcmp(vname(1:4),'DID_')  
%                             ds.posthoc(vname)=PostHoc(ds,vname(5:end), ds.dataD, interactions, 0, 1);
%                         else      
%                             ds.posthoc(vname)=PostHoc(ds,vname, ds.dataB, interactions);
%                             if ds.dorel
%                                 idx=strcmp([vname,'rel'], ds.fvnames);
%                                 if length(ds.flists{idx})==1
%                                     continue;
%                                 else
%                                     interactions=ds.flists{idx}{2};
%                                 end
%                                 if any(idx)
%                                     %fprintf(fid,'Analysis of variable %srel\n',vname);
%                                     ds.posthoc(vname)=PostHoc(ds,vname, ds.dataRel, interactions, 1);
%                                 end
%                             end
%                         end
%                     else
%                         disp(['unknown variable ',vname])
%                     end
%                 end
%             %fclose(fid);    
%             end    
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
        get_ANOVA_variables(ds)        
        merge_pp_dir(ds,dirpath)
        set_did_mode(ds) 
        %load_interactions(ds)
    end
    
end
