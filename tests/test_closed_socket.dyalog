{r}←test_closed_socket dummy;t;result
t←#.httpcommand_test   
result←#.HttpCommand.Get t.localhost,'closed_socket_test'
r←1119 t.check result.rc
