# init

This role is used for initialize system.

## Pre-requirement

### Install python, pip, ansible

```sh

```

### Install community.general for MacOS

```sh
ansible-galaxy collection install community.general
```

## Quick Start

* `demo.yml`

```yml
---
- hosts: localhost
  become: no
  tasks:
    - name: Install Packages
      include_role:
        name: init
```


```sh
ansible-playbook demo.yml
```

## Refernece

* [community.general.homebrew – Package manager for Homebrew](https://docs.ansible.com/ansible/latest/collections/community/general/homebrew_module.html)
