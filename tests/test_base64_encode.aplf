 {r}←test_basic64_encode dummy;t
 t←#.httpcommand_test
 r←{
  result ← #.HttpCommand.Get t._httpbin,'base64/',#.HttpCommand.Base64Encode ⎕ucs ⍵
  (0 200 ⍵) t.check result.(rc HttpStatus Data)
 }'Hello, World!'