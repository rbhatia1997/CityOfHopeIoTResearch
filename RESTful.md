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

There are techniques in APIs to authenticate a client. From the server side, this is important because we want to know who is accessing information. Clients use authentification to verify that the server is the one it claims to be. The act of authentification is ensuring identity is accurate. 

### Types of Authentification 

Basic authentification or Basic Auth only requires username and password for verification. The client will take two credentials, convert them to one value, and pass them to an HTTP header called authentification. The server will check the authentification header to the credential it was stored; if there's a match, the server allows the HTTP request to go through, otherwise it returns 401 status code. 

API Key Authentification is a technique that overcomes the insecurity of sharing credentials because it requires a specific key must be used. When we say key, we mean a code passed in by computer programs that call an API. A lot of times, people have a special URL that will allow access: ```http://example.com?apikey=mysecret_key```. 

Open Authorization (OAuth) will automate a key exchange; it only requires user credentials and will secretly have client-server dialogue to get a valid key. There are two versions of OAuth. In OAuth2, the user tells the client to connect to a server. The next step is to have client direct the user to a server once authentification happens - a callback URL is sent from the server to client. Next, a user logs-in and gets access; users are given a unique authorization code for their client. Then, the client gives that code and a secret key for access. The server responds with an access code. Finally, a client can get data from a server. The access code allows for direct authentification. Tokens can expire for OAuth2. The time is set by the server. 

## Types of API Design

The two most common architectures for web-based APIs are SOAP and REST. 

* SOAP 
   * XML-based design that has a standardized structure for requests and responses. 
* REST (Representation State Transfer) 
   * Open approach with many conventions; leave many decisions to person designing API. 

I will focus on REST for the tutorial, as I think it's valuable to have the ability to control more. When talking about APIs, we use the word resources, which is what is interacted with in an API. Let's say that we are designing an API for a pizza company. For the client to interact with the company, there needs to be several decisions made: 

1. Decide what resources need to be available 
2. Assign URLs to those resources
3. Decide what actions the client should be allowed to perform on those resources
4. Figure out what pieces of data are required for each action & what format they're in

