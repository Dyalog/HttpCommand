### HTTPS
In the HTTP world, secure communications is accomplished by using the HTTPS protocol which uses Transport Layer Security (TLS) or Secure Sockets Layer (SSL) to encrypt communications. Both the client (`HttpCommand`) and the server use certificates for secure communications. The certificates serve a couple of purposes:

* They provide bi-directional encryption of the data sent across the link.
* They can help provide authentication of the client and/or the server. 

### `HttpCommand` Behavior
`HttpCommand` attempts to figure out if the connection is going to use HTTPS and what port to use based on:

* The protocol, if any, that you specify in `URL`.
* The port, if any, that you specify in `URL`.    
* Whether you have provided certificate information for the request.

`HttpCommand` will use HTTPS if

* You provide certificate information by using the `Cert` or `PublicCertFile` and `PrivateKeyFile` settings.  
* You specify `'https'` as the protocol.
* You don't specify a protocol, but do specify a port in `URL` of 443. 

`HttpCommand` will use port 443 if you do not specify a port in `URL` and `HttpCommand` has otherwise determined from the above criteria that the connection should use HTTPS.

### Encrypted Communications
In most cases, the use of certificates is hidden when using the HTTPS protocol because `HttpCommand` will automatically generate an "anonymous" certificate.  This is sufficient to provide secure, encrypted, communications.

### Authentication
Certificates can provide information about the identity of what is at the other end of the communications link. 

#### Server Identity
When `HttpCommand` uses HTTPS, the `PeerCert` element of the result namespace contains the server's certificate.  This can be used to validate the server is what you think it is. Most certificates will have a "chain" of parent certificates that show who issued the peer's certificate and any intermediate certificates.  If the final certificate in the chain is issued by a Trusted Root Certificate Authority the domain listed in the certificate has undergone validation by an entity that you can trust. 

Dyalog.com provides us with an example of a certificate chain:

```
      ⊢ r ← HttpCommand.Get 'https://dyalog.com'
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 23127]
      r.PeerCert  ⍝ Dyalog.com's certificate
 #.HttpCommand.[X509Cert]

      r.PeerCert.Chain
  #.HttpCommand.[X509Cert]  #.HttpCommand.[X509Cert]  #.HttpCommand.[X509Cert]  

     ⍪⊃r.PeerCert.Chain.Formatted.(Subject,' from ',Issuer)
 CN=*.dyalog.com from C=US,O=Let's Encrypt,CN=R3                                                              
 C=US,O=Let's Encrypt,CN=R3 from C=US,O=Internet Security Research Group,CN=ISRG Root X1                      
 C=US,O=Internet Security Research Group,CN=ISRG Root X1 from O=Digital Signature Trust Co.,CN=DST Root CA X3 
```
This shows that the certificate for `'*.dyalog.com'` was issued by Let's Encrypt whose certificate was issued by Internet Security Research Group whose certificate was issued by Digital Signature Trust Co and Digital Signature Trust Co is a Trusted Root Certificate Authority.

The good news is that in most cases you'll never need to look at the certificate chain, but it is available in the rare event that you need to verify the server you're connecting to.

#### Client Identity
If the service you connect to uses client certificate authentication, you will need to use a certificate when sending your HTTP request. Generally this certificate will be issued by the service provider.  A certificate consists of two parts - a public certificate file and a private key file. `HttpCommand` allows you to specify the certificate in two ways:

* provide the file names for the public certificate file and private key file in the [`PublicCertFile`](./conga-settings.md#publiccertfile) and [`PrivateKeyFile`](./conga-settings.md#privatekeyfile) settings respectively.
* specify the [`Cert`](./conga-settings.md#cert) setting as either:
    * An instance of Conga's `X509Cert` class
    * a 2-element vector of the names of the public certificate and private key files  

### Other HTTPS Settings
`HttpCommand` has two more settings [`SSLFlags`](./conga-settings.md#sslflags) and [`Priority`](./conga-settings.md#priority). The default values for these settings will suffice in almost all cases.  If you need to use something other than the default, refer to the [Conga User Guide](https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf).


### Further Reading
See the [Conga User Guide](https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf) Chapter 5 for more information on Conga's secure communications and `X509Cert`. 