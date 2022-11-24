r←test_keepalive dummy;t;c;result                                         
t←#.httpcommand_test                                                      
c←#.HttpCommand.New'get'(t._httpbin,'/get')                               
c.KeepAlive←1                                                             
result←c.Run                                                              
r←'Connection header unset'/⍨1(~∊)'Connection' 'keep-alive'⍷result.Headers
r⍪←0 200 t.check result.(rc HttpStatus)                                   
