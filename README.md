Hackerspaces Status Wall
========================
A basic web page that shows the status of hackerspaces that implement the [hackerspace status API](https://hackerspaces.nl/spaceapi/).
It uses a directory API to find the available endpoints.

Client Side First
-----------------
The page will try to access all APIs on the client side using an AJAX call. Only if this fails will a server side proxy be used.

Error Reporting
---------------
A second aim of this page is to display any errors or potential problems with a particular spaces API.

Technologies Used
-----------------
Sinatra (Ruby)
Coffee Script
Haml
Sass