For REST APIs, a resource will have two URL patterns: (1) the plural of the resource name,like ```orders/``` and (2) the plural of the resource name + identifier for an order, which is ```orders/bhatia12323```. These are the endpoints that the API supports; an endpoint is what goes at the **end** of a URL after the ```\```. 

Now that the resources have URLs, a client needs to have actions it can do. We say that the endpoints, such as orders, list existing orders and can create new ones. The unique identifier endpoint for orders (e.g. orders/bhatia12323) can retrieve, update, or cancel a specific order. The client tells the server what to do by using the HTTP reqeust methods (e.g. GET, POST, PUT, DELETE). I can use a DELETE method to www.pizzacompany.com/orders/1 to cancel order one for example. 

Now, we need to decide what data is exchanged. If we say a pizza has crust and toppings, we need to select a data format (JSON for example). Therefore, an interaction between client and server will look like the following. A client will POST the following:

```
{
    "crust": "thin",
    "toppings" : ["cheese"]
}
``` 

It will then get the following response from the server that will indicate progress:

```
HTTP/1.1 201 Created
{
    "id": 5
}
```

What if we want to associate orders with customers (assuming we have a customer resource)?
Sometimes, people will add to the endpoint: ```/customers/5/orders``` for the 5th customer's order and then add /3 to indicate the third order for that customer. However, people may use an additional field in the body of the HTTP request that will be sent with order details (POST) that includes a customer_id. 

URLs have a component called a query string. REST APIs use these to define details of a search. These details are query parameters. The API dictates what parameters are accepted. You can use this in the pizza API to search for pizza with certain crust or toppings. Additionally, query strings can limit the amount of data in each request. Splitting data like this is called pagination - so if I called GET to get all the orders made I can only view a limited selection (e.g. orders from 200 - 400). 

## RESTful API and Arduino

Arduino has great resources for implementing RESTful API. One example is using REST calls via HTTP and the Arduino WiFi 101 Library (assuming one is using the MKR1000). One such library is the [aREST]("https://arest.io/") library (which is free to a certain extent). In using this library, boards running aREST can be accessed from anywhere using  ```cloud.arest.io```. 

Additionally, there is a library called [ArduinoHttpClient]("https://github.com/arduino-libraries/ArduinoHttpClient") that makes it easier to interact with web servers using Arduino. It can handle POST, PUT, GET, and DELETE. 

Finally, I have heard good words about the [ArduinoJSON]("https://github.com/bblanchon/ArduinoJson") library. I'm not sure about its functionality with the MKR1000, but it works for the ESP8266 and ESP32 IoT boards. 

## Designing a REST API with Node.js and MongoDB 

So first, what is Node.js. It's a technology for developing web applications; it's open-source and executes JavaScript code outside of a browser. Node.js has a package ecosystem called npm - the largest open source ecosystem of libraries in the world. Npm is a command line client that handles packages, which are building blocks of code. 

Applications that use REST APIs perform four functions that are known as CRUD. I'm being completely serious, that is the literal name for it. CRUD stands for the following:

* C: Creating Data
* R: Reading Data
* U: Updating Data
* D: Deleting or removing Data 

I mentioned POSTman way back in this post. You should have this downloaded; it's a tool for testing API. Additionally, you should have [node.js]("https://nodejs.org/en/") installed on your computer. Finally, make sure to download [MongoDB]("https://www.mongodb.com/"), which is a noSQL database. 

### Aside on Databases

Databases can be relational or non-relational (SQL vs. NoSQL). SQL uses query langauge (SQL) for defining and manipulating data. SQL is very powerful but it can be restrictive because you have to have preferred schema to determine the data structure even before working with it. There's a lot of up-front preparation. NoSQL has a dynamic schema for unstructured data and data can be stored in many ways. NoSQL is preferred for large or ever-changing data sets whereas SQL is vertically scalable (increase the load through CPU, RAM, or SSD changes). SQL structures are table-based and NoSQL databases are document-based. Although MySQL is free and has good documentation (and versatility), I believe that NoSQL is a good choice for a start-up or for clinic because of the potential for rapid data growth and for databases with no clear schema definition. 

## Designing a REST API with Node.js and MongoDB Continued

So, let's back up. Why do we need a REST API or Mongo? Basically, I mentioned CRUD earlier and how it was a useful method for understanding how to build applications. Let's say you wanted to build an app that lets you view/update a profile (e.g. patient data), you can create API endpoints with a REST API, which would let you connect many front-end applications to the same back-end which gives a lot of versatility. I will use the following source as a [guide]("https://medium.com/@dinyangetoh/how-to-build-simple-restful-api-with-nodejs-expressjs-and-mongodb-99348012925d"). 

So the first step here is to create another director (folder) on the computer called mongod (you can call it something else but I called it this). Then, put another directory called restAPI (or resthub or whatever you want) in there. In terminal, you're going to want to go to this directory and run/create your code in this directory. 

Next, you're going to want to run npm init. This will allow you to set-up your project. Accept the default name and version but change the description to what you want and change the author name to your name; make sure you accept the default license to generate something called ```package.json```. Additionally, make sure "main" has index.js referenced. Now, this package should be available in the directory that you're in. 

Now, you're going to install Express and setup the server. A web server is necessary in order to make the API endpoint accessible to a browswer or an API development tool like Postman (which will emulate HTTP requests from something like the MKR1000). 

We can install Express in the project with the following command: ```npm install express --save```. This should take a bit of time. 

Now, open an IDE or use vim on terminal, and create a new file called ```index.js``` where .js stands for javascript. Express is a minimalist web framewrok for Node.js. 

There'll be a directory called node_modules and a file called package.json asides from index.js. In package.json, index.js is defined as the app's entry point. Creating index.js should like the following:

```Javascript
// FileName: index.js
// Import express
let express = require('express')
// Initialize the app
let app = express();
// Setup server port
var port = process.env.PORT || 8080;
// Send message for default URL
app.get('/', (req, res) => res.send('Hello World with Express'));
// Launch app to listen to specified port
app.listen(port, function () {
     console.log("Running RestHub on port " + port);
});
```

Save the file and then run node index in the command line (making sure you're in the correct directory). It will say the port number and the name of the directory. Going to ```http://localhost:8080``` in the browser should show you a "Hello world with express" message that was defined in the index.js file. 

