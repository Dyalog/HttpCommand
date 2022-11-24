{r}←test_ping dummy;t;result;port;url
url←'http://localhost:8090'
result←#.HttpCommand.Get url,'/ping'
t←#.httpcommand_test
r←0 200 'pong't.check result.(rc HttpStatus Data)
