#!/bin/bash

# /usr/libexec/openafs/sysnames
# Set custom sysnames after starting the afsd service.
# Runs as "ExecStartPost" in openafs-client.service.

# Figure out what we are
_ARCH=`uname -i | sed 's/x86_64/amd64/'`
_KERN=`uname -r | sed 's/\([0-9]\+\)\.\([0-9]\+\)\..*/\1\2/'`
_DIST=""

for d in fedora centos redhat ; do
    if [ -f "/etc/$d-release" ] ; then
        _DIST=$d
        break
    fi
done
