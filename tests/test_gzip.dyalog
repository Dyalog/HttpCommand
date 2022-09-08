 {r}←test_gzip dummy;result;t
 t←#.httpcommand_test
 result←#.HttpCommand.Get t._httpbin,'gzip'
 r←(0 200,t._true,(⊂'gzip'))t.check result.(rc HttpStatus),((t.fromJSON result.Data).gzipped),⊂result.GetHeader'content-encoding'
