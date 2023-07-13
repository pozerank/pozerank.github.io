---
title:  "Rest Api Design Best Practices"
date:   2021-08-14 21:23:23
categories: [architecture, java, spring, jvm, spring boot, english]
tags: [rest, api, design, best, practices, http, service, web service, rest service, design, tasarım, java, spring boot, mikroservis, microservice, kubernetes,  türkçe, yazılım, blog, blogger, nedir, örnek, nasıl yapılır, mehmet cem yücel]
image: https://miro.medium.com/max/150/1*mdijc3xUzEbA2XuyBW5SWg.png
---
We are using Rest API Services for intercommunication of our applications. So, do we pay attention to best practices when using them, e.g Richardson Maturity Model, Http Methods, status codes, URI design principles. Let's analyze this topics together.

![](https://cdn-images-1.medium.com/max/1000/1*mdijc3xUzEbA2XuyBW5SWg.png)
## Basics

-   **1#** “/” char used for only hierarchical relations.

	    **e.g** https://mehmetcemyucel.com/customers/orders

-   **2#** “/” character should not be at the end of URI.

	    **wrong e.g** https://mehmetcemyucel.com/customers/orders/
	    **correct e.g:** https://mehmetcemyucel.com/customers/orders

-   **3#** "\_" char should not be used in the URI because the browsers use it for hyperlynk interpretation. “-” char usage is best practice instead of "_" char usage for readibility.

	    **wrong e.g**: https://mehmetcemyucel.com/blogs/blockchain_blog/entries/first_blog_post
	    **correct e.g:** https://mehmetcemyucel.com/blogs/blockchain-blog/entries/first-blog-post

-   **4#**  By th [RFC 3986](https://www.rfc-editor.org/info/rfc3986) standards URI's are case sensitive. Best practice is using all characters in lowercase to avoid confusion. 

	    **e.g 1:** https://mehmetcemyucel.com/customers/orders
	    **e.g 2:** https://mehmetcemyucel.com/Customers/Orders (this is different address from above)
	    **e.g 3:** HTTPS://MEHMETCEMYUCEL.COM/customers/orders (different from others. use only lowercase chars)

-   **5#** URI's must not have file extension. "Content-Type" header can be used for Media Type informations.Also, file extensions can be managed with the 'Accept' header.
  
	    **wrong e.g:** https://mehmetcemyucel.com/customers/orders/123/invoice.json
	    **correct eg:** https://mehmetcemyucel.com/customers/orders/123/invoice

-   **6#** API usage with versioning is best practice. Different alternatives you can prefer; in url, in header etc.

	    **URI e.g:** [https://mehmetcemyucel.com/v1/customers/orders](https://mehmetcemyucel.com/customers/orders)
	    **header e.g:** x-api-version=1
		
{% include feed-ici-yazi-1.html %}

## Resource Modeling (Path)

### **Document**

Documents are objects. In other words documents are similar as unique database entries. Documents may have fields and links that are used for access different resources. Document examples at the below.

    …/v1/departments/it
    …/v1/universities/ege-university

### **Collection**

The term 'Collection' means a directory that contains resources managed by the server. These resources should maintain semantic coherence or semantic consistency. E.g

    …/v1/customers
    …/v1/universities/ege-university/faculties

### **Store**

The term 'Store' means resource repository that managed by the Client. Client can create, update or delete the store.

An example that add a store to favorites of a user:

    PUT …/v1/customers/1234/favorites/727721

### **Controller**

It should not be confused with the Controller in the MVC pattern on the server side. Controller is a procedural concept, similar as a function that have inputs and outputs. However operations that can be performed by standart Http Methods(POST, GET, ...) should not be defined as controllers.

    **e.g:** POST …/alerts/15231/resend

### Resource Modeling Rules

-   **7#** Document and store names must be singular.

	    …/v1/departments/it
	    …/v1/universities/ege-university/students/05051232
-   **8#** Collection names must be plural.

	    …/v1/departments
	    …/v1/universities/ege-university/students

-   **9#** Controller names must be verb.

	    …/alerts/15231/resend

-   **10#** Using ID's for defining Documents and Stores is best practice for server performance improvement.

	    …/v1/{university-id}/students/{student-id}
	    …/v1/universities/351/students/05051232

-   **11#** URI's should not contain HTTP Method names.

	    **correct e.g:** DELETE …/users/1234
	    **wrong e.g:**
	    POST …/deleteUser?id=1234
	    POST …/deleteUser/1234
	    POST …/delete-user {“id”:1234} //body
	    DELETE …/deleteUser/1234
	    POST …/users/1234/delete
		
{% include feed-ici-yazi-2.html %}

## URI Query Design (Query)
Queries are related with Controllers, Documents, Collections and Stores. Queries can be used for filtering, searching, pagination, sorting and pass inputs to a controller. Examples;

https://mehmetcemyucel.com/users/123456/send-sms with this controller, a sms can be sended.
https://mehmetcemyucel.com/users/123456/send-sms?text=welcome a sms can be sended with content 'welcome'

### URI Query Design Rules
-   **12#** Can be used for filtering Collections or Stores.

	    **e.g:** GET …/users?role=admin

-   **13#** Can be used for paging the outputs of Collections or Stores.

	    **e.g:** GET …/users?pageSize=25&pageStartIndex=50

-   **14#** Can be used for sorting the outputs of Collections or Stores.

{% include feed-ici-yazi-3.html %}

## HTTP Methods

### GET
The GET method is used to retrieve a representation of a resource. It does not modify any resource on the server and is solely intended for retrieving information. Additionally, the GET method is considered idempotent.

### HEAD
The HEAD method is similar to the GET method, with the only difference being that the HEAD method does not include a response body. HEAD is an idempotant method.

### POST
The POST method used for create an entity on the resource server. POST is not an idempotant method.

### PUT
The PUT method used for fully update an entity on the resource server. PUT is an idempotent method.

### DELETE
The DELETE method used for delete an entity on the resource server. DELETE is an idempotant method.

### CONNECT
The CONNECT method used for start a tunnel from client to resource.

### OPTIONS
The OPTIONS method used for get communication methot alternatives.

### TRACE
The TRACE method used for loop-back testing from client to resource.

### PATCH
The PATCH method used for partitial update of an entry on the resource server. PATCH is not an idempotant method.

   E.G Curl 
    
    $ curl -v http://api.organization.com/greeting  
    > GET /greeting HTTP/1.1 2  
    > User-Agent: curl/7.20.1 3  
    > Host: api.organization.com  
    > Accept: /  
    < HTTP/1.1 200 OK 4  
    < Date: Sat, 20 Aug 2011 16:02:40 GMT 5  
    < Server: Apache  
    < Expires: Sat, 20 Aug 2011 16:03:40 GMT  
    < Cache-Control: max-age=60, must-revalidate  
    < ETag: text/html:hello world  
    < Content-Length: 130  
    < Last-Modified: Sat, 20 Aug 2011 16:02:17 GMT  
    < Vary: Accept-Encoding  
    < Content-Type: text/html  
    <!doctype html><head><meta charset="utf-8"><title>Greeting</title></head>   
    <body><div id="greeting">Hello   World!</div></body></html>

### HTTP Methods Usage Rules

-   **15#** GET and POST methods should not cover the other methods responsibilities. 
-   **16#** GET must be used solely representation of a resource.
-   **17#** GET, HEAD, OPTIONS, TRACE methods can not change the resource state.
-   **18#** PUT must be used for update of mutable resources.
-   **19#** POST must be used for create a resource at a collection(insert).
-   **20#** After a successfull POST request, response code should be 201 and response should has a location header that represents new resource.
-   **21#** PATCH must be used for partitial update of a resource.
-   **22#** After PATCH, POST ve PUT requests, new version of resource should be returned at the response.
-   **23#** Controllers must be used with solely POST method.
-   **24#** DELETE must be used for delete resource from only its parent. 
-   **25#** With an OPTIONS request, it is possible to obtain metadata of a resource. This can help reduce the possibility of a 400 Bad Request.
      
    Allow: GET, PUT, DELETE

## HTTP Status Codes

**1xx**: Informational Response
  The request was received, continuing process

**2xx**: Successfull  
  The request was successfully received, understood, and accepted

**3xx**: Redirection  
  Further action needs to be taken in order to complete the request

**4xx**: Client Errors  
  The request contains bad syntax or cannot be fulfilled

**5xx**: Server Errors  
  The server failed to fulfil an apparently valid request

### HTTP Status Code Rules

-   **26#** 200 OK response is expected result. Except of 204 code, returning of a response body for 2xx response codes is best practice.
-   **27#** 200 OK code can not be used for return unsuccesfull response(error, exceptions or invalid states).
-   **28#** 201 Created should be used after creation of a new resource.
-   **29#** 202 Accepted code explains that an async transaction has been started now.
-   **30#** 204 No Content code can be preferable when the resource can not be found after PUT, POST, DELETE requests. Response body should be empty.
-   **31#** 302 Moved Permanently code can be used for definition of a permanently moved resource. Location header at the response should define the new address of resource.
-   **32#** 304 Not Modified code is similar to 204, with the only difference being that response body doesn't have to be empty.
-   **33#** 400 Bad Request code should be used for unknown root cause of an error from client side. If the cause of the error is known, an appropriate 4xx status code should be preferred.
-   **34#** 401 Unauthorized code should be used when client credentials are not valid. It is a server side code. 
-   **35#** 403 Forbidden code is an application side code that used for client roles not valid to access resource.
-   **36#** 404 Not Found code should be used when requested resource can not be found on server side.
-   **37#** 500 Internal Server Error code is an error code that should be used for application-related errors.

{% include feed-ici-yazi-1.html %}

## Metadata Design (Headers-Content Types)

### text/plain
A plain text format with no specific structure.

### text/html
Content formatted using HyperText Markup Language (HTML)

### image/jpeg
An image compression standart from Joint Photographic Experts Group (JPEG)

### application/xml
Content with Extensible Markup Language (XML)

### application/atom+xml
Content with XML based Atom Syndication Format (Atom) format

### application/javascript
Content with written in JavaScript language

### application/json
Content with text based JavaScript Object Notation (JSON) format

### Metadata Design Rules
-   **38#** Both request and response, Content-Type configuration should be done.
-   **40#** Location header should be used for return address to new created resource.
-   **41#** Cacahe-Control, expires, date response headerlars should be returned for client caching. If server doesn't prefer caching, should return Cache-Control, Expires and Pragma headers.
-   **42#** Custom http headers should not be used for change default behaviours of http methods/headers

## Representation Design(Body)

-   **43#** Json resource representation support is nice to have instead of plain/text responses.












