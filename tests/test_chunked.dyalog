{r}←test_chunked dummy;result;t
t←#.httpcommand_test
result←#.HttpCommand.Get'https://www.httpwatch.com/httpgallery/chunked/chunkedimage.aspx'
r←0 200 'chunked't.check result.(rc HttpStatus),⊂result.GetHeader'transfer-encoding'
