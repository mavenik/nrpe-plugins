#!/bin/bash
NAGIOS_EXECUTABLES=/usr/local/nagios/libexec
NAGIOS_COMMANDS=/usr/local/nagios/etc/commands

cp -Rv plugins/* $NAGIOS_EXECUTABLES/
chown -R nagios.nagios $NAGIOS_EXECUTABLES

cp -Rv commands/* $NAGIOS_COMMANDS
