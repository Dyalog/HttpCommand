## Interacting with Web Services
A web service will generally have a published API which describes how to interact with the service.  This API will be your guide for how to build requests using `HttpCommand` to access the web service. In many cases, the API will also describe the format of the data it returns in the `content-type` header.

A web service may require authentication in order to gain access to certain resources or perform certain operations. GitHub is a good example of this - it does not require authentication to perform read-only queries on public resources, but authentication is necessary to perform write operations or to access private repositories.

Let's look at GitHub's [REST API](https://docs.github.com/en/rest) as an example. The GitHub API returns its data in JSON format. 

Note: If you run these same examples, you may get slightly different results because of updates to Dyalog's content on GitHub.

```
      c ← HttpCommand.New 'get' 'https://api.github.com/orgs/Dyalog'

      ⊢r ← c.Run ⍝ send the request
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 1101]

      r.Headers c.Lookup 'content-type' ⍝ check the content-type
application/json; charset=utf-8

      d←⎕JSON r.Data ⍝ convert the JSON 

      d.(name public_repos) 
 Dyalog  48

      html ← 'HTML' ('<img src="',d.avatar_url,'"/>')
      coord ← 'coord' 'pixel' ⋄ size ← 'size' (250 250)
      'h' ⎕WC 'HTMLRenderer' html coord size
```
![Dyalog avatar](img/avatar.png)

## Authentication/Authorization
The example above uses no authentication and therefore returns only publicly-available information. Many web services require some form of authentication to provide authorization to access private resources or functionality. Two common authentication schemes are "token-based" and "HTTP Basic".  

### HTTP Basic Authentication
Some web services allow you to use HTTP Basic authentication using userid and password credentials. **Any request that includes authentication data should be sent using HTTPS if possible**. `HttpCommand` allows you to specify these credentials in a few ways:

* in the `URL` by including `userid:password@` before the domain name
* by setting `AuthType` to `'Basic'` and </br>`Auth` to `HttpCommand.Base64Encode 'userid:password'`
* by including an "Authorization" header in the format</br>`'Basic ',HttpCommand.Base64Encode 'userid:password'`

The following examples use the "basic-auth" endpoint of the website [http://httpbin.org](http://httpbin.org). httpbin.org provides many useful endpoints for testing HTTP requests. In this case, the userid and password are concatenated to the URL so the endpoint can validate the credentials.

First, let's try using credentials in the URL...
```
      u ← 'userid'
      p ← 'password'
      endpoint ← 'httpbin.org/basic-auth/userid/password'

      ⊢url ← 'https://',u,':',p,'@',endpoint
https://userid:password@httpbin.org/basic-auth/userid/password
      
      ⊢r ← HttpCommand.Get url 
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 49]
      r.Data
{
  "authenticated": true, 
  "user": "user"
}
```
If we alter the URL so that the credentials don't match, we'll get a `401 "UNAUTHORIZED"` HTTP status.
```
      HttpCommand.Get url,'1'
[rc: 0 | msg:  | HTTP Status: 401 "UNAUTHORIZED" | ⍴Data: 0]
```
Now, let's try setting the "Authorization" header...
```
      ⊢credentials ← HttpCommand.Base64Encode u,':',p
dXNlcmlkOnBhc3N3b3Jk
      hdrs ← 'Authorization' ('Basic ',credentials)
      url ← 'https://',endpoint
      HttpCommand.Get url '' hdrs
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 49]
```
Finally, let's use the `AuthType` and `Auth` settings...
```
      h ← HttpCommand.New 'get' url ⍝ create an instance
      h.Auth ← credentials
      h.AuthType ← 'Basic'
      h.Run
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 49]
```
### Token-based Authentication
 One common authentication method uses tokens which are issued by the web service provider. Tokens should be protected just as you would protect your password. A token may have an expiration date after which you'll need to get a new token. **Any request that includes authentication data should be sent using HTTPS if possible**.

For this next example we'll use a [GitHub Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) which happens to provide more access to Dyalog's information on GitHub.

The API documentation for the web service you are using should provide information about the use of tokens. In GitHub's case, the token is passed in the HTTP request's "Authorization" header. `HttpCommand` allows you to specify the token either by creating an "Authorization" header or by setting the `Auth` configuration setting. If you set the `Auth` setting, `HttpCommand` will add the "Authorization" header automatically.

Let's assume that the token we're using in this example is in a variable named `token`. (Obviously, we are not going to publish the *actual* token here.) Also note if you plan on making several requests to the same web service, it's easier to create an instance of `HttpCommand`, set the `Auth` configuration setting, then set any other configuration settings and run the `Run` method for each request.

First, let's compare the difference between an authorized and a non-authorized request...
```APL
      ⊢HttpCommand.Get 'https://api.github.com/orgs/Dyalog'
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 1101]

      hdr←'authorization' ('Token ',token)

      ⊢HttpCommand.Get 'https://api.github.com/orgs/Dyalog' '' hdr
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 1804]
```
Note more data is returned for the authorized request. This additional data will include things like organizational and administrative information.

## Interacting with JSON-based Web Services
Many web services including those based on [Jarvis](https://github.com/Dyalog/Jarvis), Dyalog's web service framework, use JSON to format their request and response payloads. Normally, to interact with a JSON-based web service, you would set the "content-type" header of the request to "application/json" if the request has a payload; then you would process the response's JSON payload, possibly with `⎕JSON`.  

`HttpCommand`'s `GetJSON` method is designed to make it easy to to interact with such services.  `GetJSON` will convert an APL array request payload to JSON format and conversely convert a JSON response payload to APL. We saw in the [Interacting with Web Services](#interacting-with-web-services) example above that GitHub returns its result as JSON.

## Posting Data to a Web Service
So far we've only read data from GitHub using the HTTP GET method. The GitHub API also allows authenticated users to create and update information. In this example we will create a new repository using the HTTP POST method and our GitHub Personal Access Token. For security reasons, we will use the same `token` variable from the previous example. At the time of this writing, we are using the GitHub API documentation for [creating a repository for an authenticated user](https://docs.github.com/en/enterprise-server@3.1/rest/repos/repos#create-a-repository-for-the-authenticated-user) as a guide. 

For this example, we'll use a namespace, `args`, to specify all the settings for our request...  
```
      args←⎕NS ''
      args.Command            ← 'post'
      args.URL                ← 'https://api.github.com/user/repos'
      args.Params             ← ⎕NS ''
      args.Params.name        ← 'TestRepository'
      args.Params.description ← 'HttpCommand Example'
      args.Params.auto_init   ← ⊂'true' ⍝ APL's equivalent to JSON true
      ⊢r ← HttpCommand.GetJSON args
[rc: 0 | msg:  | HTTP Status: 401 "Unauthorized" | ⍴Data: ⍬]
```
Oops!  We didn't use our token for authentication and so the request was rejected as unauthorized. We also specify the authentication scheme as `'token'`, which is what the GitHub API uses.
```
      args.(AuthType Auth) ← 'Token' token
      ⊢r ← HttpCommand.GetJSON args
[rc: 0 | msg:  | HTTP Status: 201 "Created" | ⍴Data: ⍬]
```
Notice that the shape of the response's payload (Data) is `⍬`. This is because we used the `GetJSON` method and `HttpCommand` automatically converted the response's JSON payload into a Dyalog JSON object which contains all the information about the newly created repository...
```
      ]Box on
      r.Data.(name created_at)
┌──────────────┬────────────────────┐
│TestRepository│2022-08-01T21:23:08Z│
└──────────────┴────────────────────┘
```
## Downloading a File
If you want to download a file you can simply use `HttpCommand.Get` with the URL of the file and then write the response's payload to a local file.  Or, you can set the `OutFile` setting to the local file name and have `HttpCommand` write the file for you. This is especially advantageous for large files if the server uses "chunked" transfer encoding to send the payload in chunks. In that case, rather than buffering the entire payload in the workspace and then writing to the local file, `HttpCommand` will write each chunk out as it is received. 
```
      args←⎕NS '' 
      args.OutFile ← '/tmp/test.pdf'
      args.Command ← 'get' 
      args.URL     ← 'https://www.dyalog.com/uploads/files/student_competition/2021_problems_phase1.pdf'
      ⊢r ← HttpCommand.Do args
[rc: 0 | msg:  | HTTP Status: 200 "OK" | 179723 bytes written to c:/tmp/test.pdf]
```
## Twitter Example
The GitHub examples above used the default `AuthType` of `'Token'`. [Twitter's v2 REST API](https://developer.twitter.com/en/docs/twitter-api) uses OAuth 2.0's `'bearer'` authentication scheme.  In this example our super secret bearer token is stored in a variable named `bearerToken`. 
```
      apiURL ← 'https://api.twitter.com/2/' ⍝ set the base URL for each request
      c ← HttpCommand.New ''
      c.(AuthType Auth) ← 'bearer' bearerToken
```
First we need to get the id for the Twitter account we want to look at. Twitter returns its response payload in JSON, so we can have `HttpCommand` automatically convert the JSON into an APL object by setting `TranslateData` to 1. If there are no errors in the request, Twitter will put the response's data in an object called `'data'`. 
```
      c.TranslateData ← 1 ⍝ have HttpCommand translate known data types
      c.URL ← apiURL,'users/by?usernames=dyalogapl'
      ⊢id ← ⊃(c.Run).Data.data.id ⍝ get the id for user "dyalogapl"
36050079
      c.URL ← apiURL,'users/',id,'/tweets?tweet.fields=created_at'
      ⊢ r ← c.Run
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: ⍬]
      ≢ tweets ← r.Data.data ⍝ how many tweets were returned?      
10
      ↑(4↑tweets).((10↑created_at) (50↑text))
 2022-07-26  Remember to submit your solutions to the annual AP 
 2022-07-25  Dyalog ’22 – make sure you register for Dyalog ’22 
 2022-07-20  The APL practice problems site https://t.co/1SEoa5 
 2022-07-15  There are only two weeks until the 10% Early Bird  
```
