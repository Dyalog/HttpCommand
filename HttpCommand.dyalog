:Class HttpCommand
⍝ Description::
⍝ HttpCommand is a stand alone utility to issue HTTP commands and return their
⍝ results.  HttpCommand can be used to retrieve the contents of web pages,
⍝ issue calls to web services, and communicate with any service which uses the
⍝ HTTP protocol for communications.
⍝
⍝ N.B. requires Conga - the TCP/IP utility library (see Notes below)
⍝
⍝ Overview::
⍝ HttpCommand can be used in two ways:
⍝   1) Create an instance of HttpCommand using ⎕NEW
⍝      This gives you very fine control to specify the command's parameters
⍝      You then use the Run method to execute the request
⍝
⍝        h←⎕NEW HttpCommand                       ⍝ create an instance
⍝        h.(Command URL)←'get' 'www.dyalog.com'   ⍝ set the command parameters
⍝        r←h.Run                                  ⍝ run the request
⍝
⍝   2) Alternatively you can use the "Get" or "Do" methods which make it
⍝      easier to execute some of the more common use cases.
⍝        r←HttpCommand.Get 'www.dyalog.com'
⍝        r←HttpCommand.Do 'get' 'www.dyalog.com'
⍝
⍝ Constructor::
⍝        cmd←⎕NEW HttpCommand [(Command [URL [Params [Headers [Cert [SSLFlags [Priority]]]]]])]
⍝
⍝ Constructor Arguments::
⍝ All of the constructor arguments are also exposed as Public Fields
⍝
⍝   Command  - the case-insensitive HTTP command to issue
⍝              typically one of 'GET' 'POST' 'PUT' 'OPTIONS' 'DELETE' 'HEAD'
⍝
⍝   URL      - the URL to direct the command at
⍝              format is:  [HTTP[S]://][user:pass@]url[:port][/page[?query_string]]
⍝
⍝   Params   - the parameters to pass with the command
⍝              this can either be a URLEncoded character vector, or a namespace
⍝              containing the named parameters
⍝
⍝   Headers  - a vector of 2-element (header-name value) vectors
⍝              or a matrix of [;1] header-name [;2] values
⍝
⍝              these are any additional HTTP headers to send with the request
⍝              or headers whose default values you wish to override
⍝              headers that HttpCommand will set by default are:
⍝               User-Agent     : Dyalog/Conga
⍝               Accept         : */*
⍝               Content-Type   : application/x-www-form-urlencoded
⍝               Content-Length : length of the request body
⍝               Accept-Encoding: gzip, deflate
⍝
⍝   Cert     - if using SSL, this is an instance of the X509Cert class (see Conga SSL documentation)
⍝
⍝   SSLFlags - if using SSL, these are the SSL flags as described in the Conga documentation
⍝
⍝   Priority - if using SSL, this is the GNU TLS priority string (generally you won't change this from the default)
⍝
⍝ Notes on Params and query_string:
⍝ When using the 'GET' HTTP command, you may specify parameters using either the query_string or Params
⍝ Hence, the following are equivalent
⍝     HttpCommand.Get 'www.someplace.com?userid=fred'
⍝     HttpComment.Get 'www.someplace.com' ('userid' 'fred')
⍝
⍝ Additional Public Fields::
⍝   LocalDRC - if set, this is a reference to the DRC namespace from Conga - otherwise, we look for DRC in the workspace root
⍝   WaitTime - time (in seconds) to wait for the response (default 30)
⍝
⍝
⍝ The methods that execute HTTP requests - Do, Get, and Run - return a namespace containing the variables:
⍝   Data          - the response message payload
⍝   HttpVer       - the server HTTP version
⍝   HttpStatus    - the response HTTP status code (200 means OK)
⍝   HttpStatusMsg - the response HTTP status message
⍝   Headers       - the response HTTP headers
⍝   PeerCert      - the server (peer) certificate if running secure
⍝   rc            - the Conga return code (0 means no error)
⍝
⍝ Public Instance Methods::
⍝
⍝   result←Run            - executes the HTTP request
⍝   name AddHeader value  - add a header value to the request headers if it doesn't already exist
⍝
⍝ Public Shared Methods::
⍝
⍝   result←Get URL [Params [Headers [Cert [SSLFlags [Priority]]]]]
⍝
⍝   result←Do  Command URL [Params [Headers [Cert [SSLFlags [Priority]]]]]
⍝     Where the arguments are as described in the constructor parameters section.
⍝     Get and Do are shortcut methods to make it easy to execute an HTTP request on the fly.
⍝
⍝   r←Base64Decode vec     - decode a Base64 encoded string
⍝
⍝   r←Base64Encode vec     - Base64 encode a character vector
⍝
⍝   r←UrlDecode vec        - decodes a URL-encoded character vector
⍝
⍝   r←{name} UrlEncode arg - URL-encodes string(s)
⍝     name is an optional name
⍝     arg can be one of
⍝       - a character vector
⍝       - a vector of character vectors of name/value pairs
⍝       - a 2-column matrix of name/value pairs
⍝       - a namespace containing named variables
⍝     Examples:
⍝
⍝       UrlEncode 'Hello World!'
⍝ Hello%20World%21
⍝
⍝      'phrase' UrlEncode 'Hello World!'
⍝ phrase=Hello%20World%21
⍝
⍝       UrlEncode 'company' 'dyalog' 'language' 'APL'
⍝ company=dyalog&language=APL
⍝
⍝       UrlEncode 2 2⍴'company' 'dyalog' 'language' 'APL'
⍝ company=dyalog&language=APL
⍝
⍝       (ns←⎕NS '').(company language)←'dyalog' 'APL'
⍝       UrlEncode ns
⍝ company=dyalog&language=APL
⍝
⍝ Notes::
⍝ HttpCommand uses Conga for TCP/IP communications and supports both Conga 2 and Conga 3
⍝ Conga 2 uses the DRC namespace
⍝ Conga 3 uses either the Conga namespace or DRC namespace for backwards compatibility
⍝ HttpCommand will search for #.Conga and #.DRC and use them if they exist - or try to ⎕CY them if they do not
⍝ You can set the CongaRef public field to have HttpCommand use Conga or DRC located other than in the root of the workspace
⍝ Otherwise HttpCommand will attempt to copy Conga or DRC from the conga workspace supplied with Dyalog APL
⍝
⍝ Example Use Cases::
⍝
⍝ Retrieve the contents of a web page
⍝   result←HttpCommand.Get 'www.dyalog.com'
⍝
⍝ Update a record in a web service
⍝   cmd←⎕NEW HttpCommand                        ⍝ create an instance
⍝   cmd.(Command URL)←'PUT' 'www.somewhere.com' ⍝ set a couple of fields
⍝   (cmd.Params←⎕NS '').(id name)←123 'Fred'    ⍝ set the parameters for the "PUT" command
⍝   result←cmd.Run                              ⍝ and run it
⍝

    ⎕ML←⎕IO←1

    :field public Command←'GET'
    :field public Cert←⍬
    :field public SSLFlags←32
    :field public shared CongaRef←''
    :field public URL←''
    :field public Params←''
    :field public Headers←''
    :field public Priority←'NORMAL:!CTYPE-OPENPGP'
    :field public WaitTime←30
    :field public shared LDRC

    ∇ r←Version
      :Access public shared
      r←'HttpCommand' '2.1.1' '2017-04-26'
    ∇

    ∇ make
      :Access public
      :Implements constructor
    ∇

    ∇ make1 args
      :Access public
      :Implements constructor
      ⍝ args - [Command URL Params Headers Cert SSLFlags Priority]
      args←eis args
      Command URL Params Headers Cert SSLFlags Priority←7↑args,(⍴args)↓Command URL Params Headers Cert SSLFlags Priority
    ∇

    ∇ r←Run
      :Access public
      :If 0∊⍴Cert
          r←(Command HttpCmd)URL Params Headers
      :Else
          r←(Cert SSLFlags Priority)(Command HttpCmd)URL Params Headers
      :EndIf
    ∇

    ∇ r←Get args
    ⍝ Description::
    ⍝ Shortcut method to perform an HTTP GET request
    ⍝ args - [URL Params Headers Cert SSLFlags Priority]
      :Access public shared
      r←(⎕NEW ⎕THIS((⊂'GET'),eis args)).Run
    ∇

    ∇ r←Do args;cmd
    ⍝ Description::
    ⍝ Shortcut method to perform an HTTP request
    ⍝ args - [Command URL Params Headers Cert SSLFlags Priority]
      :Access public shared
      r←(⎕NEW ⎕THIS(eis args)).Run
    ∇


    ∇ r←{certs}(cmd HttpCmd)args;url;parms;hdrs;urlparms;p;b;secure;port;host;page;x509;flags;priority;pars;auth;req;err;chunked;chunk;buffer;chunklength;done;data;datalen;header;headerlen;rc;dyalog;FileSep;donetime;congaCopied;formContentType;ind;len;mode;obj;evt;dat;ref;nc;ns;n;class;clt;z
⍝ issue an HTTP command
⍝ certs - optional [X509Cert [SSLValidation [Priority]]]
⍝ args  - [1] URL in format [HTTP[S]://][user:pass@]url[:port][/page[?query_string]]
⍝         {2} parameters is using POST - either a namespace or URL-encoded string
⍝         {3} HTTP headers in form {↑}(('hdr1' 'val1')('hdr2' 'val2'))
⍝ Makes secure connection if left arg provided or URL begins with https:
     
⍝ Result: (conga return code) (HTTP Status) (HTTP headers) (HTTP body) [PeerCert if secure]
      r←⎕NS''
      r.(rc HttpVer HttpStatus HttpStatusMsg Headers Data PeerCert)←¯1 '' 400(⊂'bad request')(0 2⍴⊂'')''⍬
     
      args←eis args
      (url parms hdrs)←args,(⍴args)↓''(⎕NS'')''
      →0⍴⍨0∊⍴url ⍝ exit early if no URL
     
      congaCopied←0
     
      :If ''≡{6::⍵ ⋄ LDRC}'' ⍝ if
          :If 0∊⍴CongaRef
              class←⊃⊃⎕CLASS ⎕THIS
              ref nc←{1↑¨⍵{(×⍵)∘/¨⍺ ⍵}#.⎕NC ⍵}ns←'Conga' 'DRC'
              :Select ⊃⌊nc
              :Case 9
                  :If ref≡,⊂'Conga'
                      LDRC←#.Conga.Init''
                  :Else
                      LDRC←#⍎⊃ref ⋄ {}LDRC.Init''
                  :EndIf
              :Case 0
                  FileSep←'/\'[1+'Win'≡3↑1⊃#.⎕WG'APLVersion']
                  dyalog←{⍵,(-FileSep=¯1↑⍵)↓FileSep}2 ⎕NQ'.' 'GetEnvironment' 'DYALOG'
                  :For n :In ns
                      :Trap 0
                          n class.⎕CY dyalog,'ws/conga'
                          congaCopied←1
                          :Leave
                      :EndTrap
                  :EndFor
                  :If ~congaCopied
                      ⎕←'*** Neither Conga nor DRC was found'
                      →0
                  :EndIf
                  LDRC←class⍎n
              :Else
                  ⎕←'*** Neither Conga nor DRC was found'
                  →0
              :EndSelect
          :ElseIf 9=⎕NC'CongaRef'
              LDRC←CongaRef
          :Else
              LDRC←⍎⍕CongaRef
          :EndIf
      :EndIf
     
      url←,url
      cmd←uc,cmd
     
      (url urlparms)←{⍵{((¯1+⍵)↑⍺)(⍵↓⍺)}⍵⍳'?'}url
     
      :If 'GET'≡cmd   ⍝ if HTTP command is GET, all parameters are passed via the URL
          urlparms,←{0∊⍴⍵:⍵ ⋄ '&',⍵}UrlEncode parms
          parms←''
      :EndIf
     
      urlparms←{0∊⍴⍵:'' ⋄ ('?'=1↑⍵)↓'?',⍵}{⍵↓⍨'&'=⊃⍵}urlparms
     
     GET:
      p←(∨/b)×1+(b←'//'⍷url)⍳1
      secure←{6::⍵ ⋄ ⍵∨0<⍴,certs}(lc(p-2)↑url)≡'https:'
      port←(1+secure)⊃80 443 ⍝ Default HTTP/HTTPS port
      url←p↓url              ⍝ Remove HTTP[s]:// if present
      (host page)←'/'split url,(~'/'∊url)/'/'    ⍝ Extract host and page from url
     
      :If 0=⎕NC'certs' ⋄ certs←'' ⋄ :EndIf
     
      :If secure
          x509 flags priority←3↑certs,(⍴,certs)↓(⎕NEW LDRC.X509Cert)32 'NORMAL:!CTYPE-OPENPGP'  ⍝ 32=Do not validate Certs
          pars←('x509'x509)('SSLValidation'flags)('Priority'priority)
      :Else ⋄ pars←''
      :EndIf
     
      :If '@'∊host ⍝ Handle user:password@host...
          auth←'Authorization: Basic ',(Base64Encode(¯1+p←host⍳'@')↑host),NL
          host←p↓host
      :Else ⋄ auth←''
      :EndIf
     
      (host port)←port{(⍴⍵)<ind←⍵⍳':':⍵ ⍺ ⋄ (⍵↑⍨ind-1)(1⊃2⊃⎕VFI ind↓⍵)}host ⍝ Check for override of port number
     
      hdrs←makeHeaders hdrs
      hdrs←'User-Agent'(hdrs addHeader)'Dyalog/Conga'
      hdrs←'Accept'(hdrs addHeader)'*/*'
     
      :If ~0∊⍴parms         ⍝ if we have any parameters
          :If cmd≢'GET'     ⍝ and not a GET command
              ⍝↓↓↓ specify the default content type (if not already specified)
              hdrs←'Content-Type'(hdrs addHeader)formContentType←'application/x-www-form-urlencoded'
              :If formContentType≡hdrs Lookup'Content-Type'
                  parms←UrlEncode parms
              :EndIf
              hdrs←'Content-Length'(hdrs addHeader)⍴parms
          :EndIf
      :EndIf
     
      hdrs←'Accept-Encoding'(hdrs addHeader)'gzip, deflate'
     
      req←cmd,' ',(page,urlparms),' HTTP/1.1',NL,'Host: ',host,NL
      req,←fmtHeaders hdrs
      req,←auth
     
      donetime←⌊⎕AI[3]+1000×WaitTime ⍝ time after which we'll time out
     
      mode←'text' 'http'⊃⍨1+3≤⊃LDRC.Version ⍝ Conga 3.0 introduced native HTTP mode
     
      :If 0=⊃(err clt)←2↑rc←LDRC.Clt''host port mode 100000,pars ⍝ 100,000 is max receive buffer size
          :If 0=⊃rc←LDRC.Send clt(req,NL,parms)
              chunked chunk buffer chunklength←0 '' '' 0
              done data datalen headerlen header←0 ⍬ 0 0 ⍬
     
              :Repeat
                  :If ~done←0≠err←1⊃rc←LDRC.Wait clt 5000            ⍝ Wait up to 5 secs
                      (err obj evt dat)←4↑rc
                      :Select evt
              ⍝ Conga 3.0+ handling
                      :Case 'HTTPHeader'
                          (headerlen header)←DecodeHeader dat
                          datalen←⊃(toNum header Lookup'Content-Length'),¯1 ⍝ ¯1 if no content length not specified
                          chunked←∨/'chunked'⍷header Lookup'Transfer-Encoding'
                          done←chunked<datalen<1
                      :Case 'HTTPBody'
                          data←dat
                          done←1
                      :Case 'HTTPChunk'
                          data,←dat
                      :Case 'HTTPTrailer'
                          header⍪←2⊃DecodeHeader dat
                          done←1
     
              ⍝ Pre-Conga 3.0 handling
                      :CaseList 'Block' 'BlockLast'             ⍝ If we got some data
                          :If chunked
                              chunk←4⊃rc
                          :ElseIf 0<⍴data,←4⊃rc
                          :AndIf 0=headerlen
                              (headerlen header)←DecodeHeader data
                              :If 0<headerlen
                                  data←headerlen↓data
                                  :If chunked←∨/'chunked'⍷header Lookup'Transfer-Encoding'
                                      chunk←data
                                      data←''
                                  :Else
                                      datalen←⊃(toNum header Lookup'Content-Length'),¯1 ⍝ ¯1 if no content length not specified
                                  :EndIf
                              :EndIf
                          :EndIf
                          :If chunked
                              buffer,←chunk
                              :While done<¯1≠⊃(len chunklength)←getchunklen buffer
                                  :If (⍴buffer)≥4+len+chunklength
                                      data,←chunklength↑(len+2)↓buffer
                                      buffer←(chunklength+len+4)↓buffer
                                      :If done←0=chunklength ⍝ chunked transfer can add headers at the end of the transmission
                                          header←header⍪2⊃DecodeHeader buffer
                                      :EndIf
                                  :EndIf
                              :EndWhile
                          :Else
                              done←done∨'BlockLast'≡3⊃rc                        ⍝ Done if socket was closed
                              :If datalen>0
                                  done←done∨datalen≤⍴data ⍝ ... or if declared amount of data rcvd
                              :Else
                                  done←done∨(∨/'</html>'⍷data)∨(∨/'</HTML>'⍷data)
                              :EndIf
                          :EndIf
     
                      :Case 'Timeout'
                          done←⎕AI[3]>donetime
     
                      :Else  ⍝ This shouldn't happen
                          ⎕←'*** Unhandled event type - ',evt
                          ∘∘∘  ⍝ !! Intentional !!
                      :EndSelect
     
                  :ElseIf 100=err ⍝ timeout?
                      done←⎕AI[3]>donetime
                  :Else           ⍝ some other error (very unlikely)
                      ⎕←'*** Wait error ',,⍕rc
                  :EndIf
              :Until done
     
              :If 0=err
                  :Trap 0 ⍝ If any errors occur, abandon conversion
                      :Select header Lookup'content-encoding' ⍝ was the response compressed?
                      :Case 'deflate'
                          data←120 ¯100{(2×⍺≡2↑⍵)↓⍺,⍵}83 ⎕DR data ⍝ append 120 156 signature because web servers strip it out due to IE
                          data←fromutf8 256|¯2(219⌶)data
                      :Case 'gzip'
                          data←fromutf8 256|¯3(219⌶)83 ⎕DR data
                      :Else
                          :If ∨/'charset=utf-8'⍷header Lookup'content-type'
                              data←'UTF-8'⎕UCS ⎕UCS data ⍝ Convert from UTF-8
                          :EndIf
                      :EndSelect
     
                      :If {(⍵[3]∊'12357')∧'30 '≡⍵[1 2 4]}4↑{⍵↓⍨⍵⍳' '}(⊂1 1)⊃header ⍝ redirected? (HTTP status codes 301, 302, 303, 305, 307)
                          url←'location'{(⍵[;1]⍳⊂⍺)⊃⍵[;2],⊂''}header ⍝ use the "location" header field for the URL
                          :If ×≢url
                              {}LDRC.Close clt
                              →GET
                          :EndIf
                      :EndIf
     
                  :EndTrap
     
                  r.(HttpVer HttpStatus HttpStatusMsg)←{⎕ML←3 ⋄ ⍵⊂⍨{⍵∨2<+\~⍵}⍵≠' '}(⊂1 1)⊃header
                  r.HttpStatus←toNum r.HttpStatus
                  header↓⍨←1
     
                  :If secure
                  :AndIf 0=⊃z←LDRC.GetProp clt'PeerCert'
                      r.PeerCert←2⊃z
                  :EndIf
              :EndIf
     
              r.(Headers Data)←header data
     
          :Else
              ⎕←'*** Connection failed ',,⍕rc
          :EndIf
          {}LDRC.Close clt
      :Else
          ⎕←'*** Client creation failed ',,⍕rc
      :EndIf
      r.rc←1⊃rc
    ∇

    NL←⎕UCS 13 10
    fromutf8←{0::(⎕AV,'?')[⎕AVU⍳⍵] ⋄ 'UTF-8'⎕UCS ⍵} ⍝ Turn raw UTF-8 input into text
    utf8←{3=10|⎕DR ⍵: 256|⍵ ⋄ 'UTF-8' ⎕UCS ⍵}
    sint←{⎕io←0 ⋄ 83=⎕DR ⍵:⍵ ⋄ 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 ¯128 ¯127 ¯126 ¯125 ¯124 ¯123 ¯122 ¯121 ¯120 ¯119 ¯118 ¯117 ¯116 ¯115 ¯114 ¯113 ¯112 ¯111 ¯110 ¯109 ¯108 ¯107 ¯106 ¯105 ¯104 ¯103 ¯102 ¯101 ¯100 ¯99 ¯98 ¯97 ¯96 ¯95 ¯94 ¯93 ¯92 ¯91 ¯90 ¯89 ¯88 ¯87 ¯86 ¯85 ¯84 ¯83 ¯82 ¯81 ¯80 ¯79 ¯78 ¯77 ¯76 ¯75 ¯74 ¯73 ¯72 ¯71 ¯70 ¯69 ¯68 ¯67 ¯66 ¯65 ¯64 ¯63 ¯62 ¯61 ¯60 ¯59 ¯58 ¯57 ¯56 ¯55 ¯54 ¯53 ¯52 ¯51 ¯50 ¯49 ¯48 ¯47 ¯46 ¯45 ¯44 ¯43 ¯42 ¯41 ¯40 ¯39 ¯38 ¯37 ¯36 ¯35 ¯34 ¯33 ¯32 ¯31 ¯30 ¯29 ¯28 ¯27 ¯26 ¯25 ¯24 ¯23 ¯22 ¯21 ¯20 ¯19 ¯18 ¯17 ¯16 ¯15 ¯14 ¯13 ¯12 ¯11 ¯10 ¯9 ¯8 ¯7 ¯6 ¯5 ¯4 ¯3 ¯2 ¯1[utf8 ⍵]}
    lc←(819⌶) ⍝ lower case conversion
    uc←1∘lc   ⍝ upper case conversion
    dlb←{(+/∧\' '=⍵)↓⍵} ⍝ delete leading blanks
    split←{(p↑⍵)((p←¯1+⍵⍳⍺)↓⍵)} ⍝ split ⍵ on first occurrence of ⍺
    h2d←{⎕IO←0 ⋄ 16⊥'0123456789abcdef'⍳lc ⍵} ⍝ hex to decimal
    getchunklen←{¯1=len←¯1+⊃(NL⍷⍵)/⍳⍴⍵:¯1 ¯1 ⋄ chunklen←h2d len↑⍵ ⋄ (⍴⍵)<len+chunklen+4:¯1 ¯1 ⋄ len chunklen}
    toNum←{0∊⍴⍵:⍬ ⋄ 1⊃2⊃⎕VFI ⍕⍵} ⍝ simple char to num
    makeHeaders←{0∊⍴⍵:0 2⍴⊂'' ⋄ 2=⍴⍴⍵:⍵ ⋄ ↑2 eis ⍵} ⍝ create header structure [;1] name [;2] value
    fmtHeaders←{0∊⍴⍵:'' ⋄ ∊{0∊⍴2⊃⍵:'' ⋄ NL,⍨(firstCaps 1⊃⍵),': ',⍕2⊃⍵}¨↓⍵} ⍝ formatted HTTP headers
    firstCaps←{1↓{(¯1↓0,'-'=⍵) (819⌶)¨ ⍵}'-',⍵} ⍝ capitalize first letters e.g. Content-Encoding
    addHeader←{'∘???∘'≡⍺⍺ Lookup ⍺:⍺⍺⍪⍺ ⍵ ⋄ ⍺⍺} ⍝ add a header unless it's already defined

    ∇ r←table Lookup name
    ⍝ lookup a name/value-table value by name, return '∘???∘' if not found
      :Access Public Shared
      r←table{(⍺[;2],⊂'∘???∘')⊃⍨(lc¨⍺[;1])⍳eis lc ⍵}name
    ∇

    ∇ name AddHeader value
    ⍝ add a header unless it's already defined
      :Access public
      Headers←makeHeaders Headers
      Headers←name(Headers addHeader)value
    ∇

    ∇ r←{a}eis w;f
    ⍝ enclose if simple
      :Access public shared
      f←{⍺←1 ⋄ ,(⊂⍣(⍺=|≡⍵))⍵}
      :If 0=⎕NC'a' ⋄ r←f w
      :Else ⋄ r←a f w
      :EndIf
    ∇

    ∇ r←Base64Encode w
    ⍝ Base64 Encode
      :Access public shared
      r←{⎕IO←0
          raw←⊃,/11∘⎕DR¨⍵
          cols←6
          rows←⌈(⊃⍴raw)÷cols
          mat←rows cols⍴(rows×cols)↑raw
          'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'[⎕IO+2⊥⍉mat],(4|-rows)⍴'='}w
    ∇

    ∇ r←Base64Decode w
    ⍝ Base64 Decode
      :Access public shared
      r←{
          ⎕IO←0
          {
              80=⎕DR' ':⎕UCS ⍵  ⍝ Unicode
              82 ⎕DR ⍵          ⍝ Classic
          }2⊥{⍉((⌊(⍴⍵)÷8),8)⍴⍵}(-6×'='+.=⍵)↓,⍉(6⍴2)⊤'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='{⍺⍳⍵∩⍺}⍵
      }w
    ∇

    ∇ r←DecodeHeader buf;len;d
      ⍝ Decode HTTP Header
      r←0(0 2⍴⊂'')
      :If 0<len←¯1+⊃{((NL,NL)⍷⍵)/⍳⍴⍵}buf
          d←(⍴NL)↓¨{(NL⍷⍵)⊂⍵}NL,len↑buf
          d←↑{((p-1)↑⍵)((p←⍵⍳':')↓⍵)}¨d
          d[;1]←lc¨d[;1]
          d[;2]←dlb¨d[;2]
          r←(len+4)d
      :EndIf
    ∇

    ∇ r←{name}UrlEncode data;⎕IO;z;ok;nul;m;noname
      ⍝ data is one of:
      ⍝      - a character vector to be encoded
      ⍝      - two character vectors of [name] [data to be encoded]
      ⍝      - a namespace containing variable(s) to be encoded
      ⍝ name is the optional name
      ⍝ r    is a character vector of the URLEncoded data
     
      :Access Public Shared
      ⎕IO←0
      noname←0
      :If 9.1=⎕NC⊂'data'
          data←{0∊⍴t←⍵.⎕NL ¯2:'' ⋄ ↑⍵{⍵(⍕,⍺⍎⍵)}¨t}data
      :Else
          :If 1≥|≡data
              :If noname←0=⎕NC'name' ⋄ name←'' ⋄ :EndIf
              data←name data
          :EndIf
      :EndIf
      nul←⎕UCS 0
      ok←nul,∊⎕UCS¨(⎕UCS'aA0')+⍳¨26 26 10
     
      z←⎕UCS'UTF-8'⎕UCS∊nul,¨,data
      :If ∨/m←~z∊ok
          (m/z)←↓'%',(⎕D,⎕A)[⍉16 16⊤⎕UCS m/z]
          data←(⍴data)⍴1↓¨{(⍵=nul)⊂⍵}∊z
      :EndIf
     
      r←noname↓¯1↓∊data,¨(⍴data)⍴'=&'
    ∇

    ∇ r←UrlDecode r;rgx;rgxu;i;j;z;t;m;⎕IO;lens;fill
      :Access public shared
      ⎕IO←0
      ((r='+')/r)←' '
      rgx←'[0-9a-fA-F]'
      rgxu←'%[uU]',(4×⍴rgx)⍴rgx ⍝ 4 characters
      r←(rgxu ⎕R{{⎕UCS 16⊥⍉16|'0123456789ABCDEF0123456789abcdef'⍳⍵}2↓⍵.Match})r
      :If 0≠⍴i←(r='%')/⍳⍴r
      :AndIf 0≠⍴i←(i≤¯2+⍴r)/i
          z←r[j←i∘.+1 2]
          t←'UTF-8'⎕UCS 16⊥⍉16|'0123456789ABCDEF0123456789abcdef'⍳z
          lens←⊃∘⍴¨'UTF-8'∘⎕UCS¨t  ⍝ UTF-8 is variable length encoding
          fill←i[¯1↓+\0,lens]
          r[fill]←t
          m←(⍴r)⍴1 ⋄ m[(,j),i~fill]←0
          r←m/r
      :EndIf
    ∇

    :Section Documentation Utilities
    ⍝ these are generic utilities used for documentation

    ∇ docn←ExtractDocumentationSections describeOnly;⎕IO;box;CR;sections
    ⍝ internal utility function
      ⎕IO←1
      CR←⎕UCS 13
      box←{{⍵{⎕AV[(1,⍵,1)/223 226 222],CR,⎕AV[231],⍺,⎕AV[231],CR,⎕AV[(1,⍵,1)/224 226 221]}⍴⍵}(⍵~CR),' '}
      docn←1↓⎕SRC ⎕THIS
      docn←1↓¨docn/⍨∧\'⍝'=⊃¨docn⍝ keep all contiguous comments
      docn←docn/⍨'⍝'≠⊃¨docn     ⍝ remove any lines beginning with ⍝⍝
      sections←{∨/'::'⍷⍵}¨docn
      :If describeOnly
          (sections docn)←((2>+\sections)∘/¨sections docn)
      :EndIf
      (sections/docn)←box¨sections/docn
      docn←∊docn,¨CR
    ∇

    ∇ r←Documentation
    ⍝ return full documentation
      :Access public shared
      r←ExtractDocumentationSections 0
    ∇

    ∇ r←Describe
    ⍝ return description only
      :Access public shared
      r←ExtractDocumentationSections 1
    ∇
    :EndSection
:EndClass
