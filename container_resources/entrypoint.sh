#!/bin/bash
set -e

if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == squid || ${1} == /usr/sbin/squid ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch squid
if [[ -z ${1} ]]; then
  if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
    echo "Initializing cache..."
    /usr/sbin/squid -N -f /config/squid.conf -z
  fi
  echo "Starting squid..."
  /usr/sbin/squid -f /config/squid.conf -NYCd 1 ${EXTRA_ARGS}
else
  exec "$@"
fi
