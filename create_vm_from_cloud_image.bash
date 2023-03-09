#!/bin/bash

export LIBGUESTFS_BACKEND=direct


virt-customize \
-a rocky9.qcow2 \
--hostname rocky9 \
--root-password password:rootpw \
--ssh-inject 'root:file:/root/.ssh/id_rsa.pub' \
--uninstall cloud-init \
--selinux-relabel



virt-install \
--name rocky9 \
--memory 1024 \
--vcpus 1 \
--disk path=/var/lib/libvirt/images/rocky9.qcow2 \
--import \
--os-type linux --os-variant generic \
--noautoconsole

virsh domifaddr rocky9
ip=`virsh domifaddr rocky9 | grep "ipv4" | awk '{ print $4 }' | cut -d'/' -f1`
ssh root@$ip

virsh managedsave rocky9
virsh start rocky9
