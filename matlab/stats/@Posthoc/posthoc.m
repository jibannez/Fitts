classdef PostHoc < handle
    properties
        ds
        DIDmode
        vname
        vstr
        vnames
        fname='anova.out'
        flists
        data
        results
        savepath
        %grps
        isrel = 0
        isdid = 0
        order = 1
        rfirst
        verbose = 0
        holmCtrl = 0
        holmAlpha = 0.05
        holmTail = 2
        do_anotations
    end
    
    methods
        function phoc = PostHoc(ds,vname,vstr,data,flists,isrel,isdid)
            if nargin<6, isdid=0; end
            if nargin<5, isrel=0; end
            
            phoc.ds=ds;
            phoc.vname=vname;
            phoc.vstr=vstr;
            phoc.do_anotations=ds.do_anotations;
            if strcmp('all',phoc.ds.analvars)
                phoc.vnames=phoc.ds.vnamesB;
            else
                phoc.vnames=phoc.ds.analvars;
            end
            
            phoc.data=data;
            phoc.isrel=isrel;
            phoc.isdid=isdid;        
            phoc.DIDmode=ds.DIDmode;
            
            if phoc.isdid
                if strcmp('all',flists)
                    phoc.flists={{'grp','ss','did'}};
                else
                    %Sort factor interaction list by the order of the interaction
                    elementLengths = cellfun(@(x) length(x),flists);
                    [~,sortIdx] = sort(elementLengths);
                    phoc.flists = flists(sortIdx);
                end     
                phoc.rfirst=0;
                if strcmp(ds.DIDmode,'6levels2')
                    phoc.savepath=joinpath(joinpath(ds.plotpath,'posthoc'),['DID6_',vname]);
                else
                    phoc.savepath=joinpath(joinpath(ds.plotpath,'posthoc'),['DID3_',vname]);
                end
            else
                %Plot ipsilateral variables always first in interactions
                if strcmp(phoc.vname(end),'R')
                    if phoc.order==1
                        phoc.rfirst=1;
                    else
                        phoc.rfirst=0;
                    end
                else
                    if phoc.order==1
                        phoc.rfirst=0;
                    else
                        phoc.rfirst=1;
                    end
                end
                
                if strcmp('all',flists)
                    phoc.flists={{'grp','idl','idr','ss'}};
                else
                    %Sort factor interaction list by the order of the interaction
                    elementLengths = cellfun(@(x) length(x),flists);
                    [~,sortIdx] = sort(elementLengths);
                    phoc.flists = flists(sortIdx);
                end  
                
                if phoc.isrel
                    phoc.savepath=joinpath(joinpath(ds.plotpath,'posthoc'),[vname,'rel']);                    
                else
                    phoc.savepath=joinpath(joinpath(ds.plotpath,'posthoc'),vname);
                end
            end
            phoc.run()
        end
        
        function plot(phoc)
            if phoc.isdid
                phoc.plot_var_did_orig()
            else
                phoc.plot_var()
            end
        end
        
        function run(phoc)
            phoc.results=cell(1,length(phoc.flists));
            for i=1:length(phoc.flists)
                phoc.results{i}=phoc.analyze_var(phoc.flists{i});
            end
        end
        
        function display(phoc)
            for i=1:length(phoc.flists)
                titstr='\n\n\t  Post-hoc analysis of factors: ';
                for f=1:length(phoc.flists{i})
                    titstr=[titstr,phoc.flists{i}{f}];
                end
                fprintf([titstr,'\n']);  
                phoc.showholmbyfactor2(i);
            end
        end
                
    end
    
    methods(Static)
        [newdata,flabels] = get_posthoc_groups(data,factors)
        [f1mat,f2mat]=get_pairwise_comparisons(holmmat,data,factors)
        outmat=get_holmmat(varargin)
    end
    
end



            
