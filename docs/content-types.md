If your HTTP request has a payload and you do not specify the content type, `HttpCommand` will attempt to determine whether to use a content type of `'application/json'` or `'application/x-www-form-urlencoded'`.

This may be fine for interactively tinkering in the APL session. But when running `HttpCommand` under program control you should **explicitly specify the content type** for the payload by either setting `ContentType` or adding a `content-type` header. 

The exception to this is when using `GetJSON` which is specifically intended to interact with JSON-based web services and will use a default content type of `application/json`. 

### Special Treatment of Content Type `application/json` 
If you specify a content type of `'application/json'`, `HttpCommand` will automatically convert a non-JSON `Params` setting to JSON. In the rare case where `Params` is an APL character vector that happens to represent valid JSON, you should convert it yourself using `1 ⎕JSON`.

### Special Treatment of Content Type `multipart/form-data`
Content type `multipart/form-data` is commonly used to transfer files to a server or to send multiple types of content in the request payload. If you specify a content type of `'multipart/form-data'`:

* `Params` must be a namespace with named elements.
* Each element in `Params` consists of the data for the element optionally followed by a content type for the element.
* To send a file, prefix the file name with either:
    * `@` to upload the file's content and its name
    * `<` to upload just the file's content
* If you do not specify a content type for the file, `HttpCommand` will use a content type of `'text/plain'` if the extension of the file is .txt, otherwise it will use a content type of `'application/octet-stream'`. 

In the example below: 

* Extra newlines have been removed for compactness.
* The file `/tmp/foo.txt` contains `Hello World`.
* We create 4 parts to be sent with the request:
    * a simple string
    * a named file - both the content and file name will be sent
    * an unnamed file - only the content will be sent
    * a JSON array (with content type 'application/json')
```
      h←HttpCommand.New 'post' 'someurl.com'
      p←⎕NS ''                     ⍝ create a namespace
      p.string←'/tmp/foo.txt'       ⍝ just a value
      p.namedfile←'@/tmp/foo.txt'   ⍝ @ = include the file name
      p.unnamedfile←'</tmp/foo.txt' ⍝ < = do not include the file name
      p.json←'[1,2,3]' 'application/json' ⍝ value and content type
      h.Params←p                    ⍝ assign the request Params
      h.ContentType←'multipart/form-data' ⍝ 
      h.Show
POST / HTTP/1.1
Host: someurl.com                                                                                              
User-Agent: Dyalog-HttpCommand/5.6.0
Accept: */*
Accept-Encoding: gzip, deflate
Content-Type: multipart/form-data; boundary=rgt7DIuxBqLFsveaLM0fBcR7gdvahhUfbtmuQ9UMEZvv9kDVrd
Content-Length: 631

--rgt7DIuxBqLFsveaLM0fBcR7gdvahhUfbtmuQ9UMEZvv9kDVrd
Content-Disposition: form-data; name="json"
Content-Type: application/json                                                                                              
[1,2,3]

--rgt7DIuxBqLFsveaLM0fBcR7gdvahhUfbtmuQ9UMEZvv9kDVrd
Content-Disposition: form-data; name="namedfile"; filename="foo.txt"
Content-Type: text/plain
Hello World

--rgt7DIuxBqLFsveaLM0fBcR7gdvahhUfbtmuQ9UMEZvv9kDVrd
Content-Disposition: form-data; name="string"                                                 
/tmp/foo.txt

--rgt7DIuxBqLFsveaLM0fBcR7gdvahhUfbtmuQ9UMEZvv9kDVrd
Content-Disposition: form-data; name="unnamedfile"
Content-Type: text/plain
Hello World

--rgt7DIuxBqLFsveaLM0fBcR7gdvahhUfbtmuQ9UMEZvv9kDVrd--
```