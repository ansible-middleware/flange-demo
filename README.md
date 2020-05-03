Three trains in the night...
====

This repository contains a set of Ansible based roles and playbooks to demonstrate the integration between a [Wildfly](https://wildfly.org/) cluster with an application deployed and secured using [Keycloak](https://www.keycloak.org/) and built using [JCliff Ansible collection](https://github.com/wildfly-extras/ansible_collections_jcliff). Note that currently it is a work in progress, the playbooks is not fully functional (yet)!

## Set up

The following sections describe the steps necessary to prepare your machine for execution

### JCliff Integration

First of all, you'll need to install the [JCliff Ansible collection](https://github.com/wildfly-extras/ansible_collections_jcliff). Clone the project and run the following command line:

    $ cd ansible_collections_jcliff/
    $ ansible-collection build .

This will produce a zipfile named redhat-jcliff-1.0.0.tgz. Install this new module for Ansible on the system running the automation tool:

    $ ansible-galaxy collection install path/to/redhat-jcliff-1.0.0.tgz.

### Ansible Inventory

Ansible groups are used to define the Keycloak and Wildfly instances. Configure these groups in the [hosts](inventory/hosts) file similar to the following:

```
[threetrains]

[wildfly]
192.168.22.4

[keycloak]
192.168.22.5

[threetrains:children]
wildfly
keycloak
```

## Execution

That's all! You can now run the playbook to set up the demo:

    $ ansible-playbook -i inventory/ playbooks/demo.yml
