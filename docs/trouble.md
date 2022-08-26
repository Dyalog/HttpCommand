In a perfect world, all HTTP requests would be well-formed, target hosts would be available, and APIs well-documented.  Unfortunately, we don't live in a perfect world and so, in this section, we attempt to provide you with some guidance for troubleshooting requests that aren't working as you expect.

The result namespace returned by `HttpCommand.Run` contains information that may help in troubleshooting. The display format of the result contains some useful information:
* `rc` is the `HttpCommand`'s return code
* `msg` is a diagnostic message if `rc≠0`
* `HTTP Status` indicates the host's HTTP return code and status message
* `⍴Data` indicates the shape of the payload, if any, received in the response. This is the shape of the payload data after any automatic conversion done by `HttpCommand`.   
#### First check `rc` and `msg`
If `rc` is not 0, `msg` should have relevant information about what went wrong. `rc` values less than 0 indicate a problem that wasn't Conga-related. `rc` values greater than 0 are the Conga return code if there was a Conga-related error.
```
      HttpCommand.Get ''
[rc: ¯1 | msg: No URL specified | HTTP Status:  "" | ⍴Data: 0]

      HttpCommand.Get 'non_existent_url'
[rc: 1106 | msg: Conga client creation failed  ERR_INVALID_HOST  Host 
identification not resolved  | HTTP Status:  "" | ⍴Data: 0]
```
#### Check `HttpMessage` and `Data`
If `rc=0`, but `HttpStatus` is not what you expect, examine both `HttpMessage` and `Data`.  In the example below, GitHub returns a URL pointing to their API documentation for getting information about an organization.
``` 
      ⊢r ← HttpCommand.Get 'https://api.github.com/orgs/bloofo'
[rc: 0 | msg:  | HTTP Status: 404 "Not Found" | ⍴Data: 109]
      r.HttpMessage
Not Found
      r.Data
{"message":"Not Found","documentation_url":"https://docs.github.com/rest/reference/orgs#get-an-organization"}
```
#### Examine the request that `HttpCommand` will send
It can be useful to examine the actual request that `HttpCommand` will send to the host. Many web services will publish sample requests that you can use for comparison. Check that the headers, particularly `content-type`, are correct.

The instance setting `RequestOnly` controls whether `HttpCommand` will send the request to the host or simply return the request that _would_ be sent to the host. You can set `RequestOnly` in several ways:
* Pass 1 as the optional left argument to the shortcut methods `Get`, `GetJSON`, or `Do`.
```
       method ← 'post'
       url ← 'www.someurl.net'
       payload ← ⍳10
       headers ← 'a-header' 'some value'
       1 HttpCommand.GetJSON method url payload headers
POST / HTTP/1.1
a-header: some value
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
#### Debug Mode
Setting `HttpCommand.Debug←1` will disable `HttpCommand`'s error checking and cause `HttpCommand` to suspend if and where an error occurs.

Setting `HttpCommand.Debug←2` will cause `HttpCommand` to suspend just before it attempts to create the client connection to the host.  This will give you the opportunity to examine the request's state and step through the code.

__Note:__ `HttpCommand.Debug` is a shared setting and will affect all instances of `HttpCommand`.