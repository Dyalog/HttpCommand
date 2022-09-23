 {r}←test_basic64_encode dummy;t
 t←#.httpcommand_test
 'base64'⎕cy'dfns'
 r←{
  result ← #.HttpCommand.Get t._httpbin,'base64/',base64 ⎕ucs ⍵
  (0 200 ⍵) t.check result.(rc HttpStatus Data)
 }'Hello, World!'