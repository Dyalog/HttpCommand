{r}←test_deflate dummy;result;t                                                                                                     
t←#.httpcommand_test                                                                                                                
result←#.HttpCommand.Get t._httpbin,'deflate'                                                                                       
r←(0 200,t._true,(⊂'deflate'))t.check result.(rc HttpStatus),((t.fromJSON result.Data).deflated),⊂result.GetHeader'content-encoding'
