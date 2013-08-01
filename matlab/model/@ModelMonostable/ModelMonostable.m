classdef ModelMonostable < handle
    properties(SetObservable = true)
        conf
        byname
        stype % 1=Unidimensional
        % 2=Bidimensional uncoupled
        % 3=Bidimensional coupled
        %Local instance of integrator setup
        ode
        options
        eq
        fitfcn
        params
        parnames
        IC
        tspan
    end
    
    properties
        %Time series variables
        t
        ph
        
        %Paramerization Initial conditions cell arrays
        pset
        ppset
        icset
        bins
        phhist_range
        
        %Vector field and nullcline related variables
        vfrange
        ncrange
        ph_periods
        vf_
        nc1
        nc2
        potencial_
    end
    
    properties (Dependent = true, GetAccess = public)   
        %Angular time series
        phmod
        phdot
        phcos
        phsin
        phcosdot
        phsindot  
        phdiff
        omeganorm
        d4D
        fs
        pdelay
        fth
        fth1
        fth2
        %Peaks and indexes
        xpeaks
        vpeaks
        phpeaks        
        x1peaks
        v1peaks
        ph1peaks        
        idx1
        x2peaks
        v2peaks
        ph2peaks        
        idx2
        idx        
        %Cartesian Time series
        x
        v
        a
        xnorm
        vnorm
        anorm
        x1
        v1
        a1
        xnorm1
        vnorm1
        anorm1
        x2
        v2
        a2
        xnorm2
        vnorm2
        anorm2
        %Cartesian ts-based histograms
        x_hist
        v_hist
        a_hist
        xnorm_hist
        vnorm_hist
        anorm_hist
        x1_hist
        v1_hist
        a1_hist
        xnorm1_hist
        vnorm1_hist
        anorm1_hist
        x2_hist
        v2_hist
        a2_hist
        xnorm2_hist
        vnorm2_hist
        anorm2_hist
        %Cartesian ph-based histograms
        x_phhist
        v_phhist
        a_phhist
        xnorm_phhist
        vnorm_phhist
        anorm_phhist
        x1_phhist
        v1_phhist
        a1_phhist
        xnorm1_phhist
        vnorm1_phhist
        anorm1_phhist
        x2_phhist
        v2_phhist
        a2_phhist
        xnorm2_phhist
        vnorm2_phhist
        anorm2_phhist
        %Angular ts-based histograms
        ph_hist
        omega_hist
        omeganorm_hist
        ph1_hist
        omega1_hist
        omeganorm1_hist
        ph2_hist
        omega2_hist
        omeganorm2_hist
        %Angular ph-based histograms
        ph_phhist
        omega_phhist
        omeganorm_phhist
        ph1_phhist
        omega1_phhist  
        omeganorm1_phhist
        ph2_phhist
        omega2_phhist  
        omeganorm2_phhist        
        %Nullclines and vector fields 
        ph1nc
        ph2nc
        vf
        vfcart
        potencial        
        %Locking strenth measures
        flsPC
        flsAmp
        phDiff
        phDiffMean
        phDiffStd
        rho        
        p
        q
        f
        f1
        f2
        Pxx
        Pxx1
        Pxx2
        freq
        SlowPxx
        FastPxx
        SlowPxx_t
        FastPxx_t
        %Oscillatory properties
        
    end    

    methods          
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function mdl = ModelMonostable(name,conf)
            if nargin<1, name='d'; end
            if nargin<2, conf=ModelConfig(); end
            
            if any(strcmp({'em','ed1','ed3','md3'},name))
                mdl.stype=2;
                mdl.params=num2cell(conf.params2Dmonostablebyname(name));
            elseif any(strcmp({'e','m1','m3','d'},name))
                mdl.stype=1;
                mdl.params=num2cell(conf.params1Dmonostablebyname(name));
            else
                error('Unknow model type. Possible model names are e,m1,m3,d,em,ed,md')               
            end
            
            mdl.byname=name;
            mdl.conf=conf;
            mdl.pset={};
            mdl.ppset={};
            mdl.icset={};
            mdl.setup();
            mdl.setcallbacks();
            mdl.phhist_range=-pi:mdl.conf.bins:pi;
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Callback Methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function setcallbacks(mdl)
            addlistener(mdl.conf,'PostSet',@mdl.update_conf);
            %addlistener(mdl,'conf','PostSet',@(src,evnt)update_conf(mdl,src,evnt));
            addlistener(mdl,'stype','PostSet',@(src,evnt)update_stype(mdl,src,evnt));
            addlistener(mdl,'ode','PostSet',@(src,evnt)update_params(mdl,src,evnt));
            addlistener(mdl,'options','PostSet',@(src,evnt)update_params(mdl,src,evnt));
            addlistener(mdl,'eq','PostSet',@(src,evnt)update_params(mdl,src,evnt));
            addlistener(mdl,'params','PostSet',@(src,evnt)update_params(mdl,src,evnt));
            addlistener(mdl,'parnames','PostSet',@(src,evnt)update_params(mdl,src,evnt));
            addlistener(mdl,'IC','PostSet',@(src,evnt)update_params(mdl,src,evnt));
            addlistener(mdl,'tspan','PostSet',@(src,evnt)update_params(mdl,src,evnt));        
        end
        
        function update_conf(mdl,src,evnt)
            mdl.setup();
        end
        
        function update_stype(mdl,src,evnt)
            mdl.setup();            
        end
        
        function update_params(mdl,src,evnt)
            mdl.t     = [];
            mdl.ph    = [];
        end
        
        function pfit=fit(mdl,tr,do_plot)
            if nargin<3, do_plot=1; end

            if mdl.stype < 2 
                pfit=mdl.fit_trial1D(tr,do_plot);
            else
                pfit=mdl.fit_trial2D(tr,do_plot);
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Property getters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Simulated time series
        
        function phmod = get.phmod(mdl)
            if mdl.stype<2
                phmod=atan2(mdl.phsin,mdl.phcos);
            else
                phmod=[atan2(mdl.phsin(:,1),mdl.phcos(:,1)),...
                       atan2(mdl.phsin(:,2),mdl.phcos(:,2))];
            end            
        end   
        
        function phdiff = get.phdiff(mdl)
            if mdl.stype<2
                phdiff=[];
            else
                phdiff=mdl.ph(:,1)-mdl.ph(:,2);
            end            
        end   
        
        function phcos = get.phcos(mdl)
            if mdl.stype<2
                phcos=cos(mdl.ph);
            else
                phcos=[cos(mdl.ph(:,1)),...
                       cos(mdl.ph(:,2))];
            end
        end
        
        function phsin = get.phsin(mdl)
            if mdl.stype<2
                phsin=sin(mdl.ph);
            else
                phsin=[sin(mdl.ph(:,1)),...
                       sin(mdl.ph(:,2))];
            end
        end
        
        function phdot = get.phdot(mdl)
            if mdl.stype<2
                phdot=diff(mdl.ph)./diff(mdl.t);
                %phdot=filterdata([phdot(1);phdot],12,mdl.fs/2);
                phdot=[phdot(1);phdot];
            else
