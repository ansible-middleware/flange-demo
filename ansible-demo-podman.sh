#!/bin/bash

# create dnsname enabled podman network
# podman network create flange
# { "capabilities": { "aliases": true }, "domainName": "dns.podman", "type": "dnsname" }
# make sure the podman host doesn't override dns in /etc/hosts for guests
while read node ; do
    echo -n "Starting container ${node}.... "
    podman run --name=${node} --network flange --systemd=true  --workdir /work -v $(pwd):/work:rw  -d localhost/ubi8/ubi-ansible-flange-demo:latest /sbin/init
done < <( ansible-inventory -i inventory/demo --list | jq -r ".[].hosts|select(length > 0)|.[]")
podman network reload --all 2>&1 >/dev/null
ANSIBLE_CONFIG=podman/ansible-podman.cfg ansible-playbook -e @rhn-creds.yml -i inventory/demo playbooks/demo.yml "$@"
