 {r}←test_basic_auth dummy;result;c;t
 t←#.httpcommand_test
 c←#.HttpCommand.New'get'(t._httpbin,'basic-auth/user/password')
:If ∨/'WWW-Authenticate'⍷∊(c.Run).Headers
 'base64'⎕cy'dfns'
  'Authorization' c.SetHeader 'Basic ',base64 ⎕ucs 'user:password'
  result ← c.Run
  r←0 200 t.check result.(rc HttpStatus)
:EndIf