### More Professional Web Structuring

```api-routes``` will have all api endpoints defined in this file. 

```controller``` will process HTTP requests and defines the available endpoints. 

```model``` will manage database layer (request and response). 

Now, create a file called ```api-routes.js``` which has the following information: 

```Javascript
// Filename: api-routes.js
// Initialize express router
let router = require('express').Router();
// Set default API response
router.get('/', function (req, res) {
    res.json({
       status: 'API Its Working',
       message: 'Welcome to RESTHub crafted with love!',
    );
});
// Export API routes
module.exports = router;
```

This imports express router, sets the default route and exports the module so it can be used in the application. So, making this route accessible, we add more code to the index.js file that we had previously...

```Javascript
// FileName: index.js
// Import express
let express = require('express')
// Initialize the app
let app = express();
// Import routes
let apiRoutes = require("./api-routes")
// Use Api routes in the App
app.use('/api', apiRoutes)
// Setup server port
var port = process.env.PORT || 8080;
// Send message for default URL
app.get('/', (req, res) => res.send('Hello World with Express'));
// Launch app to listen to specified port
app.listen(port, function () {
     console.log("Running RestHub on port " + port);
});
```

Now, if your server is still running in the command line, use ```cntrl + C``` to end it. Then, run it again by typing ```node index```. Now, going to ```http://localhost:8080/api``` will allow users to see a new message! 

Instead of restarting the server every time we make changes to our files or adding new ones, we can use a node module called nodemon which restarts the server every time changes are made. Install this globally for every project you have through the following command-line prompt: ```npm install -g nodemon```. 

**Important to note that we will run our server with nodemon index rather than node index** 

Now, let's set-up MongoDB. We run this, after installation, using ```mongod``` in the command line. Now, we're going to install a few packages: (1) ```npm install mongoose --save``` and (2) ```npm install body-parser --save```. 

What did we do here? Mongoose is a NodeJs package for modeling MongoDB and handle validation/business logic for mongoDB on NodeJs. Body-parser enables an application to parse data from incoming request (e.g. XML, JSON data). Let's modify index.js with the following lines, enabling these packages: 

```Javascript
// Import Body parser
let bodyParser = require('body-parser');
// Import Mongoose
let mongoose = require('mongoose');
// Configure bodyparser to handle post requests
app.use(bodyParser.urlencoded({
   extended: true
}));
app.use(bodyParser.json());
// Connect to Mongoose and set connection variable
mongoose.connect('mongodb://localhost/resthub');
var db = mongoose.connection;
```
Now, we need to set up our controller to handle API requests and Model which will save/retrieve data from the database. So, if we want to store a few pieces of information on a user, we'd have to add two more files to our directory: ```contactController.js``` and ```contactModel.js``` which can be done also using the ```touch``` command in command line. 

The controller defines a method that handles requests and responses from different API endpoints. Additionally, we can import the contactModel and handle CRUD functions. So, contactController.js has:

