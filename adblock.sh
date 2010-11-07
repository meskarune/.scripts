#!/bin/bash

ADBLOCK='http://www.mvps.org/winhelp2002/hosts.txt';
HOSTSHEAD=/etc/hosts_head;

if [ $(whoami) != "root" ]; then
  echo "Please run as root." >&2
  exit 1
fi
if [ ! -f "${HOSTSHEAD}" ]; then
  echo "Header file for hosts missing." >&2
  exit 2
fi

if [ -z "$(curl -I "${ADBLOCK}" 2>&1 | grep '200 OK' )" ]; then
  echo "Error, return code for Adblock lists is not 200." >&2
  echo "This typically indicates an error, rather than anything else." >&2
  exit 3
fi

cp "${HOSTSHEAD}" /etc/hosts
wget -O - "${ADBLOCK}" | sed /localhost/d >> /etc/hosts