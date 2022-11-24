{r}←test_basic_auth dummy;c;t                                  
t←#.httpcommand_test                                           
c←#.HttpCommand.New'get'(t._httpbin,'basic-auth/user/password')
c.AuthType←'basic'                                             
:If ∨/'WWW-Authenticate'⍷∊(c.Run).Headers                      
    c.Auth←#.HttpCommand.Base64Encode ⎕UCS'user:password'      
    r←0 200 t.check(c.Run).(rc HttpStatus)                     
:EndIf                                                         
