#
# Collective Knowledge (individual environment - setup)
#
# See CK LICENSE.txt for licensing details
# See CK COPYRIGHT.txt for copyright details
#
# Developer: Grigori Fursin, Grigori.Fursin@cTuning.org, http://fursin.net
#

import os

##############################################################################
# customize directories to automatically find and register software

def dirs(i):
    return {'return':0}

##############################################################################
# limit directories 

def limit(i):

    dr=i.get('list',[])
    drx=[]

    for q in dr:
        if q.find('X11')<0:
           drx.append(q)

    return {'return':0, 'list':drx}

##############################################################################
# parse software version

def parse_version(i):

    lst=i['output']

    ver=''

    for q in lst:
        q=q.strip()
        if q!='':
           j=q.lower().find('version ')
           if j>0:
              ver=q[j+8:]
              break

    return {'return':0, 'version':ver}

##############################################################################
# setup environment

def setup(i):

    s=''

    cus=i['customize']
    env=i['env']

    host_d=i.get('host_os_dict',{})

    fp=cus['full_path']
    ep=cus['env_prefix']
 
    p1=os.path.dirname(fp)
    env[ep]=p1

    p1l=os.path.join(p1, 'lib64')
    cus['path_lib']=p1l

    r = ck.access({'action': 'lib_path_export_script', 
                   'module_uoa': 'os', 
                   'host_os_dict': host_d, 
                   'lib_path': p1l})
    if r['return']>0: return r
    s += r['script']

    p2=os.path.dirname(p1)
    p2l=os.path.join(p2,'lib')

    # Need to update for Win/Darwin
    s+='set PYTHONPATH='+p2l+':$PYTHONPATH\n'

    return {'return':0, 'bat':s}
