{r}←test_maxpayloadsize dummy;t;result;c

t←#.httpcommand_test
c←#.HttpCommand.New 'get' ('http://httpbin.org/json') ⍝ Response has a content-type, MaxPayloadSize should compare against it.
c.MaxPayloadSize←256
result←c.Run
r←¯1 'Payload length exceeds MaxPayloadSize' 200 '' t.check result.(rc msg HttpStatus Data)