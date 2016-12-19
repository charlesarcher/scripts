#!/usr/bin/env python

import socket
import inspect

clientsocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
clientsocket.connect(('sfs-login.jf.intel.com', 22))

print clientsocket.getpeername()

