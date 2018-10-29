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

#### HTTP Version

The version of HTTP is done by identifying the following scheme: ``` <major>.<minor>``` such that ```HTTP-Version   = "HTTP" "/" 1*DIGIT "." 1*DIGIT```. So, as mentioned before, I'm assuming we'll be using ```HTTP/1.1```. 

#### Uniform Resource Identifiers

URI or Uniform Resource Identifiers are simpy formatted, case insensitive strings that contain the name, location, etc. to identify a resource like a website or web service. You may be familiar with the concept of URLs (Uniform Resource Locators). Guess what - a URL is a specific type of URI. They're used interchangeably for some reason. Mind blown. So the format for URI is the following: 

```URI = "http:" "//" host [ ":" port ] [ abs_path [ "?" query ]]``` 

In this case, we note that if the port isn't given, we will use port 80, the default for HTTP. An empty abs_path means "/." In many/most cases, we may have the abs_path represent something we'd like. So, on YouTube, my abs_path would be ```youtube.com/watch?v=somecodethatidentifiestheuploadedvideo```. Another fun fact - all HTTP date/time stamps must be in GMT. 

#### Other HTTP Related Knowledge

Character sets specify the character set the client prefers. For example, the default case is the US-ASCII character set. A content encoding value indicates that an encoding algorithm has been used to encode the content before passing it to a network. It's used primarly to allow a document to be compressed without losing its identity. Media types are used in the Content-Type or Accept header fields that allow it to have appropriate data typing and type negotiation (e.g. allow the server to accept a gif by doing image/gif). Language tags allow for multiple dialects or other types of languages to be interpreted. 

### HTTP Messages

An HTTP client is a program that establishes a connection to a server in order to send an HTTP request message. A server is a program that accepts connections in order to serve HTTP requests by sending HTTP response messages. HTTP uses the URI (Uniform Resource Identifiers) to identify a resource and establish a connection. The messages are passed in a format similar to that used by Internet mail; the messages include requests from client to server and responses from server to client that have the following format:
 
 ```HTTP-message   = <Request> | <Response> ; HTTP/1.1 messages```

 So the general format for HTTP requests and HTTP responses use a generic message format, which is the following: 
 * A start-line: ```start-line = Request-Line | Status-Line```
   * So a request line may look like: ```GET /hello.htm HTTP/1.1``` with a status-line as ```HTTP/1.1 200 OK```
 * A header field
   * Four types of HTTP message headers; they provide required information about the request or response. 
     * General-header: General applicability for requests/response messages. 
     * Request-header: These header fields have applicability for request messages. 
     * Response-header: These header fields have applicability for response messages. 
     * Entity-header: Used to define information about the entity-body. 
        * Could look like this ```User-Agent: curl/7.16.3``` or ```Accept-Language: en, mi``` or ```Content-Length: 51```
 * A message body if needed
   * This is an optional part of an HTTP message; it's used to carry the entity-body associated with a request or response. It has two header lines (i.e. contentType and contentLength). A message body actually carries the HTTP request data and the HTTP response from the server. This may look familiar if you know HTML. 
     * Example: 
     ```
         <html>
            <body>
        
            <h1>Hello, World!</h1>
        
            </body>
        </html>
     ```

### HTTP Methods

As we learned previously, an HTTP client will send an HTTP request to a server in the form of a request message which has the format listed above. Now, in a HTTP request message, there's a request-line that has a method token, a request-URI, and the protocol version. It looks like this: ```Request-Line = Method SP Request-URI SP HTTP-Version CRLF```. The request method indicates the method to be performed on the resource in the Request-URI. 

There are many types of HTTP methods (I'm calling it this, I'm referring to reqeust methods), which include GET, POST, PUT, and DELETE. 

**GET Method** is used to request data. It's a very popular HTTP method. Important to note that data is visible to everyone in the URL!

