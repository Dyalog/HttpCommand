 {r}←test_basic64_encode dummy;result;t
 t←#.httpcommand_test
 'base64'⎕cy'dfns'
 result←#.HttpCommand.Get t._httpbin,'base64/',base64 ⎕ucs 'io delenda est'
 r←0 200 'io delenda est' t.check result.(rc HttpStatus Data)