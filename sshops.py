#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import paramiko
import getpass

host = sys.argv[1]
password = sys.argv[2]
directory = sys.argv[3]
print
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
try:
	ssh.connect(host, username='ops.tim.lindeberg', password=password)
except paramiko.ssh_exception.AuthenticationException:
	print "Invalid password"
	sys.exit(1)

transport = ssh.get_transport()
session = transport.open_session()
session.set_combine_stderr(True)
session.get_pty()

command = open(directory + '/setup_shell.sh', 'r').read()

session.exec_command(command)
stdin = session.makefile('wb', -1)
stdout = session.makefile('rb', -1)

while True:
  line = stdout.readline()
  if 'Shell setup finished' in line:
  	break

  line = line.rstrip()
  	
  if "×" in line:
  	print "\033[31m" + line + "\033[0m"
  elif "✓" in line:
  	print "\033[32m" + line + "\033[0m"
  elif line.startswith(">"):
  	print "\033[35m" + line + "\033[0m"
  else:
  	print line

stdout.close()
stdin.close()
session.close()