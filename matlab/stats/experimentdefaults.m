function experimentdefaults(expcfg)
        expcfg.vtypes={'osc','vf','ls'};
        expcfg.C=[2,3,6,8,9];
        expcfg.U=[1,4,5,7,10];
        expcfg.pp_by_groups=[expcfg.C;expcfg.U];
        expcfg.ppbygrp=[expcfg.C, expcfg.U];
        expcfg.hands=2;
        expcfg.hno=expcfg.hands;
        expcfg.idl=2;
        expcfg.idr=3;
        expcfg.ss=3;
        expcfg.rep=3;
        expcfg.grps=10;

        %Labels for levels of experimental factors
        expcfg.cnames={'Strong','Weak'};
        expcfg.lnames={'Easy','Difficult'};
        expcfg.rnames={'Easy','Medium','Difficult'};
        expcfg.snames={'S1','S2','S3'};
        expcfg.dnames3={'Zero','Small','Large'};
        expcfg.dnames6={'+2','+1','0_D','0_E','-1','-2'};
        
        %Bimanual variable names and labels for printing
        expcfg.vnames={'MTL','MTR','accQL','accQR','HarmonicityL','HarmonicityR',...
                       'IPerfEfL','IPerfEfR','vfCircularityL','vfCircularityR',...
                       'maxangleL','maxangleR','rho','flsPC','phDiffStd','phDiffChiSq',...
                       'KLD','minPeakDelay','minPeakDelayNorm'};
        expcfg.vstrns={'MT_L','MT_R','AQ_L','AQ_R','H_L','H_R','IPE_L','IPE_R',...
                       'VFC_L','VFC_R','MA_L','MA_R','\rho','FLS','\phi_{SD}','\phi_{SD} \chisquare',...
                       'KullBack-Leiber distance','dpeaks','dpeaks_{norm}'};
        
        %Ipsi/Contra variable names, units and labels for printing           
        expcfg.vstrs={'MT','AT','DT','AQ','IPE',...
                      'MA','d3D','d4D','Circularity',...
                      'VFC','VFT','H',...
                      '\rho','FLS','\phi_{SD}','\phi_{SD} \chisquare','KLD','dpeaks','dpeaks_{norm}'};
        expcfg.units={' (s)',' (s)',' (s)','',' (bits/s)',...
                      '(rad)','','','',...
                      '','','',...
                      '','','','','','(s)','(s²)'};      
        expcfg.titles={'Movement Time','Acceleration Time','Deceleration Time','Acceleration Ratio','Effective Index of Performace',...
                       'Maximal Angle','3D Distance','4D Distance','Circularity',...
                       'Vector Field Circularity','Vector Field Trajectory Circularity','Harmonicity',...
                       '\rho','flsPC','\phi_{SD}','\phi_{SD} \chi test','Kullback-Leiber Distance','Minimal Peak Delay','Minimal Peak Delay Normalized'};     

        %Variables used for Posthoc analysis and group plots    
        expcfg.varsGDID={'rho','flsPC','phDiffStd','KLD'};        
        expcfg.titlesGDID={'\rho','FLS','\phi_{SD}','D_{KL}'};          
        expcfg.varsGDID6={'MT','Harmonicity','vfCircularity'};%,'rho','flsPC','phDiffStd','MI','minPeakDelay','minPeakDelayNorm','d3D','d4D'};
        expcfg.titlesGDID6={'MT','H','VFC'};%,'rho','flsPC','phDiffStd','MI','minPeakDelay','minPeakDelayNorm','d3D','d4D'};  
        %analvars={'MTL','MTR','accQL','accQR','IPerfEfR','IPerfEfL',...
        %          'HarmonicityL','HarmonicityR','vfCircularityR','vfCircularityL','maxangleL','maxangleR',...
        %          'rho','flsPC','phDiffStd','minPeakDelay','DID_rho','DID_flsPC','DID_phDiffStd','DID_minPeakDelay'}
        %analvars='all'
        expcfg.analvars={'DID6_MT','DID6_Harmonicity','DID6_vfCircularity','DID3_rho','DID3_flsPC','DID3_phDiffStd','DID3_KLD'};   
        expcfg.excludeVars={'MTOwn','MTOther','IDOwn','IDOther','IDOwnEf','IDOtherEf'};
end