**POST Method** is used to send data to a server and create or update a resource. The data to be sent to the server is stored in something called the "request body" of the HTTP request. Data isn't displayed in the URL. Also no restrictions on data length. 

**PUT Method** is used to send data to a server and create or update a resource. You may ask, why is this different than the POST method? Essentially, the PUT method will produce the same results when called repeatedly whereas the POST method will create the same resource multiple times. 

**DELETE Method** is used to delete a resource specified. That's pretty self-explanatory. 

I could discuss the HEAD method or OPTIONS method, but the methods above are the most common. A quick google search solves most queries here. There are several request methods that you could use. A request-URI has the form: ```Request-URI = "*" | absoluteURI | abs_path | authority```. 

Now, putting everything together, a request message may look like the following (if I wanted to get information from a hello.htm page from the web server running tutorialspoint.com, where I got most of the information for this tutorial): 

```
GET /hello.htm HTTP/1.1
User-Agent: Mozilla/4.0 (compatible; MSIE5.01; Windows NT)
Host: www.tutorialspoint.com
Accept-Language: en-us
Accept-Encoding: gzip, deflate
Connection: Keep-Alive
``` 

### Status Codes 

After receiving and interpreting a request message, a server responds with an HTTP response message. A message status-line has the protocol version followed by a status code and textual phrase: ```Status-Line = HTTP-Version SP Status-Code SP Reason-Phrase CRLF```. The status code will let the client know about the status of the response: 

* 1xx: Informational: the request was received and the process is continuing. 
* 2xx: Success: The action was understood and accepted. 
* 3xx: Redirection: Further action must be taken to complete the request.
* 4xx: Client error: Request had invalid syntax or can't be fulfilled. 
* 5xx: Server error: Server failed to fulfill a valid request.

We probably won't need this, but you can have custom response header fields that can indicate age, location, accept-ranges, etc. These are used if you're building your own server, which is unlikely. So, going off of the GET request from the previous section, let's say it didn't work. You could get something like this: 

```
HTTP/1.1 404 Not Found
Date: Sun, 18 Oct 2012 10:36:20 GMT
Server: Apache/2.2.14 (Win32)
Content-Length: 230
Connection: Closed
Content-Type: text/html; charset=iso-8859-1
```

```
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html>
<head>
   <title>404 Not Found</title>
</head>
<body>
   <h1>Not Found</h1>
   <p>The requested URL /t.html was not found on this server.</p>
</body>
</html>
```

If it works, we may get the following:

```
HTTP/1.1 200 OK
Date: Mon, 27 Jul 2009 12:28:53 GMT
Server: Apache/2.2.14 (Win32)
Last-Modified: Wed, 22 Jul 2009 19:15:56 GMT
ETag: "34aa387-d-1568eb00"
Vary: Authorization,Accept
Accept-Ranges: bytes
Content-Length: 88
Content-Type: text/html
Connection: Closed
``` 

