### Interacting with Web Services
Web services will generally have a published API which describes how to interact with the service.  This will be your guide for how to build requests using `HttpCommand` to access the web service. The API will generally describe the format of the data it returns in the `content-type` header.

A web service may require authentication in order to gain access to certain resources or perform certain operations. GitHub is a good example of this - it does not require authentication to perform read-only queries on public resources, but authentication is necessary to perform write operations or to access private repositories.

Let's look at GitHub's [REST API](https://docs.github.com/en/rest) as an example. First, it returns its data in JSON format.

```APL
      c←HttpCommand.New 'get' 'https://api.github.com/orgs/Dyalog'
      ⎕←r←c.Run ⍝ send the request
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 1101]
     r.Headers HttpCommand.Lookup 'content-type' ⍝ what's the content-type?
application/json; charset=utf-8
      50↑r.Data ⍝ take a look at the data
{"login":"Dyalog","id":4189495,"node_id":"MDEyOk9y
      d←⎕JSON r.Data
      d.(name public_repos)
 Dyalog  47
```



##### HTTP Basic Authentication
##### Token-based Authentication



### Interacting with Jarvis

### Downloading a Web Page

### Downloading a File

### Downloading a Large File

### Streaming

### Redirections

### Authentication
