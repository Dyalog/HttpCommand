 {r}←test_basic_auth dummy;result;c;t
 t←#.httpcommand_test
 c←#.HttpCommand.New'get'(t._httpbin,'basic-auth/user/password')
:If ∨/'WWW-Authenticate'⍷∊(c.Run).Headers
  'Authorization' c.SetHeader 'Basic ',#.HttpCommand.Base64Encode ⎕ucs 'user:password'
  result ← c.Run
  r←0 200 t.check result.(rc HttpStatus)
:EndIf