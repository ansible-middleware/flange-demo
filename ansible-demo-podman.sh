#!/bin/bash

# create dnsname enabled podman network
# podman network create 3trains
# { "capabilities": { "aliases": true }, "domainName": "dns.podman", "type": "dnsname" }
podman network reload --all
podman run --name=jbcs-0     --network 3trains --systemd=true  --workdir /work -v $(pwd):/work:rw  -dit localhost/ubi8/ubi-ansible-3trains-demo:latest /sbin/init
podman run --name=jdg-0      --network 3trains --systemd=true  --workdir /work -v $(pwd):/work:rw  -dit localhost/ubi8/ubi-ansible-3trains-demo:latest /sbin/init
podman run --name=keycloak-0 --network 3trains --systemd=true  --workdir /work -v $(pwd):/work:rw  -dit localhost/ubi8/ubi-ansible-3trains-demo:latest /sbin/init
podman run --name=pgsql-0    --network 3trains --systemd=true  --workdir /work -v $(pwd):/work:rw  -dit localhost/ubi8/ubi-ansible-3trains-demo:latest /sbin/init
podman run --name=wfly-1     --network 3trains --systemd=true  --workdir /work -v $(pwd):/work:rw  -dit localhost/ubi8/ubi-ansible-3trains-demo:latest /sbin/init
podman run --name=wfly-2     --network 3trains --systemd=true  --workdir /work -v $(pwd):/work:rw  -dit localhost/ubi8/ubi-ansible-3trains-demo:latest /sbin/init
podman run --name=wfly-3     --network 3trains --systemd=true  --workdir /work -v $(pwd):/work:rw  -dit localhost/ubi8/ubi-ansible-3trains-demo:latest /sbin/init
ANSIBLE_CONFIG=podman/ansible-podman.cfg ansible-playbook -e @rhn-creds.yml -i inventory/demo playbooks/demo.yml "$@"


