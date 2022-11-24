{r}←test_ping dummy;t;result
t←#.httpcommand_test
result←#.HttpCommand.Get t.localhost,'ping'
r←0 200 'pong't.check result.(rc HttpStatus Data)
