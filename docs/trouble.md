In a perfect world, all HTTP requests would be well-formed, their target hosts would be up, and their APIs well-documented.  Unfortunately, we don't live in a perfect world and so, in this section, we attempt to provide you with some guidance for troubleshooting requests that aren't working as you expect.
#### Check `rc` and `msg`
If `rc` is non-0, `msg` should have relevant information about what went wrong
```
      ⎕←r←HttpCommand.Get ''
[rc: ¯1 | msg: No URL specified | HTTP Status:  "" | ⍴Data: 0]
      r.msg
No URL specified
```
#### Check `HttpMessage` and `Data`
If `rc=0`, but `HttpStatus` is not what you expect, examine both `HttpMessage` and `Data`.  In the example below, GitHub returns a URL pointing to their API documentation for getting information about an organization.
``` 
      ⎕←r←HttpCommand.Get 'https://api.github.com/orgs/bloofo'
[rc: 0 | msg:  | HTTP Status: 404 "Not Found" | ⍴Data: 109]
      r.HttpMessage
Not Found
      r.Data
{"message":"Not Found","documentation_url":"https://docs.github.com/rest/reference/orgs#get-an-organization"}
```
#### Examine the request that `HttpCommand` will send
It can be useful to examine the actual request that `HttpCommand` will send to the host, particularly when interacting with web services that publish sample requests. The instance setting `RequestOnly` controls whether `HttpCommand` will send the request to the host or simply return the request that _would_ be sent to the host. You can make use of `RequestOnly` in several ways:

* Pass 1 as the optional left argument to the shortcut methods `Get`, `GetJSON`, or `Do`.
```
       1 HttpCommand.GetJSON 'post' 'www.someurl.net' (⍳10) ('a-header' 'header value')
POST / HTTP/1.1
a-header: header value
Host: www.someurl.net
User-Agent: Dyalog/HttpCommand
Accept: */*
Content-Type: application/json;charset=utf-8
Content-Length: 22

[1,2,3,4,5,6,7,8,9,10]
```
* Pass 1 as the optional left argument to the `New` shortcut method and then run the `Run` method. Be sure to set `RequestOnly` back to 0 before sending the request to the host.
```
      c ← 1 HttpCommand.New 'get' 'dyalog.com'
      c.Run
GET / HTTP/1.1
Host: dyalog.com
User-Agent: Dyalog/HttpCommand
Accept: */*


      c.RequestOnly←0
      c.Run
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 20684]
      
```

* Use the `Show` instance method. 
```
      c ← HttpCommand.New ''
      c.URL ← 'someurl.com/stuff'
      c.Command ← 'get'
      c.Params ← 'name' 'Drake Mallard'
      'header-name' c.AddHeader 'header value'
      c.Show
GET /stuff?name=Drake%20Mallard HTTP/1.1
header-name: header value
Host: someurl.com
User-Agent: Dyalog/HttpCommand
Accept: */*

```

