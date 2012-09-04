#!/bin/bash
NAGIOS_EXECUTABLES=/usr/local/nagios/libexec
cp -Rv plugins/* $NAGIOS_EXECUTABLES/
chown -R nagios.nagios $NAGIOS_EXECUTABLES
