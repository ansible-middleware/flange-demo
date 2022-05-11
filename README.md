Flange-demo: middleware integration
===================================

This repository contains a set of Ansible based roles and playbooks to demonstrate the integration between a [Wildfly](https://wildfly.org/) cluster with an application deployed and secured using [Keycloak](https://www.keycloak.org/) and built using [JCliff Ansible collection](https://github.com/wildfly-extras/ansible_collections_jcliff), and demonstrating integration with postgresql and datagrid. 

## Set up

The following sections describe the steps necessary to prepare your machine for execution

### JCliff Integration

First of all, you'll need to install the collection from middleware_automation and their dependencies:

- [JCliff](https://github.com/middleware_automation/ansible_collections_jcliff)
- [Wildfly](https://github.com/middleware_automation/wildfly)
- [Keycloak](https://github.com/middleware_automation/keycloak)
- [Infinispan](https://github.com/middleware_automation/infinispan)

Install via:

    $ pip install -r requirements.txt
    $ ansible-galaxy collection install -r requirements.yml


### Ansible Inventory

Ansible groups are used to define the Keycloak and Wildfly instances. Configure these groups in the [hosts](inventory/hosts) file similar to the following:

```
[flange]

[wildfly]
192.168.22.4

[keycloak]
192.168.22.5

[flange:children]
wildfly
keycloak
```

## Execution

Create a `rhn-creds.yml` file containing your RHN account credentials, needed to download packages, as follows:

```
rhn_username: '...'
rhn_password: '...'
```

That's all! You can now run the playbook to set up the demo:

    $ ansible-playbook -e @rhn-creds.yml -i inventory/demo playbooks/demo.yml

### Execution in a podman container

This will create a podman container based on ubi8.4, attached to subscription manager during the build phase, and deploy the demo ansible playbook using a local transport.

To create the oci image, use the provided Dockerfile:

```
FROM registry.access.redhat.com/ubi8/ubi

RUN subscription-manager register --username='...' --password='...' --name=ubi8-ansible-4
RUN subscription-manager attach --auto
RUN subscription-manager attach --pool="8a85f98260c27fc50160c323247e39e0"
RUN subscription-manager repos --enable ansible-2.9-for-rhel-8-x86_64-rpms
RUN yum install -y ansible
RUN yum -y install systemd; yum clean all; (cd /lib/systemd/system/sysinit.target.wants/; for i in ; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); rm -f /lib/systemd/system/multi-user.target.wants/; rm -f /etc/systemd/system/.wants/; rm -f /lib/systemd/system/local-fs.target.wants/; rm -f /lib/systemd/system/sockets.target.wants/*udev; rm -f /lib/systemd/system/sockets.target.wants/initctl; rm -f /lib/systemd/system/basic.target.wants/; rm -f /lib/systemd/system/anaconda.target.wants/;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
```

and run:

    $ subscription-manager refresh
    $ podman build -f podman/Dockerfile-podman
    cafebabe
    $ podman tag cafebabe ubi8-ansible:latest

Then running with the provided podrun script:

```
#!/bin/bash

readonly DOCKER_IMAGE=${DOCKER_IMAGE:-'ubi8-ansible'}
readonly DOCKER_NAME=${1:-'demo'}

if [ ! "$(docker ps -q -f name=${DOCKER_NAME})" ]; then
  podman run  -dit --systemd=true --privileged=true  \
       --rm --name "${DOCKER_NAME}" --workdir /work -v $(pwd):/work:rw \
       "${DOCKER_IMAGE}" \
       /sbin/init
fi
podman exec -ti "${DOCKER_NAME}" /bin/bash
```

Now set ansible to work with local connections in ansible.cfg:

```
[defaults]
transport = local
...
```

and are ready to run:

    $ podrun demo
    -> $ ANSIBLE_CONFIG=podman/ansible-local.cfg ansible-playbook -i inventory/demo -e @rhn-creds.yml playbooks/demo.yml


### Execution in multiple podman containers

You'll need rootful podman with podman-plugins for intra-container networking, and execute ansible leveraging the [podman transport](https://docs.ansible.com/ansible/2.9/plugins/connection/podman.html).
The host must be RHEL8.4 with working subscription, dnf in containers will have subscription-manager work in 'container mode', so ensure to enable ansible repository in the host:

    $ subscription-manager repos --enable ansible-2.9-for-rhel-8-x86_64-rpms

Setup ansible.cfg with the following (`interpreter_python` is also important because of this [bug](https://github.com/ansible/ansible/issues/71668)):

```
[defaults]
host_key_checking = False
interpreter_python = auto
transport = podman
remote_user = root
```

Create a pythonized image for containers based on ubi8.4, using the provided Dockerfile:

```
$ podman build -f podman/Dockerfile-podmanbase
505e98b27d0
$ podman tag 505e98b27d0 ubi8/ubi-ansible-flange-demo:latest
```

Make sure the podman network has the dnsname plugin enabled:

```
$ podman network ls
NETWORK ID    NAME        VERSION     PLUGINS
2f259bab93aa  podman      0.4.0       bridge,portmap,firewall,tuning,dnsname
```

Now you can startup the containers, using the [provided script (wip)](ansible-demo-podman.sh), which reads the inventory and names each one accordingly

    $ podman run --name=keycloak-0 --systemd=true  --workdir /work -v $(pwd):/work:rw  -dit localhost/ubi8/ubi-ansible-flange-demo:latest /sbin/init
    [...]

And finally:

    $ ANSIBLE_CONFIG=podman/ansible-podman.cfg ansible-playbook -e @rhn-creds.yml -i inventory/demo playbooks/demo.yml

