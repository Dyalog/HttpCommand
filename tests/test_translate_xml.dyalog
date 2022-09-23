 {r}←test_translate_xml dummy;result;c;t
 t←#.httpcommand_test
 c←#.HttpCommand.New 'get' (t._httpbin,'xml')
 c.TranslateData←1
 result←c.Run
r←0 200 'application/xml' t.check result.(rc,HttpStatus),⊂result.GetHeader 'Content-Type'
