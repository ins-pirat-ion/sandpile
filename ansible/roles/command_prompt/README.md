Role Name
=========

Deploy fancy prompt with retval report

Requirements
------------

sshd, root login permitted

Role Variables
--------------


Dependencies
------------


Example Playbook
----------------

~~~
- name: Install PROMPT_COMMAND with retval report
  hosts: all
  gather_facts: no
  remote_user: root
  roles:
    - command_prompt
~~~

License
-------

♡ copyheart

Author Information
------------------

