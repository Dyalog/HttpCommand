 {r}←test_closed_socket dummy;result;port;url
 url←'http://localhost:',⍕port←8090 Using HttpServer
 result←HttpCommand.Get url,'/closed_socket_test'
 ∘∘∘
