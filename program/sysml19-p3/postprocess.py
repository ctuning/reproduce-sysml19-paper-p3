#
# Postprocessing and unifying output from AggregaThor
#
# Developers:
#   - Grigori Fursin, cTuning foundation / dividiti, 2019
#

import json
import os
import re
import sys

def ck_postprocess(i):
    ck=i['ck_kernel']

    rt=i['run_time']
    deps=i['deps']

    d={}

    env=i.get('env',{})

    rf1=rt.get('run_cmd_out1','') # stdout
    rf2=rt.get('run_cmd_out2','') # stderr

    lst=[]

    if os.path.isfile(rf2):
       r=ck.load_text_file({'text_file':rf1,'split_to_list':'yes'})
       if r['return']>0: return r
       lst+=r['lst']

    # Finding and unifying different characteristics
    vars=[{"text":"speed:", "key":"speed"},
          {"text":" accuracy=", "key":"accuracy"},
          {"text":"Train-accuracy=", "key":"train-accuracy"},
          {"text":"Time cost=", "key":"time-cost"},
          {"text":"Total arg_params size =", "key":"total-size"},
          {"text":"Validation-accuracy=", "key":"validation-accuracy"}]
    for q in lst:
        for v in vars:
            t=v['text']
            k=v['key']

            j=q.find(t)
            if j>=0:
               j1=q.find(" ",j+len(t))
               j2=len(q)
               j3=min(j1,j2)

               d[k]=q[j1+len(t):j2]

               d['post_processed']='yes'

    # Embedding to the CK pipeline

    rr={}
    rr['return']=0
    if d.get('post_processed','')=='yes':
        ck.out('  Success!)')
        # Save to file.
        r=ck.save_json_to_file({'json_file':'tmp-ck-timer.json', 'dict':d})
        if r['return']>0: return r
    else:
        rr['return']=1
        rr['error']='failed to post-process results - some key strings are not found'

    return rr

# Do not add anything here!