%                 phdot=[filterdata(diff(mdl.ph(:,1))*mdl.fs,12,mdl.fs/2),...
%                        filterdata(diff(mdl.ph(:,2))*mdl.fs,12,mdl.fs/2)];
                phdot=[diff(mdl.ph(:,1))*mdl.fs,...
                       diff(mdl.ph(:,2))*mdl.fs];
                phdot=[phdot(1,:);phdot];
            end
        end
        
        function phcosdot = get.phcosdot(mdl)
            if mdl.stype<2
                phcosdot=diff(mdl.phcos)./diff(mdl.t);
                phcosdot=[phcosdot(1);phcosdot];
            else
                phcosdot=[diff(mdl.phcos(:,1))./diff(mdl.t),...
                          diff(mdl.phcos(:,2))./diff(mdl.t)];
                phcosdot=[phcosdot(1,:);phcosdot];                
            end
        end
        
        function phsindot = get.phsindot(mdl)
            if mdl.stype<2
                phsindot=diff(mdl.phsin)./diff(mdl.t);
                phsindot=[phsindot(1);phsindot];                
            else
                phsindot=[diff(mdl.phsin(:,1))./diff(mdl.t),...
                          diff(mdl.phsin(:,2))./diff(mdl.t)];
                phsindot=[phsindot(1,:);phsindot];                     
            end
        end

        function omeganorm = get.omeganorm(mdl)
            if mdl.stype<2
                omeganorm=mdl.phdot./min(mdl.phdot);
            else
                omeganorm=[mdl.phdot(:,1)/min(mdl.phdot(:,1)),...
                           mdl.phdot(:,2)/min(mdl.phdot(:,2))];
            end
        end

        function d4D = get.d4D(mdl)
            if mdl.stype<2
                d4D=[];
            else
                d4D=sqrt( (mdl.phcos(:,1)-mdl.phcos(:,2)).^2 + (mdl.phcosdot(:,1)-mdl.phcosdot(:,2)).^2);
            end
        end     
        
        function fth = get.fth(mdl)
            if mdl.stype<2
                fth=sqrt(mdl.params{1}^2-mdl.params{2}^2-mdl.params{3}^2);
            else
                fth=[];
            end
        end
        
        function fth1 = get.fth1(mdl)
            if mdl.stype<2
                fth1=[];
            else
                fth1=sqrt(mdl.params{1}^2-mdl.params{3}^2-mdl.params{5}^2);
            end
        end
        
        function fth2 = get.fth2(mdl)
            if mdl.stype<2
                fth2=[];
            else
                fth2=sqrt(mdl.params{2}^2-mdl.params{4}^2-mdl.params{6}^2);
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Peaks and indexes

        function xpeaks = get.xpeaks(mdl)
            [maxPeaks, minPeaks] = peakdet(mdl.x, mdl.conf.peak_size);
            if ~isempty(minPeaks) && ~isempty(maxPeaks)
                xpeaks = sort([maxPeaks(:,1);minPeaks(:,1);length(mdl.x1)]);
            else
                xpeaks = [];
            end
        end
        
        function vpeaks = get.vpeaks(mdl)
            [maxPeaks, minPeaks] = peakdet(mdl.v, mdl.conf.peak_size);
            if ~isempty(minPeaks) && ~isempty(maxPeaks)
                vpeaks = sort([maxPeaks(:,1);minPeaks(:,1);length(mdl.v1)]);
            else
                vpeaks = [];
            end
        end
        
        function phpeaks = get.phpeaks(mdl)
            phpeaks = peakdet(mdl.phmod, pi/2);
            if ~isempty(phpeaks)
                phpeaks = phpeaks(1:end-1,1);
            else
                phpeaks = [];
            end
        end    
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function idx1 = get.idx1(mdl)
            [maxPeaks, minPeaks] = peakdet(mdl.phcos(:,1), mdl.conf.peak_size);
            if ~isempty(minPeaks) && ~isempty(maxPeaks)
                peaks = sort([maxPeaks(:,1);minPeaks(:,1)]);            
                idx1=(peaks(1,1):peaks(end,1))';
            else
                idx1=[];
            end
        end   
        
        function x1peaks = get.x1peaks(mdl)
            [maxPeaks, minPeaks] = peakdet(mdl.x1, mdl.conf.peak_size);
            if ~isempty(minPeaks) && ~isempty(maxPeaks)
                x1peaks = sort([maxPeaks(:,1);minPeaks(:,1);length(mdl.x1)]);
            else
                x1peaks = [];
            end
        end
        
        function v1peaks = get.v1peaks(mdl)
            [maxPeaks, minPeaks] = peakdet(mdl.v1, mdl.conf.peak_size);
            if ~isempty(minPeaks) && ~isempty(maxPeaks)
                v1peaks = sort([maxPeaks(:,1);minPeaks(:,1);length(mdl.v1)]);
            else
                v1peaks = [];
            end
        end
        
        function ph1peaks = get.ph1peaks(mdl)
            ph1peaks = peakdet(mdl.phmod(:,1), pi/2);
            if ~isempty(ph1peaks)
                ph1peaks = ph1peaks(1:end-1,1);
            else
                ph1peaks = [];
            end
        end    

        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function idx2 = get.idx2(mdl)
            [maxPeaks, minPeaks] = peakdet(mdl.phcos(:,2), mdl.conf.peak_size);
            if ~isempty(minPeaks) && ~isempty(maxPeaks)
                peaks = sort([maxPeaks(:,1);minPeaks(:,1)]);            
                idx2=(peaks(1,1):peaks(end,1))';
            else
                idx2=[];
            end
        end   
        
        function x2peaks = get.x2peaks(mdl)
            [maxPeaks, minPeaks] = peakdet(mdl.x2, mdl.conf.peak_size);
            if ~isempty(minPeaks) && ~isempty(maxPeaks)
                x2peaks = sort([maxPeaks(:,1);minPeaks(:,1);length(mdl.x2)]);
            else
                x2peaks = [];
            end
        end
        
        function v2peaks = get.v2peaks(mdl)
            [maxPeaks, minPeaks] = peakdet(mdl.v2, mdl.conf.peak_size);
            if ~isempty(minPeaks) && ~isempty(maxPeaks)
                v2peaks = sort([maxPeaks(:,1);minPeaks(:,1);length(mdl.v2)]);
            else
                v2peaks = [];
            end
        end
        
        function ph2peaks = get.ph2peaks(mdl)
            ph2peaks = peakdet(mdl.phmod(:,2), pi/2);
            if ~isempty(ph2peaks)
                ph2peaks = ph2peaks(1:end-1,1);
            else
                ph2peaks = [];
            end
        end   
        
        function fs = get.fs(mdl)
            if isempty(mdl.t)
                fs=100;
            else
                fs=floor(1/mean(diff(mdl.t)));
            end
        end
            
        function idx = get.idx(mdl)
            if mdl.stype < 2
                [maxPeaks, minPeaks] = peakdet(mdl.phcos, mdl.conf.peak_size);
                if ~isempty(minPeaks) && ~isempty(maxPeaks)
                    peaks = sort([maxPeaks(:,1);minPeaks(:,1)]);            
                    idx=(peaks(1,1):peaks(end,1))';
                else
                    idx=[];
                end
            else                
                [maxRPeaks, minRPeaks] = peakdet(mdl.phcos(:,2), mdl.conf.peak_size);
                Rpeaks = sort([maxRPeaks(:,1);minRPeaks(:,1)]);
                [maxLPeaks, minLPeaks] = peakdet(mdl.phcos(:,1), mdl.conf.peak_size);
                Lpeaks = sort([maxLPeaks(:,1);minLPeaks(:,1)]);
                if length(Lpeaks) < length(Rpeaks)
                    idx=(Lpeaks(1,1):Lpeaks(end,1))';
                else
                    idx=(Rpeaks(1,1):Rpeaks(end,1))';
                end
            end
        end        
        
        function pdelay = get.pdelay(mdl)
            Rpeaks=mdl.x2peaks;
            Lpeaks=mdl.x1peaks;
            Rlen = length(Rpeaks)-1;  %Extreme are always zeros!
            Llen = length(Lpeaks)-1;
            if Llen<Rlen
                q=round(Rlen/Llen);
                pdelay=zeros(Llen,1);
                for i=1:Llen
                    L=Lpeaks(i);
                    if q==1
                        if i==1
                            R=Rpeaks(1:i+1);
                        else
                            R=Rpeaks(i-1:i+1);
                        end
                    elseif (i*(q-1))<1
                        R=Rpeaks(1:i*(q+1));
                    elseif (i*(q+1))>Rlen
                        R=Rpeaks(i*(q-1):Rlen);
                    else
                        R=Rpeaks(i*(q-1):i*(q+1));
                    end
                    [d,j]=min(abs(L-R));
                    pdelay(i)=d*sign(L-R(j));
                end
            else
                q=round(Llen/Rlen);
                pdelay=zeros(Rlen,1);
                for i=1:Rlen
                    R=Rpeaks(i);
                    if q==1
                        if i==1
                            L=Lpeaks(1:i+1);
                        else
                            L=Lpeaks(i-1:i+1);
                        end
                    elseif (i*(q-1))<1
                        L=Lpeaks(1:i*(q+1));
                    elseif (i*(q+1))>Llen
                        L=Lpeaks(i*(q-1):Llen);
                    else
                        L=Lpeaks(i*(q-1):i*(q+1));
                    end
                    [d,j]=min(abs(R-L));
                    pdelay(i)=d*sign(L(j)-R);
                end
            end
            pdelay=pdelay/mdl.fs;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        %Kinematic time series
        function x = get.x(mdl)
            x=mdl.phcos(mdl.idx);
        end
        
        function v = get.v(mdl)
            v=[0;diff(mdl.x)./diff(mdl.t(mdl.idx))];
        end
        
        function a = get.a(mdl)
            a=[0;diff(mdl.v)./diff(mdl.t(mdl.idx))];
        end
        
        function xnorm = get.xnorm(mdl)
            xnorm=normalize(mdl.x);
        end
        
        function vnorm = get.vnorm(mdl)
            vnorm=normalize(mdl.v);
        end
        
        function anorm = get.anorm(mdl)
            anorm=normalize(mdl.a);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function x1 = get.x1(mdl)
            x1=mdl.phcos(mdl.idx1,1);
        end
        
        function v1 = get.v1(mdl)
            v1=[0;diff(mdl.x1)./diff(mdl.t(mdl.idx1))];
        end
        
        function a1 = get.a1(mdl)
            a1=[0;diff(mdl.v1)./diff(mdl.t(mdl.idx1))];
        end
        
        function xnorm1 = get.xnorm1(mdl)
            xnorm1=normalize(mdl.x1);
        end
        
        function vnorm1 = get.vnorm1(mdl)
            vnorm1=normalize(mdl.v1);
        end
        
        function anorm1 = get.anorm1(mdl)
            anorm1=normalize(mdl.a1);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function x2 = get.x2(mdl)
            x2=mdl.phcos(mdl.idx2,2);
        end
        
        function v2 = get.v2(mdl)
            v2=[0;diff(mdl.x2)./diff(mdl.t(mdl.idx2))];
        end
        
        function a2 = get.a2(mdl)
            a2=[0;diff(mdl.v2)./diff(mdl.t(mdl.idx2))];
        end
        
        function xnorm2 = get.xnorm2(mdl)
            xnorm2=normalize(mdl.x2);
        end
        
        function vnorm2 = get.vnorm2(mdl)
            vnorm2=normalize(mdl.v2);
        end
        
        function anorm2 = get.anorm2(mdl)
            anorm2=normalize(mdl.a2);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Kinematic ts-based histograms
        function x_hist = get.x_hist(mdl)
            x_hist = get_ts_histogram(mdl.x,mdl.xpeaks,mdl.conf.bins);
        end
        
        function v_hist = get.v_hist(mdl)
            v_hist = get_ts_histogram(mdl.v,mdl.xpeaks,mdl.conf.bins);
        end
        
        function a_hist = get.a_hist(mdl)
            a_hist = get_ts_histogram(mdl.a,mdl.xpeaks,mdl.conf.bins);
        end

        function xnorm_hist = get.xnorm_hist(mdl)
            xnorm_hist = normalize(get_ts_histogram(mdl.x,mdl.xpeaks,mdl.conf.bins));
        end
        
        function vnorm_hist = get.vnorm_hist(mdl)
            vnorm_hist = normalize(get_ts_histogram(mdl.v,mdl.xpeaks,mdl.conf.bins));
        end
        
        function anorm_hist = get.anorm_hist(mdl)
            anorm_hist = normalize(get_ts_histogram(mdl.a,mdl.xpeaks,mdl.conf.bins));
        end        
        
        function ph_hist=get.ph_hist(mdl)
            ph_hist=get_ts_histogram(mdl.phmod,mdl.xpeaks,mdl.conf.bins,1);
        end
        
        function omega_hist=get.omega_hist(mdl)
            omega_hist=get_ts_histogram(mdl.phdot,mdl.xpeaks,mdl.conf.bins);
        end
        
        function omeganorm_hist=get.omeganorm_hist(mdl)
            omeganorm_hist=normalize(get_ts_histogram(mdl.phdot,mdl.xpeaks,mdl.conf.bins));
        end
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        function x1_hist = get.x1_hist(mdl)
            x1_hist = get_ts_histogram(mdl.x1,mdl.x1peaks,mdl.conf.bins);
        end
        
        function v1_hist = get.v1_hist(mdl)
            v1_hist = get_ts_histogram(mdl.v1,mdl.x1peaks,mdl.conf.bins);
        end
        
        function a1_hist = get.a1_hist(mdl)
            a1_hist = get_ts_histogram(mdl.a1,mdl.x1peaks,mdl.conf.bins);
        end

        function xnorm1_hist = get.xnorm1_hist(mdl)
            xnorm1_hist = normalize(get_ts_histogram(mdl.x1,mdl.x1peaks,mdl.conf.bins));
        end
        
        function vnorm1_hist = get.vnorm1_hist(mdl)
            vnorm1_hist = normalize(get_ts_histogram(mdl.v1,mdl.x1peaks,mdl.conf.bins));
        end
        
        function anorm1_hist = get.anorm1_hist(mdl)
            anorm1_hist = normalize(get_ts_histogram(mdl.a1,mdl.x1peaks,mdl.conf.bins));
        end        
        
        function ph1_hist=get.ph1_hist(mdl)
            ph1_hist=get_ts_histogram(mdl.phmod(:,1),mdl.x1peaks,mdl.conf.bins,1);
        end
        
        function omega1_hist=get.omega1_hist(mdl)
            omega1_hist=get_ts_histogram(mdl.phdot(:,1),mdl.x1peaks,mdl.conf.bins);
        end
        
        function omeganorm1_hist=get.omeganorm1_hist(mdl)
            omeganorm1_hist=normalize(get_ts_histogram(mdl.phdot(:,1),mdl.x1peaks,mdl.conf.bins));
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function x2_hist = get.x2_hist(mdl)
            x2_hist = get_ts_histogram(mdl.x2,mdl.x2peaks,mdl.conf.bins);
        end
        
        function v2_hist = get.v2_hist(mdl)
            v2_hist = get_ts_histogram(mdl.v2,mdl.x2peaks,mdl.conf.bins);
        end
        
        function a2_hist = get.a2_hist(mdl)
            a2_hist = get_ts_histogram(mdl.a2,mdl.x2peaks,mdl.conf.bins);
        end

        function xnorm2_hist = get.xnorm2_hist(mdl)
            xnorm2_hist = normalize(get_ts_histogram(mdl.x2,mdl.x2peaks,mdl.conf.bins));
        end
        
        function vnorm2_hist = get.vnorm2_hist(mdl)
            vnorm2_hist = normalize(get_ts_histogram(mdl.v2,mdl.x2peaks,mdl.conf.bins));
        end
        
        function anorm2_hist = get.anorm2_hist(mdl)
            anorm2_hist = normalize(get_ts_histogram(mdl.a2,mdl.x2peaks,mdl.conf.bins));
        end        
        
        function ph2_hist=get.ph2_hist(mdl)
            ph2_hist=get_ts_histogram(mdl.phmod(:,2),mdl.x2peaks,mdl.conf.bins,1);
        end
        
        function omega2_hist=get.omega2_hist(mdl)
            omega2_hist=get_ts_histogram(mdl.phdot(:,2),mdl.xpeaks,mdl.conf.bins);
        end
        
        function omeganorm2_hist=get.omeganorm2_hist(mdl)
            omeganorm2_hist=normalize(get_ts_histogram(mdl.phdot(:,2),mdl.x2peaks,mdl.conf.bins));
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Kinematic ph-based histograms
        function x_phhist = get.x_phhist(mdl)
            x_phhist=get_ph_histogram(mdl.x,mdl.phmod(mdl.idx),mdl.conf.bins);
        end
        
        function v_phhist = get.v_phhist(mdl)
            v_phhist=get_ph_histogram(mdl.v,mdl.phmod(mdl.idx),mdl.conf.bins);
        end

        function a_phhist = get.a_phhist(mdl)
            a_phhist=get_ph_histogram(mdl.a,mdl.phmod(mdl.idx),mdl.conf.bins);
        end
        
        function x_phhist = get.xnorm_phhist(mdl)
            x_phhist=get_ph_histogram(mdl.xnorm,mdl.phmod(mdl.idx),mdl.conf.bins);
        end
        
        function vnorm_phhist = get.vnorm_phhist(mdl)
            vnorm_phhist=normalize(get_ph_histogram(mdl.v,mdl.phmod(mdl.idx),mdl.conf.bins));
        end

        function anorm_phhist = get.anorm_phhist(mdl)
            anorm_phhist=normalize(get_ph_histogram(mdl.a,mdl.phmod(mdl.idx),mdl.conf.bins));
        end        
        
        function ph_phhist=get.ph_phhist(mdl)
            %ph_phhist=get_ph_histogram(mdl.phmod,mdl.phpeaks,mdl.conf.bins,1);
            ph_phhist=linspace(-pi,pi,mdl.conf.bins)';
        end
        
        function omega_phhist=get.omega_phhist(mdl)
            omega_phhist=get_ph_histogram(mdl.phdot,mdl.phmod(mdl.idx),mdl.conf.bins);
        end        
        
        function omeganorm_phhist=get.omeganorm_phhist(mdl)
            omeganorm_phhist=normalize(get_ph_histogram(mdl.phdot,mdl.phmod,mdl.conf.bins));
        end
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function x1_phhist = get.x1_phhist(mdl)
            x1_phhist=get_ph_histogram(mdl.x1,mdl.phmod(mdl.idx1,1),mdl.conf.bins);
        end
        
        function v1_phhist = get.v1_phhist(mdl)
            v1_phhist=get_ph_histogram(mdl.v1,mdl.phmod(mdl.idx1,1),mdl.conf.bins);
        end

        function a1_phhist = get.a1_phhist(mdl)
            a1_phhist=get_ph_histogram(mdl.a1,mdl.phmod(mdl.idx1,1),mdl.conf.bins);
        end
        
        function xnorm1_phhist = get.xnorm1_phhist(mdl)
            xnorm1_phhist=normalize(get_ph_histogram(mdl.x1,mdl.phmod(mdl.idx1,1),mdl.conf.bins));
        end
        
        function vnorm1_phhist = get.vnorm1_phhist(mdl)
            vnorm1_phhist=normalize(get_ph_histogram(mdl.v1,mdl.phmod(mdl.idx1,1),mdl.conf.bins));
        end

        function anorm1_phhist = get.anorm1_phhist(mdl)
            anorm1_phhist=normalize(get_ph_histogram(mdl.a1,mdl.phmod(mdl.idx1,1),mdl.conf.bins));
        end        
        
        function ph1_phhist=get.ph1_phhist(mdl)
            %ph_phhist=get_ph_histogram(mdl.phmod,mdl.phpeaks,mdl.conf.bins,1);
            ph1_phhist=linspace(-pi,pi,mdl.conf.bins)';
        end
        
        function omega1_phhist=get.omega1_phhist(mdl)
            omega1_phhist=get_ph_histogram(mdl.phdot(:,1),mdl.phmod(mdl.idx1,1),mdl.conf.bins);
        end        
        
        function omeganorm1_phhist=get.omeganorm1_phhist(mdl)
            omeganorm1_phhist=normalize(get_ph_histogram(mdl.phdot(:,1),mdl.phmod(:,1),mdl.conf.bins));
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function x2_phhist = get.x2_phhist(mdl)
            x2_phhist=get_ph_histogram(mdl.x2,mdl.phmod(mdl.idx2,2),mdl.conf.bins);
        end
        
        function v2_phhist = get.v2_phhist(mdl)
            v2_phhist=get_ph_histogram(mdl.v2,mdl.phmod(mdl.idx2,2),mdl.conf.bins);
        end

        function a2_phhist = get.a2_phhist(mdl)
            a2_phhist=get_ph_histogram(mdl.a2,mdl.phmod(mdl.idx2,2),mdl.conf.bins);
        end
        
        function xnorm2_phhist = get.xnorm2_phhist(mdl)
            xnorm2_phhist=normalize(get_ph_histogram(mdl.x2,mdl.phmod(mdl.idx2,2),mdl.conf.bins));
        end
        
        function vnorm2_phhist = get.vnorm2_phhist(mdl)
            vnorm2_phhist=normalize(get_ph_histogram(mdl.v2,mdl.phmod(mdl.idx2,2),mdl.conf.bins));
        end

        function anorm2_phhist = get.anorm2_phhist(mdl)
            anorm2_phhist=normalize(get_ph_histogram(mdl.a2,mdl.phmod(mdl.idx2,2),mdl.conf.bins));
        end        
        
        function ph2_phhist=get.ph2_phhist(mdl)
            %ph_phhist=get_ph_histogram(mdl.phmod,mdl.phpeaks,mdl.conf.bins,1);
            ph2_phhist=linspace(-pi,pi,mdl.conf.bins)';
        end
        
        function omega2_phhist=get.omega2_phhist(mdl)
            omega2_phhist=get_ph_histogram(mdl.phdot(:,2),mdl.phmod(mdl.idx2,2),mdl.conf.bins);
        end        
        
        function omeganorm2_phhist=get.omeganorm2_phhist(mdl)
            omeganorm2_phhist=normalize(get_ph_histogram(mdl.phdot(:,2),mdl.phmod(:,2),mdl.conf.bins));
        end        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Vector Fields, potentials and nullcline getters
        
        function vf = get.vf(mdl)
            if mdl.stype <2
                PH=mdl.vfrange;
                dPH=mdl.vf_(PH,mdl.params{:});
                vf={PH,dPH};
            else
                [PH1,PH2]=meshgrid(mdl.vfrange{1},mdl.vfrange{2});
                dPH1=mdl.vf_(PH1,PH2,mdl.params{[1,3:end]});
                dPH2=mdl.vf_(PH2,PH1,mdl.params{2:end});
                vf={PH1,PH2,dPH1,dPH2};
            end            
        end
        
        function vfcart = get.vfcart(mdl)
            if isempty(mdl.t)
                %mdl.run;
                %disp('need to run simulation first');
                vfcart={[],[],[],[]};
            elseif mdl.stype < 2
                values=-1:0.05:1;
                idx_vp=zeros(size(values));
                idx_vn=zeros(size(values));
                %get min to divide two signs of velocity
                
                [maxt, mint]=peakdet(mdl.xnorm_hist,0.1);
                if isempty(mint)
                    m=maxt(1);
                else
                    m=mint(1);
                end
                for i=1:length(values)                    
                    %Find matching idx
                    ip=abs(mdl.xnorm_hist-values(i))<0.2;
                    in=ip;
                    in(1:m)=0;
                    ip(m:end)=0;
                    vp=find(ip);
                    vn=find(in);
                    idx_vp(i)=min(vp);
                    idx_vn(i)=min(vn);
                end
                i=[idx_vn,idx_vp];
                vfcart={mdl.xnorm_hist(i),mdl.vnorm_hist(i),mdl.vnorm_hist(i),mdl.anorm_hist(i)};
            else
                vfcart={[],[],[],[]};
            end
        end
        
        function potencial = get.potencial(mdl)
            if mdl.stype < 2
                PH=mdl.vfrange;
                potencial=mdl.potencial_(PH,mdl.params{:});
            else
                potencial={[],[]};
