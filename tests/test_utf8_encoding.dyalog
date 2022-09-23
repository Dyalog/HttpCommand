 {r}←test_utf8_encoding dummy;result;t
 t←#.httpcommand_test
 result←#.HttpCommand.Get t._httpbin,'encoding/utf8'
 r←(0 200 7808 'text/html; charset=utf-8') t.check result.(rc,HttpStatus,⍴Data),⊂result.GetHeader 'Content-Type'