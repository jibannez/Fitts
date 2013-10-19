classdef LockingStrength < handle
    properties
        conf
        ts
        flsPC_
        flsAmp_
        phDiff_
        phDiffMean_
        phDiffStd_
        rho_
        KLD_
        d4D_
        d3D_
        d2D_
        d1D_
        Lph_
        Rph_
        Lf_
        Rf_
        LPxx_
        RPxx_
        freq_
        SlowPxx_
        FastPxx_
        SlowPxx_t_
        FastPxx_t_
        p_
        q_
        p_KLD_
        q_KLD_
        minPeakDelayNorm_
        minPeakDelay_
    end % properties
    
    properties (Dependent = true, SetAccess = private)        
        flsPC
        flsAmp
        phDiffChiSq
        phDiff
        phDiffMean
        phDiffStd
        rho
        KLD
        d4D
        d3D
        d2D
        d1D
        Lph
        Rph
        Lf
        Rf
        LPxx
        RPxx
        freq
        SlowPxx
        FastPxx
        SlowPxx_t
        FastPxx_t
        p
        q
        p_KLD
        q_KLD
        minPeakDelayNorm
        minPeakDelay        
    end

   %%%%%%%%%%%%%%%%%%
   % Public methods
   %%%%%%%%%%%%%%%%%%      
   methods
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % Prototypes of Public methods
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       plot(obj,graphPath,rootname,ext)
       disp(obj)
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %Properties getters and setter
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function rho = get.rho(obj)
           if obj.conf.store_ls==1
               rho=obj.rho_;
           else
               q=obj.q; p=obj.p;
               if q>p
                   rho=q/p;
               else
                   rho=p/q;
               end
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function flsPC = get.flsPC(obj)
           if obj.conf.store_ls==1
               flsPC=obj.flsPC_;
           else
               %Compute FLS Pure Coordination
               %with formula from Huys et al. (2004), HMS
               %N=sqrt( (obj.rho^2+1) / ((obj.rho+1)*8) );
               N=sqrt(1+obj.rho^2)*(1/obj.rho+1)*sqrt(1/8);
               %N=sqrt( (obj.rho^2+1) / ((obj.rho+1)*8) );
               flsPC = 2*N * trapz(obj.freq,obj.SlowPxx_t.*obj.FastPxx) / trapz(obj.freq,obj.SlowPxx_t.^2+obj.FastPxx.^2);
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function flsAmp = get.flsAmp(obj)
           if obj.conf.store_ls==1
               flsAmp = obj.flsAmp_;
           else
               %Compute FLS Amplitude
               %with formula from Huys et al. (2004), HMS
               %N=sqrt( (obj.rho^2+1) / ((obj.rho+1)*8) );
               N=sqrt(1+obj.rho^2)*(1/obj.rho+1)*sqrt(1/8);
               flsAmp = 2*N * trapz(obj.freq,obj.FastPxx_t.*obj.SlowPxx_t) / trapz(obj.freq,obj.FastPxx_t.^2+obj.SlowPxx_t.^2);
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function phDiff = get.phDiff(obj)
           %if obj.conf.store_ls==1
           %    phDiff=obj.phDiff_;
           %else
               %phDiff = obj.q*obj.Lph-obj.p*obj.Rph;     
               %phDiff= filterdata((obj.p_KLD*unwrap(obj.Lph)-obj.q_KLD*unwrap(obj.Rph))/((obj.p_KLD+obj.q_KLD)/2),0.1);
               phDiff= (obj.p_KLD*unwrap(obj.Lph)-obj.q_KLD*unwrap(obj.Rph))/((obj.p_KLD+obj.q_KLD)/2);
           %end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function phDiffChiSq = get.phDiffChiSq(obj)    
            x=obj.phDiff;
            n = length(x);
            edges = linspace(min(x),max(x),20);
            expectedCounts = n * diff(edges);            
            phDiffChiSq = chi2gof(x,'edges',edges,'expected',expectedCounts);  
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function phDiffMean = get.phDiffMean(obj)
           %if obj.conf.store_ls==1
           %    phDiffMean=obj.phDiffMean_;
           %else
               %[phDiffMean,~]=circstat(obj.p_KLD*obj.Lph-obj.q_KLD*obj.Rph);
               [phDiffMean,~]=circstat(obj.phDiff);
           %end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function phDiffStd = get.phDiffStd(obj)
           %if obj.conf.store_ls==1
           %    phDiffStd=obj.phDiffStd_;
           %else
               %[~, phDiffStd]=circstat(obj.p_KLD*obj.Lph-obj.q_KLD*obj.Rph);
               [~, phDiffStd]=circstat(obj.phDiff);
           %end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function p_KLD = get.p_KLD(obj)
           %if obj.conf.store_ls==1
           %    p_KLD=obj.p_KLD_;
           %else
               %best_pq = find_best_pq(obj);
               %p_KLD=best_pq(2);
               pfit=fit([1:length(obj.Rph)]'/1000,unwrap(obj.Rph),'poly1');
               p_KLD=-pfit.p1;
           %end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function q_KLD = get.q_KLD(obj)
           %if obj.conf.store_ls==1
           %    q_KLD=obj.q_KLD_;
           %else
               %best_pq = find_best_pq(obj);
               %q_KLD=best_pq(3);
               pfit=fit([1:length(obj.Lph)]'/1000,unwrap(obj.Lph),'poly1');
               q_KLD=-pfit.p1; 
           %end
       end

       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function KLD = get.KLD(obj)
           %if obj.conf.store_ls==1
           %    KLD=obj.KLD_;
           %else
               %Get Kulback-Leiber distance between phase difference and uniform distribution
               %[KLD,~]=Kulback_Leibler_distance(filterdata(obj.phDiff,0.1),obj.conf.KLD_bins);
               ph=rem(obj.phDiff+pi,2*pi);
               ph(ph<0)=2*pi-ph(ph<0);
               [KLD,~]=Kulback_Leibler_distance(ph-pi,8);
           %end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function d4D = get.d4D(obj)
           if obj.conf.store_ls==1
               d4D=obj.d4D_;
           else
               d4D=sqrt((obj.ts.Lxnorm-obj.ts.Rxnorm).^2 + (obj.ts.Lvnorm-obj.ts.Rvnorm).^2);
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function d3D = get.d3D(obj)
           if obj.conf.store_ls==1
               d3D=obj.d3D_;
           else
               Rx=obj.ts.Rxnorm;
               Rv=obj.ts.Rvnorm;
               Lx=obj.ts.Lxnorm;
               Lv=obj.ts.Lvnorm;
               z=zeros(size(Lx));
               l=[Lx,Lv,z];
               r=[Rx,z,Rv];
               d3D=sqrt((l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2 + (l(:,3)-r(:,3)).^2);
               %d3D=d3D-mean(d3D);
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function d2D = get.d2D(obj)
           if obj.conf.store_ls==1
               d2D=obj.d2D_;
           else
               Lx=obj.ts.Lxnorm;
               Rx=obj.ts.Rxnorm;
               z=zeros(size(Lx));
               l=[Lx,z];
               r=[z,Rx];
               d2D=sqrt((l(:,1)-r(:,1)).^2 + (l(:,2)-r(:,2)).^2);
               %d2D=d2D-mean(d2D);
               %d2D=zeros(length(obj.ts.Lph),1);
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function d1D = get.d1D(obj)
           if obj.conf.store_ls==1
               d1D=obj.d1D_;
           else
               d1D=obj.phDiff;
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function Rph = get.Rph(obj)
           if obj.conf.store_ls==1
               Rph=obj.Rph_;
           else
               Rph=obj.ts.Rph;
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function Lph = get.Lph(obj)
           if obj.conf.store_ls==1
               Lph=obj.Lph_;
           else
               Lph=obj.ts.Lph;
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function Rf = get.Rf(obj)
           if obj.conf.store_ls==1
               Rf=obj.Rf_;
           else
               Rf=obj.ts.Rf;
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function Lf = get.Lf(obj)
           if obj.conf.store_ls==1
               Lf=obj.Lf_;
           else
               Lf=obj.ts.Lf;
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function RPxx = get.RPxx(obj)
           if obj.conf.store_ls==1
               RPxx=obj.RPxx_;
           else
               RPxx=obj.ts.RPxx;
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function LPxx = get.LPxx(obj)
           if obj.conf.store_ls==1
               LPxx=obj.LPxx_;
           else
               LPxx=obj.ts.LPxx;
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function freq = get.freq(obj)
           if obj.conf.store_ls==1
               freq=obj.freq_;
           else
               freq=obj.ts.freq;
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function p = get.p(obj)
           if obj.conf.store_ls==1
               p=obj.p_;
           else
               [p,~]=obj.get_p_q();
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function q = get.q(obj)
           if obj.conf.store_ls==1
               q=obj.q_;
           else
               [~,q]=obj.get_p_q();
           end
       end
   
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function SlowPxx = get.SlowPxx(obj)
           if obj.conf.store_ls==1
               SlowPxx=obj.SlowPxx_;
           else
               if obj.Lf > obj.Rf
                   SlowPxx=obj.RPxx;
               else
                   SlowPxx=obj.LPxx;
               end
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function FastPxx = get.FastPxx(obj)
           if obj.conf.store_ls==1
               FastPxx=obj.FastPxx_;
           else
               if obj.Lf > obj.Rf
                   FastPxx=obj.LPxx;
               else
                   FastPxx=obj.RPxx;
               end
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function SlowPxx_t = get.SlowPxx_t(obj)
           if obj.conf.store_ls==1
               SlowPxx_t=obj.SlowPxx_t_;
           else
               SlowPxx_t = obj.get_scaled_PSD(obj.SlowPxx,obj.freq,obj.rho);
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function FastPxx_t = get.FastPxx_t(obj)
           if obj.conf.store_ls==1
               FastPxx_t=obj.FastPxx_t_;
           else
               FastPxx=obj.FastPxx;
               FastPxx_t = FastPxx / obj.freq(FastPxx==max(FastPxx));
           end
       end
       

       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function minPeakDelay = get.minPeakDelay(obj)
           if obj.conf.store_ls==1
               minPeakDelay=obj.minPeakDelay_;
           else
               minPeakDelay=mpd(obj,0);
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function minPeakDelayNorm = get.minPeakDelayNorm(obj)
           if obj.conf.store_ls==1
               minPeakDelayNorm=obj.minPeakDelayNorm_;
           else
               minPeakDelayNorm=mpd(obj,1);
           end
       end
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function ls = LockingStrength(ts,conf)
            ls.conf=conf;            
            if ls.conf.store_ls==1
                ls.get_properties(ts);
            else
                ls.ts=ts;
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function update_conf(ls,conf)
            ls.conf=conf;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function update(ls,ts)
            ls.get_properties(ts);
        end
   end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   methods(Static=true)
       Pxx_t = get_scaled_PSD(Pxx,f,rho)
       function anova_var = get_anova_variables()
           anova_var = { 'KLD' 'rho' 'flsPC' 'flsAmp' 'phDiffMean' 'phDiffStd' 'phDiffChiSq' 'd4D' 'd3D' 'd2D' 'd1D' 'minPeakDelay' 'minPeakDelayNorm'};
       end
   end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
        
        
        
        
