#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-

import os, sys, subprocess
from multiprocessing import Pool

#GLOBALS
MAIN_DIR   = "/home/jorge/Dropbox/dev/Bimanual-Fitts"
PYTHON_DIR = os.path.join(MAIN_DIR,"python")
BATCH_DIR  = os.path.join(PYTHON_DIR,"batch")
if not os.path.exists(BATCH_DIR):
    os.makedirs(BATCH_DIR)


WRKs=2
PPs=range(1,11)
#PPs=[2,5]
PPno=len(PPs)

TEMPLATE_FULL,\
TEMPLATE_FULL2,\
TEMPLATE_MODEL,\
TEMPLATE_LOAD_SAVE,\
TEMPLATE_LOAD_SAVE_PLOT,\
TEMPLATE_GET_DATA,\
TEMPLATE_ANALYSIS,\
TEMPLATE_UPDATE_LS,\
TEMPLATE_PLOT_ANALYSIS,\
TEMPLATE_PLOT_ANGULAR,\
TEMPLATE_PLOT, \
TEMPLATE_PLOT_VF,\
TEMPLATE_PLOT_MODELPH= range(13)

template=TEMPLATE_GET_DATA
def write_scripts(pp):    
    #Open file to write script
    filename="pp%03d.m" % pp
    filepath=os.path.join(BATCH_DIR,filename)
    f=open(filepath,'w')
    
    #Write text to file and close
    f.write(get_script_from_template(template,pp))
    f.close()
    return "sleep %d; nohup /opt/matlab2012/bin/matlab -nodesktop -nosplash -r %s > /home/jorge/%03d.out" % (pp,filename[:-2],pp)

def get_script_from_template(tpl,pp):
    if tpl==TEMPLATE_FULL:
        msg="""\
        conf=Config();
        conf.parallelMode=0;
        p=Participant(%d,conf);
        save(p); 
        ds=DataSets(p); save(ds);
        exit""" % pp    
    elif tpl==TEMPLATE_FULL2:
        msg="""\
        conf=Config();
        conf.parallelMode=0;
        p=Participant(%d,conf);
        p.save(); 
        obj = get_pp_data(p);
        save(joinpath(conf.save_path,'pp%02d_data.mat'),'obj'); exit""" % (pp,pp) 
    elif tpl==TEMPLATE_MODEL:
        msg="""\
        conf=Config();
        p=Participant(%d);
        [resB,resR,resL]=fitpp(p);        
        save(joinpath(conf.save_path,'pp%02d_modelresults.mat'),'resR','resL','resB'); exit""" % (pp,pp)         
    elif tpl==TEMPLATE_LOAD_SAVE:
        msg="""\
        conf=Config();
        conf.parallelMode=0;
        p=Participant(%d,conf);
        p.save(); exit""" % pp        
    elif tpl==TEMPLATE_LOAD_SAVE_PLOT:
        msg="""\
        conf=Config();
        conf.parallelMode=0;
        p=Participant(%d,conf);
        p.save(); p.plot(); exit""" % pp        
    elif tpl==TEMPLATE_GET_DATA:
        msg="""\
        RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));
        conf=Config();
        conf.parallelMode=0;
        p=Participant(%d,conf);         
        ds=DataSets(p); save(ds);exit""" % pp
    elif tpl==TEMPLATE_ANALYSIS:
        msg="""\
        an=Analysis(%d);
        an.save(%d);
        exit""" % (pp,pp)
    elif tpl==TEMPLATE_UPDATE_LS:
        msg="""\
        p=Participant(%d);
        p.update_ls();
        p.save();
        exit""" % pp
            
    elif tpl==TEMPLATE_PLOT_ANALYSIS:
        msg="""\
        conf=Config();
        conf.parallelMode=0;
        p=Participant.load(%d,conf);
        p.plot();
        an=Analysis(p,conf);
        an.save(%d);
        exit""" % (pp,pp)
    elif tpl==TEMPLATE_PLOT_ANGULAR:
        msg="""\
        conf=Config();
        conf.parallelMode=0;
        p=Participant(%d,conf);
        p.plot_angphsp()    
        p.plot_angvar('ph');
        p.plot_angvar('omega');
        p.plot_angvar('alpha');
        p.plot_angvar('xnorm');
        p.plot_angvar('vnorm');
        p.plot_angvar('anorm');
        p,plot_angvar('jerknorm')
        exit""" % pp
    elif tpl==TEMPLATE_PLOT:
        msg="""\
        conf=Config();
        conf.parallelMode=0;
        p=Participant(%d,conf);
        p.plot();exit""" % pp
    elif tpl==TEMPLATE_PLOT_VF:
        msg="""\
        conf=Config();
        conf.parallelMode=0;
        p=Participant.load(%d,conf);
        p.plot_va();exit""" % pp
    elif tpl==TEMPLATE_PLOT_MODELPH:
        msg="""\
        cd Dropbox
        load f5
        sims=simulamil(f5_tr%d,15);
        save('sims%d','sims');
        exit""" % (pp,pp)        
    else:
        return "Wrong template type"
    return msg
    
if __name__ == '__main__':
    
    if sys.version_info[1] <= 6 or sys.version_info[0] == 3: 
        pool=Pool(processes=WRKs)
    else:
        pool=Pool(processes=WRKs,maxtasksperchild=1)
        
    pool.map(os.system, map(write_scripts,PPs), round(PPno/WRKs) )
    pool.terminate()
    pool.join()
    sys.exit()
