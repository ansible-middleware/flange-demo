Three trains in the night...
====

This Ansible playbooks demonstrate how to set up a 3 nodes [Wildfly](https://wildfly.org/) cluster, on a single machine, using Ansible and the [JCliff Ansible collection](https://github.com/wildfly-extras/ansible_collections_jcliff). On top of a fully functionnal cluster, each server will be have the appropriate JDBC driver installed for PostrgeSQL and each instance will be configured to connect to the local PostgreSQL database (also set up by the playbook).

This set-up is higly dependend on Systemd as this software is used to manage all services (Wildfly and Postgresql).

 Note that currently it is a work in progress, the playbooks is not fully functionnal (yet)!

Set up
====

First of all, you'll need to install the [JCliff Ansible collection](https://github.com/wildfly-extras/ansible_collections_jcliff). Clone the project and run the following command line:

    $ cd ansible_collections_jcliff/
    $ ansible-collection build .

This will produce a zipfile named redhat-jcliff-1.0.0.tgz. Install this new module for Ansible on the system running the automation tool:

    $ ansible-galaxy collection install path/to/redhat-jcliff-1.0.0.tgz.

That's all! You can now run the playbook to set up the demo :

    $ ansible-playbook playbook.yml

What the end results of this demo?
====

After a successful run of the provided playbook.yml, here what you should have on the targeted systems :

+-----------------------------------------------------------------------------------------------------+
|                                                                                       Host          |
|                                                                                                     |
|                                  Wildfly Application                                                |
|                                                                                                     |
|                                        Servers                          +---------------------------+------+
|                                                                         |Notes:                            |
|                              +------------------+                       |All services are ran by systemd   |
|                              |                  |                       |Wildfly is only installed once    |
|             HTTP             |                  |                       |                                  |
|      +-----------------------+      wlfy-1      +---------+             +---------------------------+------+
|      |                       |                  |         |                                         |
|      |                       |                  |         |                                         |
|      |                       +--------+---------+         |                                         |
|      |                                |                   |                                         |
|      |                                |                   |                                         |
|      |                 JGroups Clustering                 |                                         |
|      |                                |                   |                                         |
|      |                      +---------+---------+         |       +------------------------+        |
|      |                      |                   |         |       |                        |        |
|      |      HTTP            |                   |         |       |                        |        |
|      +----------------------+       wfly-2      +-----------------+   PostgreSQL Db        |        |
|      |                      |                   |         | SQL   |                        |        |
|      |                      |                   |         |       |                        |        |
|      |                      +---------+---------+         |       +------------------------+        |
|      |                                |                   |                                         |
|      |                                |                   |                                         |
|      |                                |                   |                                         |
|      |                      +---------+----------+        |                                         |
|      |                      |                    |        |                                         |
|      |                      |                    |        |                                         |
|      +----------------------+       wfly-3       +--------+                                         |
|                             |                    |                                                  |
|                             |                    |                                                  |
|                             +--------------------+                                                  |
|                                                                                                     |
|                                                                                                     |
|                                                                                                     |
+-----------------------------------------------------------------------------------------------------+

(diagram produced thanks to [http://asciiflow.com/](http://asciiflow.com/) )
