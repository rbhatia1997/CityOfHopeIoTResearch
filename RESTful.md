##  HTTP Requests & How They Work

Before we begin, it may be useful to download this free software called [Postman](https://www.getpostman.com/). This is useful as an HTTP Client, but we'll get to this later! 

I'm basically going to paraphrase from this website [here](https://www.w3schools.com/tags/ref_httpmethods.asp) for this next part. If you want to read it instead of my commentary, please do. 

### What is HTTP?

Let's start by discussing what HTTP even means. It stands for Hypertext Transfer Protocol. It creates communication between clients and servers. A browser, like Chrome, may submit an HTTP request to a server and the server will respond to the client (browser). You may be familiar when people make "404 not working" jokes; what they are referring to is an error message. Specifically, in the Hypertext Transfer Protocol (HTTP) standard response code. It is what happens when a client wants to follow a broken or dead link.

To reiterate, HTTP is an application-level protocol for distributed, collaborative, information systems. It's the foundation for data communication on the world wide web (internet) since the 90s. For the sake of simplicity, I'm going to write the tutorial for HTTP/1.1 because an alternative, HTTP/1.0, uses a new connection for each request/response whereas HTTP/1.1 allows a connection to be used for multiple request/response connections. Before we continue, let's talk a bit more about other important things about connections. 

### TCP/IP Protocol 

HTTP is a TCP/IP based communication protocol used to deliver data on the Internet. TCP/IP is the language that a computer uses to access the Internet. Specifically, it's a bunch of protocols that establish a network of networks to give a user access to the internet. Almost every computer today supports TCP/IP. Note that it's a bunch of protocols named after the two most important protocols inside it, which is TCP and IP. 

When we communicate, we need a message and a means to send the message. TCP handles the message, which is broken into smaller units called packets that are transmitted over the network. Packets are recieved by the corresponding TCP layer in the receiver and then reassembled into the original message. It's almost as if I took a piece of paper, put it in a shredder (each of the shreds are my packets), I mailed the shredded pieces to my friend, who then glued them together to get the original message. 

The IP layer is concerned with transmision. A unique IP address (you may have heard of this!) is assigned to each and every active recipient on the network. TCP/IP is considered stateless - a new connection is made regardless of whether a previous connection was established. 

Internet protocol (IP) is the method by which data is transferred across the Internet. It exchanges the packets, which has two parts (header and a body); the header states the destination and the body contains the IP transmitted. TCP can recognize problems where IP packets are lost, duplicated, or out of order. A TCP receiver will request retransmission if it detects problems; when it reassembles the data, it'll pass it to an application program. 

Okay, great. We have HTTP, which is a TCP/IP based protocol. But how can uniquely identify a transaction over a network by specifying the host and service? A port is a number that uniquely identifies a transaction over a network by specifying both the host and service. So if someone is trying to connect to a server, they need the IP address but also with which service they want to use so the data is sent to the appropriate application. Thus, we use ports to specify the application. For SMTP (mail service) we use 25, so packets of information related to email go here. For HTTP, we use 80 as the default port, which is used to identify packets meant for web server transfer. Port numbers are used in providing firewall security by mandating the destination of info on a network; if you want to block anyone outside your network from accessing the internet through your server, you could set a firewall to block any packets sent to port 80 from going through the router (the thing that forwards data packets between computer networks; a modem is what connects the router to the internet). Additionally, you could block everything but port 25 so you can only use mail services on the network. So that's pretty neat. Now you know a lot about how the Internet connects to things! A good summary of the above can be found [here](https://www.bullguard.com/bullguard-security-center/pc-security/computer-security-resources/tcp-ip-ports_). 

### Basic Features of HTTP 

There are three features that make HTTP a simple yet powerful protocol. 
* HTTP is connectionless
  * The HTTP client (such as a browser that initiates an HTTP request and disconnnects from the server once a request is made) waits for a response from the server. The server processes the request and reestablishes connection with the client to send a response back. 
* HTTP is media-independent 
  * Any type of data can be sent through HTTP as long as the server and client both know how to handle the data content. It's required for the client as well as the server to specify the type. 
* HTTP is stateless
  * The server and client are aware of one another during a current requets, but then forget about each other afterwards. Due to this, neither client nor server can retain information between different requests across web pages. 

The HTTP Protocol is request/response based on client/server architecture. Thus, the web server is a server and things like search engines and robots can act as a client. In this case, a client is one in which a request is sent to the server in the form of a request method, protocol version, and other information needed to convey intent. Additionally, the HTTP server responds to the client's request with a status line, including the message's protocol version and a success or error code. 

### HTTP Methods

There are many types of HTTP methods, which include GET, POST, PUT, and DELETE. 

**GET Method** is used to request data. It's a very popular HTTP method. Important to note that data is visible to everyone in the URL!

**POST Method** is used to send data to a server and create or update a resource. The data to be sent to the server is stored in something called the "request body" of the HTTP request. Data isn't displayed in the URL. Also no restrictions on data length. 

**PUT Method** is used to send data to a server and create or update a resource. You may ask, why is this different than the POST method? Essentially, the PUT method will produce the same results when called repeatedly whereas the POST method will create the same resource multiple times. 

**DELETE Method** is used to delete a resource specified. That's pretty self-explanatory. 

I could discuss the HEAD method or OPTIONS method, but the methods above are the most common. A quick google search solves most queries here. 