{r}←test_json_type dummy;result;t
t←#.httpcommand_test
result←#.HttpCommand.Get t._httpbin,'encoding/utf8'
r←(0 200 'text/html; charset=utf-8')t.check result.(rc HttpStatus),⊂result.GetHeader'Content-Type'
