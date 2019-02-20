#
# Preprocessing cluster configuration
#
# Developers:
# - Grigori Fursin, cTuning foundation, 2019
#

import json
import os
import re

def ck_preprocess(i):

    ck=i['ck_kernel']
    rt=i['run_time']
    deps=i['deps']

    env=i['env']
    nenv={} # new environment to be added to the run script

    hosd=i['host_os_dict']
    tosd=i['target_os_dict']
    remote=tosd.get('remote','')

    cmd_key=i.get('misc',{}).get('cmd_key','')

    device_cfg=i.get('device_cfg','') # description of your machine selected via --target=...

    nodes=device_cfg.get('remote_params',{}).get('cluster_config',[])

    if len(nodes)==0:
       return {'return':1, 'error':'nodes for your cluster are not defined. Use "ck add machine:{some name} --type=cluster'}

    # Prepare text file with hosts
    s=''
    for n in nodes:
        s+=n+'\n'

    r=ck.save_text_file({'text_file':'hosts','string':s})
    if r['return']>0: return r

    nenv['NUMBER_OF_NODES']=len(nodes)

    return {'return':0, 'new_env':nenv}

# Do not add anything here!