A fairly in depth look at various status codes can be found [here](https://www.tutorialspoint.com/http/http_status_codes.htm). 

## Summary of HTTP 

The internet can be considered a "massive distributed client/server information system." HTTP (HyperText Transfer Protocol) is the most popular application protocol (used to communicate between client and server); it sends a request message to an HTTP server that then gives a response message. HTTP is familiar from the internet browser when searching things up. When you use a URL (issue a URL) from the browser, it turns the URL to a request message, sends it to the HTTP server, and interprets the message (gives you the site you requested). While HTTP is a client-server application-level protocol, it runs over a TCP/IP (transmission control protocol/ internet protocol), which is a set of "transport and network-layer protocols for machines to communicate with each other over the network." You may be familiar with IP (internet protocol) from IP address, a unique address that each machine is assigned in an IP network; IP software routes messages from source to destination IP. 

On the internet, we use domain names (e.g. google.com) instead of IP addresses for ease of use; we use DNS (domain name services) to translate domain names into the IP address. That being said, there is the IP address or localhost which refers to one's own machine and is good for testing. For each IP machine, TCP supports a large number of ports or sockets. An application (e.g. HTTP) listens at a particular port number for requests; ports 0 to 1023 are pre-assigned (e.g. 80 for HTTP), but 1024 and above are for users in general. Usually, people run test servers on 8000.

HTTP clients and servers communicate by sending messages. Clients send request messages to servers and receive response messages, as mentioned above. An HTTP message contains a message header and (optionally) a message body. There is a particular syntax for each. The first line of the header is the request line. It contains information about the request method (e.g. GET, POST), the request-URI (what is requested), and the HTTP version. For the HTTP response messages, the first line is called the status line, which contains the HTTP version, the status-code (three digit number to show the status of the request), and an explanation of the status code. In regards to the request method, the HTTP protocol defines a set of them; a client can use these to send a request message to an HTTP server. The main ones are GET (requesting a web resource from a server), POST (used to post data to the web server), PUT (ask the server to store data), and DELETE (ask the server to delete the data). In the case for Arduino, a GET request can be made to a web server that Arduino is connected to in order to control remotely; alternatively, Arduino can POST information to a web server that can be accessed remotely. 

### Quick Aside on JSON and XML-Encoded 

In order to communicate properly with the HTTP server, one needs to format the data output. I recommend XML (Extensible Markup Language) or JSON (JavaScript Object Notation). These are the two most common formats for data interchange in the web. JSON is a lightweight format to exchange data - it’s used for serializing and transmitting data over a network. More information about JSON is [here](https://stackoverflow.com/questions/383692/what-is-json-and-why-would-i-use-it). XML describes data objects and partially describes the behavior of the programs that process these objects. More information about XML is [here](https://www.w3.org/TR/WD-xml-lang-970630). We will use JSON or XML-encoded to transfer data via HTTP requests. I would recommend using JSON, which looks like the following:

```
{
     "firstName": "John",
     "lastName": "Smith",
     "address": {
         "streetAddress": "21 2nd Street",
         "city": "New York",
         "state": "NY",
         "postalCode": 10021
     },
     "phoneNumbers": [
         "212 555-1234",
         "646 555-4567"
     ]
 }
``` 

# RESTful API 

An API is the tool that makes a website's data digestible for a computer. Through it, a computer can view and edit data just like a person can via loading pages/submitting forms. A well-designed format is dictated by what makes the information the easiest for the intended audience to understand. The most common formats found in APIs are JSON and XML. The rest of this intorduction will be referencing the following [link](https://restful.io/an-introduction-to-api-s-cee90581ca1b). 

Systems that use APIs or connectusing them are considered **integrated**. The server will host the API whereas the client can manipulate and use the API. As mentioned previously, the HTTP protocol uses a request-response cycle. A valid request has four things:

* URL (Uniform Resource Locator) or URI (Uniform Resource Identifier) 
* Method 
* List of Headers
* Body 

Previously, we discussed methods or HTTP requests, of which the most common are GET, POST,PUT, and DELETE. Headers provide meta-information on a request and the body is the data that a client wants to send a server, which responds with a status code that informs the progress of the request. This is explained in more detail in the previous sections. 

## JSON & XML 

A well-designed format is dictated by what information is the easiest for people to understand. The most used formats in APIs are JSON and XML. 

JSON consists of two pieces that are important: ```key``` and ```value```. On the other hand, XML consists of a few building blocks, of which the main block is called a node. The name of the node tells us the attribute of the order; the data inside is the details. Let's show what each looks like. 

* JSON looks like: ```{"Key": "TheValue"}```
* XML looks like: ```<key>TheValue</key>``` 

So tying things together. We use headers in our request to tell a server what type of information we're sending it and what we expect back. In the header called ```content-type```, we are saying what format our data is in. The ```accept``` header tells the server what data-format it can accept. So it would look like the following if our server and front-end application (client) wanted to send JSON information: 

* Accept: "application/json"
* Content-Type: "application/json" 

## Authentication