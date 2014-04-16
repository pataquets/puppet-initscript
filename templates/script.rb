#!/bin/bash
# This file is managed by Puppet. DO NOT EDIT!
#
# <%= @name %>		Start / stop <%= @friendly_name %>
#
# chkconfig: 2345 20 80
# description: <%= @description %>
#
# processname: <%= @name %>
# pidfile: /var/run/<%= @name %>.pid

### BEGIN INIT INFO
# Provides: <%= @name %>
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start / stop <%= @friendly_name %>
# Description:       <%= @description %>
### END INIT INFO

# source function library
. /etc/rc.d/init.d/functions

# pull in sysconfig settings
[ -f /etc/sysconfig/<%= @name %> ] && . /etc/sysconfig/<%= @name %>

RETVAL=0
prog="<%= @name %>"
lockfile=/var/lock/subsys/$prog

# Some functions to make the below more readable

BINARY=<%= @binary %>
PID_FILE=/var/run/<%= @name %>.pid

runlevel=$(set -- $(runlevel); eval "echo \$$#" )

start()
{
  [ -x $BINARY ] || exit 5
  <% if @config_file %>
    [ -f <%= @config_file %> ] || exit 6
  <% end %>


  echo -n $"Starting $prog: "
  daemon --user <%= @user %> --pidfile=${PID_FILE} $BINARY <%= @cmd_options %> 
  RETVAL=$?
  [ $RETVAL -eq 0 ] && touch $lockfile
  echo
  # in case the pidfile isn't created
  [ -f $PID_FILE ] || pidofproc <%= @name %> > $PID_FILE
  return $RETVAL
}

stop()
{
  echo -n $"Stopping $prog: "
  killproc -p $PID_FILE $BINARY
  RETVAL=$?
  echo
  [ $RETVAL = 0 ] && rm -f ${lockfile} ${pidfile}
  echo
}

reload()
{
  echo -n $"Reloading $prog: "
  killproc -p {$PID_FILE} $BINARY -HUP
  RETVAL=$?
  echo
}

restart() {
  stop
  start
}

force_reload() {
  restart
}

rh_status() {
  status -p $PID_FILE <%= @name %>
}

rh_status_q() {
  rh_status >/dev/null 2>&1
}

case "$1" in
  start)
    rh_status_q && exit 0
    start
    ;;
  stop)
    if ! rh_status_q; then
      rm -f $lockfile
      exit 0
    fi
    stop
    ;;
  restart)
    restart
    ;;
  reload)
    rh_status_q || exit 7
    reload
    ;;
  force-reload)
    force_reload
    ;;
  condrestart|try-restart)
    rh_status_q || exit 0
    if [ -f $lockfile ] ; then
      do_restart_sanity_check
      if [ $RETVAL -eq 0 ] ; then
        stop
        # avoid race
        sleep 3
        start
      else
        RETVAL=6
      fi
    fi
    ;;
  status)
    rh_status
    RETVAL=$?
    if [ $RETVAL -eq 3 -a -f $lockfile ] ; then
      RETVAL=2
    fi
    ;;
  *)
    echo $"Usage: $0 {start|stop|restart|reload|force-reload|condrestart|try-restart|status}"
    RETVAL=2
esac
exit $RETVAL
