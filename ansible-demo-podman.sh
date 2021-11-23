#!/bin/bash


podman run --name=jbcs-0     --systemd=true  --workdir /work -v $(pwd):/work:rw  -dit localhost/ubi8/ubi-ansible-3trains-demo:latest /sbin/init
podman run --name=jdg-0      --systemd=true  --workdir /work -v $(pwd):/work:rw  -dit localhost/ubi8/ubi-ansible-3trains-demo:latest /sbin/init
podman run --name=keycloak-0 --systemd=true  --workdir /work -v $(pwd):/work:rw  -dit localhost/ubi8/ubi-ansible-3trains-demo:latest /sbin/init
podman run --name=pgsql-0    --systemd=true  --workdir /work -v $(pwd):/work:rw  -dit localhost/ubi8/ubi-ansible-3trains-demo:latest /sbin/init
podman run --name=wfly-1     --systemd=true  --workdir /work -v $(pwd):/work:rw  -dit localhost/ubi8/ubi-ansible-3trains-demo:latest /sbin/init
podman run --name=wfly-2     --systemd=true  --workdir /work -v $(pwd):/work:rw  -dit localhost/ubi8/ubi-ansible-3trains-demo:latest /sbin/init
podman run --name=wfly-3     --systemd=true  --workdir /work -v $(pwd):/work:rw  -dit localhost/ubi8/ubi-ansible-3trains-demo:latest /sbin/init
#ANSIBLE_CONFIG=ansible.cfg-podman ansible-playbook -e rhn_username="'"${RHN_USERNAME}"'" -e rhn_password="'"${RHN_PASSWORD}"'" -i inventory/demo playbooks/demo.yml  -vv
ANSIBLE_CONFIG=ansible-podman.cfg ansible-playbook -e @rhn-creds.yml -i inventory/demo playbooks/demo.yml "$@"


