#!/bin/sh

# running by non-root user

# run s6-svscan with PID 1 with non-root user to ensure least privilege
exec /bin/s6-svscan /run/openrc/s6-scan