%                 [PH1,PH2]=meshgrid(mdl.vfrange{1},mdl.vfrange{2});
%                 dPH1=mdl.vf_(PH1,PH2,mdl.params{[1,3:end]});
%                 dPH2=mdl.vf_(PH2,PH1,mdl.params{2:end});
%                 vf={PH1,PH2,dPH1,dPH2};
            end
        end
        
        function ph1nc = get.ph1nc(mdl)
            per_no=length(mdl.ph_periods);
            phr_no=length(mdl.ncrange{1});
            if mdl.stype <2
                ph1nc=[];
            else
                ph1nc=zeros(2,2*phr_no*per_no);
                for n=1:length(mdl.ph_periods)
                    v=mdl.ph_periods(n);
                    i=1+2*(n-1)*phr_no;
                    ph1nc(1,i:i+phr_no-1)=mdl.ncrange{1};
                    ph1nc(2,i:i+phr_no-1)=mdl.nc1(mdl.ncrange{1},mdl.params{[1,3:end]},v);
                    i=i+phr_no+1;
                    ph1nc(1,i:i+phr_no-1)=mdl.ncrange{1};
                    ph1nc(2,i:i+phr_no-1)=mdl.nc2(mdl.ncrange{1},mdl.params{[1,3:end]},v);
                end
                ph1nc(imag(ph1nc) ~= 0)=NaN;
            end
        end
        
        function ph2nc = get.ph2nc(mdl)
            per_no=length(mdl.ph_periods);
            phr_no=length(mdl.ncrange{2});
            if mdl.stype <2
                ph2nc=[];
            else
                ph2nc=zeros(2,2*phr_no*per_no);
                for n=1:length(mdl.ph_periods)
                    v=mdl.ph_periods(n);
                    i=1+2*(n-1)*phr_no;
                    ph2nc(1,i:i+phr_no-1)=mdl.ncrange{2};
                    ph2nc(2,i:i+phr_no-1)=mdl.nc1(mdl.ncrange{2},mdl.params{2:end},v);
                    i=i+phr_no+1;
                    ph2nc(1,i:i+phr_no-1)=mdl.ncrange{2};
                    ph2nc(2,i:i+phr_no-1)=mdl.nc2(mdl.ncrange{2},mdl.params{2:end},v);
                end
                ph2nc(imag(ph2nc) ~= 0)=NaN;
            end   
        end   
        
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function flsPC = get.flsPC(obj)
           if obj.stype<2
               flsPC=[];
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
           if obj.stype<2
               flsAmp = [];
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
           if obj.stype<2
               phDiff=[];
           else
               %phDiff = obj.q*obj.Lph-obj.p*obj.Rph;
               phDiff= obj.q*obj.ph(:,1)-obj.p*obj.ph(:,2);
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function phDiffMean = get.phDiffMean(obj)
           if obj.stype<2
               phDiffMean=[];
           else
               %[phDiffMean,~]=circstat(obj.p_MI*obj.Lph-obj.q_MI*obj.Rph);
               [phDiffMean,~]=circstat(obj.phDiff);
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function phDiffStd = get.phDiffStd(obj)
           if obj.stype<2
               phDiffStd=[];
           else
               %[~, phDiffStd]=circstat(obj.p_MI*obj.Lph-obj.q_MI*obj.Rph);
               [~, phDiffStd]=circstat(obj.phDiff);
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function rho = get.rho(obj)
           if obj.stype<2
               rho=[];
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
        function f = get.f(obj)
           if obj.stype<2
               f=[];
           else
               [Pxx,freq] = get_welch_periodogram(obj.xnorm,obj.fs);
               f=freq(Pxx==max(Pxx));
           end
        end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function f1 = get.f1(obj)
           if obj.stype<2
               f1=[];
           else
               [Pxx1,freq1] = get_welch_periodogram(obj.xnorm1,obj.fs);
               f1=freq1(Pxx1==max(Pxx1));
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function f2 = get.f2(obj)
           if obj.stype<2
               f2=[];
           else
               [Pxx2,freq2] = get_welch_periodogram(obj.xnorm2,obj.fs);
               f2=freq2(Pxx2==max(Pxx2));
           end
       end

       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function Pxx = get.Pxx(obj)
           if obj.stype>=2
               Pxx=[];
           else
               [Pxx,~] = get_welch_periodogram(obj.xnorm,obj.fs);
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function Pxx1 = get.Pxx1(obj)
           if obj.stype<2
               Pxx1=[];
           else
               [Pxx1,~] = get_welch_periodogram(obj.xnorm1,obj.fs);
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function Pxx2 = get.Pxx2(obj)
           if obj.stype<2
               Pxx2=[];
           else
               [Pxx2,~] = get_welch_periodogram(obj.xnorm2,obj.fs);
           end
       end
            
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function freq = get.freq(obj)
           if obj.stype<2
               [~,freq] = get_welch_periodogram(obj.xnorm,obj.fs);
           else
               [~,freq]=get_welch_periodogram(obj.xnorm1,obj.fs);
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function p = get.p(obj)
           if obj.stype<2
               p=obj.p_;
           else
               [p,~]=obj.get_p_q();
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function q = get.q(obj)
           if obj.stype<2
               q=obj.q_;
           else
               [~,q]=obj.get_p_q();
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function [p,q]=get_p_q(obj)
           if obj.stype<2, p=[];q=[];return; end
           
           Lf=obj.f1;
           Rf=obj.f2;
           if abs(1-Lf/Rf)<0.05
               q=1;p=1;
           elseif Lf>Rf
               if abs(1.5-Lf/Rf)<0.075
                   p=3; q=2;
               elseif abs(2-Lf/Rf)<0.1
                   p=2; q=1;
               elseif abs(2.5-Lf/Rf)<0.125
                   p=5; q=2;
               elseif abs(3-Lf/Rf)<0.15
                   p=3; q=1;
               elseif abs(3.5-Lf/Rf)<0.175
                   p=7; q=2;
               elseif abs(4-Lf/Rf)<0.2
                   p=7; q=2;
               elseif abs(4.5-Lf/Rf)<0.225
                   p=9; q=2;
               elseif abs(5-Lf/Rf)<0.25
                   p=5; q=1;
               else
                   [p,q]=rat(Lf/Rf);
               end
           else
               if abs(1.5-Rf/Lf)<0.075
                   q=3; p=2;
               elseif abs(2-Rf/Lf)<0.1
                   q=2; p=1;
               elseif abs(2.5-Rf/Lf)<0.125
                   q=5; p=2;
               elseif abs(3-Rf/Lf)<0.15
                   q=3; p=1;
               elseif abs(3.5-Rf/Lf)<0.175
                   q=7; p=2;
               elseif abs(4-Rf/Lf)<0.2
                   q=7; p=2;
               elseif abs(4.5-Rf/Lf)<0.225
                   q=9; p=2;
               elseif abs(5-Rf/Lf)<0.25
                   q=5; p=1;
               else
                   [q,p]=rat(Rf/Lf);
               end
               
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function SlowPxx = get.SlowPxx(obj)
           if obj.stype<2
               SlowPxx=obj.SlowPxx_;
           else
               if obj.f1 > obj.f2
                   SlowPxx=obj.Pxx2;
               else
                   SlowPxx=obj.Pxx1;
               end
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function FastPxx = get.FastPxx(obj)
           if obj.stype<2
               FastPxx=obj.FastPxx_;
           else
               if obj.f1 > obj.f2
                   FastPxx=obj.Pxx1;
               else
                   FastPxx=obj.Pxx2;
               end
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function SlowPxx_t = get.SlowPxx_t(obj)
           if obj.stype<2
               SlowPxx_t=obj.SlowPxx_t_;
           else
               SlowPxx_t = get_scaled_PSD(obj.SlowPxx,obj.freq,obj.rho);
           end
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function FastPxx_t = get.FastPxx_t(obj)
           if obj.stype<2
               FastPxx_t=[];
           else
               FastPxx=obj.FastPxx;
               FastPxx_t = FastPxx / obj.freq(FastPxx==max(FastPxx));
           end
       end       
    end
end
