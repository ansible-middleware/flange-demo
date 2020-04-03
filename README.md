Three trains in the night...
====

This Ansible playbooks demonstrate how to set up a 3 nodes [Wildfly](https://wildfly.org/) cluster, on a single machine, using Ansible and the [JCliff Ansible collection](https://github.com/wildfly-extras/ansible_collections_jcliff). Note that currently it is a work in progress, the playbooks is not fully functionnal (yet)!

Set up
====

First of all, you'll need to install the [JCliff Ansible collection](https://github.com/wildfly-extras/ansible_collections_jcliff). Clone the project and run the following command line:

    $ cd ansible_collections_jcliff/
    $ ansible-collection build .

This will produce a zipfile named redhat-jcliff-1.0.0.tgz. Install this new module for Ansible on the system running the automation tool:

    $ ansible-galaxy collection install path/to/redhat-jcliff-1.0.0.tgz.

That's all! You can now run the playbook to set up the demo :

    $ ansible-playbook playbook.yml
