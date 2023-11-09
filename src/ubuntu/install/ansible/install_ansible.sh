#!/usr/bin/env bash
set -ex

apt-add-repository --yes --update ppa:ansible/ansible
apt-get install -y ansible
