#= require vendor/jquery-1.7.1.min.js
#= require vendor/runtime.min.js
#= require vendor/socket.io.min.js
#= require open
#= require tweets
#= require spaces

socket = io.connect '/'

openSpaces socket
tweets socket
spaces socket
