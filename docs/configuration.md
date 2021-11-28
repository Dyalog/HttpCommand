# Configuration Parameters
We've split **HttpCommand**'s configuration parameters into three categories - Request, Conga, and Operational.

Examples below that use an instance of **HttpCommand** will refer to it as `h` as if created using
          h←HttpCommand.New ''

## Request-related Parameters
Request-related settings are settings you use to specify attributes of the HTTP request that `HttpCommand` will process.

| Command |   |
|:---|---|
|**Description**|The case-insensitive HTTP command (method) for the request. `Command` is not limited to standard HTTP methods like GET, POST, PUT, HEAD, OPTIONS, and DELETE, but can be any string. This makes it possible to support new HTTP methods as well as custom methods. For instance, if you were running a RESTful Jarvis service, you could implement custom RESTful methods and call them from **HttpCommand**.<br/><br/>The default value for `Command` is `'GET'`.|
|**Usage/Example(s)**|`h.Command←'POST'`|

| URL|   |
|:---|---|
|**Description**|The URL for the request (see [URLS](reference.md#urls))<br/><br/>The default value for `URL` is `''`.|
|**Usage/Example(s)**|`h.URL←'dyalog.com'`|

| Params| |
|:---|---|
|**Description**|The parameters or payload, if any, for the request. The interpretation of **Params** is first dependent on the **Command** setting and subsequently on the value of the content-type HTTP header. See [**Params** and **Command** and `content-type`](reference.md#params-and-command-and-content-type).<br/><br/>The defaul value for `Params` is `''`.|
|**Usage/Example(s)**|Example 1<br/>`h.Command←'get'`<br/>`h.Params←⎕NS ''`<br/>`Params.(name age)←'Drake Mallard' 42`<br/><br/>Example 2<br/>`h.Command←'post'`<br/>`'content-type' h.SetHeader 'application/json'`<br/>`h.Params←'testing' (⍳3) ⍝ HttpCommand will convert JSON`|

| Headers|   |
|:---|---|
|**Description**|The HTTP headers for the request. **HttpCommand** will supply certain default headers if not specified in **Headers**:<br/>`Host: URL-domain`<br/>`Content-Type: application/x-www-form-urlencoded`<br/>`User-Agent: Dyalog/HttpCommand`<br/>`Accept: */*`<br/>**Headers** headersThe URL for the request (see [URLS](reference.md#urls))|
|**Usage/Example(s)**|`h.URL←'dyalog.com'`|
    :field public Headers←0 2⍴⊂''                  ⍝ request headers - name, value
    :field public ContentType←''                   ⍝ request content-type
    :field public Cookies←⍬                        ⍝ request cookies - vector of namespaces

⍝ Conga-related fields
    :field public BufferSize←100000                ⍝ Conga buffersize
    :field public DOSLimit←¯1                      ⍝ use Conga default DOSLimit (1MB)
    :field public Timeout←5000                     ⍝ Timeout in ms on Wait call
    :field public Cert←⍬                           ⍝ X509 instance if using HTTPS
    :field public SSLFlags←32                      ⍝ SSL/TLS flags - 32 = accept cert without checking it
    :field public Priority←'NORMAL:!CTYPE-OPENPGP' ⍝ GnuTLS priority string
    :field public PublicCertFile←''                ⍝ if not using an X509 instance, this is the client public certificate file
    :field public PrivateKeyFile←''                ⍝ if not using an X509 instance, this is the client private key file
    :field public shared CongaRef←''               ⍝ user-supplied reference to Conga library
    :field public shared LDRC                      ⍝ HttpCommand-set reference to Conga after CongaRef has been resolved
    :field public shared CongaPath←''              ⍝ path to user-supplied conga workspace (assumes shared libraries are in the same path)

⍝ Operational fields
    :field public SuppressHeaders←0                ⍝ set to 1 to suppress HttpCommand-supplied default request headers
    :field public WaitTime←30                      ⍝ seconds to wait for a response before timing out, negative means reset timeout if any activity
    :field public RequestOnly←¯1                   ⍝ set to 1 if you only want to return the generated HTTP request, but not actually send it
    :field public OutFile←''                       ⍝ name of file to send payload to (or to buffer to when streaming) same as ⎕NPUT right argument
    :field public MaxRedirections←10               ⍝ set to 0 if you don't want to follow any redirected references, ¯1 for unlimited
    :field public KeepAlive←1                      ⍝ default to not close client connection
    :field public shared Debug←0                   ⍝ set to 1 to disable trapping


## Conga-related Parameters

## Operational Parameters