```Javascript
// contactController.js
// Import contact model
Contact = require('./contactModel');
// Handle index actions
exports.index = function (req, res) {
    Contact.get(function (err, contacts) {
        if (err) {
            res.json({
                status: "error",
                message: err,
            });
        }
        res.json({
            status: "success",
            message: "Contacts retrieved successfully",
            data: contacts
        });
    });
};
// Handle create contact actions
exports.new = function (req, res) {
    var contact = new Contact();
    contact.name = req.body.name ? req.body.name : contact.name;
    contact.gender = req.body.gender;
    contact.email = req.body.email;
    contact.phone = req.body.phone;
// save the contact and check for errors
    contact.save(function (err) {
        // if (err)
        //     res.json(err);
res.json({
            message: 'New contact created!',
            data: contact
        });
    });
};
// Handle view contact info
exports.view = function (req, res) {
    Contact.findById(req.params.contact_id, function (err, contact) {
        if (err)
            res.send(err);
        res.json({
            message: 'Contact details loading..',
            data: contact
        });
    });
};
// Handle update contact info
exports.update = function (req, res) {
Contact.findById(req.params.contact_id, function (err, contact) {
        if (err)
            res.send(err);
contact.name = req.body.name ? req.body.name : contact.name;
        contact.gender = req.body.gender;
        contact.email = req.body.email;
        contact.phone = req.body.phone;
// save the contact and check for errors
        contact.save(function (err) {
            if (err)
                res.json(err);
            res.json({
                message: 'Contact Info updated',
                data: contact
            });
        });
    });
};
// Handle delete contact
exports.delete = function (req, res) {
    Contact.remove({
        _id: req.params.contact_id
    }, function (err, contact) {
        if (err)
            res.send(err);
res.json({
            status: "success",
            message: 'Contact deleted'
        });
    });
};
```

And for contactModel.js: 

```Javascript
// contactModel.js
var mongoose = require('mongoose');
// Setup schema
var contactSchema = mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true
    },
    gender: String,
    phone: String,
    create_date: {
        type: Date,
        default: Date.now
    }
});
// Export Contact model
var Contact = module.exports = mongoose.model('contact', contactSchema);
module.exports.get = function (callback, limit) {
    Contact.find(callback).limit(limit);
}
```
We are importing mongoose, creating a database for contacts, and exported the module so it is accessible. The update will be adding contact routes to the API endpoint... adding to api-routes.js (final code): 

```Javascript
// api-routes.js
// Initialize express router
let router = require('express').Router();
// Set default API response
router.get('/', function (req, res) {
    res.json({
        status: 'API Its Working',
        message: 'Welcome to RESTHub crafted with love!',
    });
});
// Import contact controller
var contactController = require('./contactController');
// Contact routes
router.route('/contacts')
    .get(contactController.index)
    .post(contactController.new);
router.route('/contacts/:contact_id')
    .get(contactController.view)
    .patch(contactController.update)
    .put(contactController.update)
    .delete(contactController.delete);
// Export API routes
module.exports = router;
```

We can run our server and then visit ```http://localhost:8080/api/contacts```. This would show a success status message but no contacts because we haven't added contacts. We'd need to use the HTTP POST request to add users. For example, we would use Postman with the URL above and then add four keys: name, email, phone, and gender as defined by the code; you would insert values for those and make sure you're using XML encoded. Finally, you would send the data via Postman and then running your GET would get the data.  

Using the following [tutorial]("https://devcenter.heroku.com/articles/getting-started-with-nodejs"). Also going to reference [this]("https://devcenter.heroku.com/articles/mean-apps-restful-api") for the next steps. Also, [this]("https://medium.freecodecamp.org/build-restful-api-with-authentication-under-5-minutes-using-loopback-by-expressjs-no-programming-31231b8472ca") may be helpful.  The last option implements something called LoopBack, which sets the routes automatically, and something called SwaggerAPI which allows you to make APIs quickly. 

### Aside on REST vs. GraphQL

There is another way to handle requests/responses and it's called [Graphql]("https://www.howtographql.com/"). Although REST is industry standard, Graphql will eventually take over the world and is much faster. For the sake of documentation, I refrain from getting into GraphQl. A [whitepaper]("https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm") from Roy Fielding explains why I used REST for the tutorial and for the project. 