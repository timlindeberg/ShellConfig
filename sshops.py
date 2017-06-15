import sys
import paramiko
import getpass

host = sys.argv[1]
password = sys.argv[2]
print
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(host, username='ops.tim.lindeberg', password=password)

transport = ssh.get_transport()
session = transport.open_session()
session.set_combine_stderr(True)
session.get_pty()

command = open('./setup_shell.sh', 'r').read()

session.exec_command(command)
stdin = session.makefile('wb', -1)
stdout = session.makefile('rb', -1)

while True:
  line = stdout.readline()
  if 'Shell setup finished' in line:
  	break

  print line.rstrip()

stdout.close()
stdin.close()
session.close()