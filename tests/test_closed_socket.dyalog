 {r}←test_closed_socket dummy;t;result;port;url
 url←'http://localhost:',⍕port←8090 Using HttpServer
 result←#.HttpCommand.Get url,'/closed_socket_test'
 t←#.httpcommand_test
 r←1119 t.check result.rc