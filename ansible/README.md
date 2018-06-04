Some random playbooks and roles
===============================

command_prompt.yml
------------------

Installs 

* /usr/local/bin/prompt.sh
* /etc/profile.d/prompt.sh

so your prompt is colourful and shows return value of last command

Currently uses root directly, no extra setup needed on remote system

In case you don't have inventory set up use just:
~~~
ansible-playbook command_prompt.yml -k -i <hostname or IP>,
~~~

