#!/usr/bin/env python

"""Script to test the external data provider in Terraform"""

import sys
import json
from subprocess import check_output

    
def read_in():
    """Read input data from terraform"""
    return {x.strip() for x in sys.stdin}

def get_join_cmd(host):
    """
    SSH to a Kubernetes master server and retrive 
    kubeadm join command
    """
    join_cmd = check_output(
        [
            'ssh',
            '-l', 'root',
            host,
            'kubeadm',
            'token',
            'create',
            '--print-join-command',
                        
        ],

    )
    return str(join_cmd).replace('\n', '')

def main():
    lines = read_in()
    for line in lines:
        if line:
            jsondata = json.loads(line)
    
    os_release = get_join_cmd(jsondata['host'])
    jsondata['cmd'] = str(os_release)
    sys.stdout.write(json.dumps(jsondata))


if __name__ == '__main__':
    """
    Execute kubeadm join commnad retrieval
    """
    main()
  

    
    