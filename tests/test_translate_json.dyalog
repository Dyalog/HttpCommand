 {r}←test_translate_json dummy;result;c;t
 t←#.httpcommand_test
 c←#.HttpCommand.New 'get' (t._httpbin,'json')
 c.TranslateData←1
 result←c.Run
r←0 200 'application/json' t.check result.(rc,HttpStatus),⊂result.GetHeader 'Content-Type'
