r←test_params dummy;t;c;ns
r←''
t←#.httpcommand_test
c←#.HttpCommand.New 'post' (t._httpbin,'post')

c.Params ← 'key' ('value',⎕ucs ⍳255)

⍝ content-type is ambigious, so HttpCommand defaults to 'www-form-urlencoded'
:If 'application/x-www-form-urlencoded' ≢ t.getContentType c.Show
 r←'incorrect Content-Type was assumed.'
 →0
:EndIf

:If c.Params ≢ #.HttpCommand.UrlDecode¨@{0 1}{'='(≠⊆⊢)⍵/⍨∨\'key'⍷⍵}c.Show
 r←'url-encoded params did not roundtrip.'
 →0
:EndIf

c.ContentType ← 'application/json'

:If c.Params ≢ ⎕JSON {⍵/⍨∨\'["key",'⍷⍵}c.Show
 r←'json params did not roundtrip.'
 →0
:EndIf

c.ContentType ← ''

ns←⎕NS '' ⋄ ns.(user password)←'user' 'password' ⋄ c.Params←ns

:If 'password=password&user=user' ≢ ⊃⊢/t.lines c.Show
 r←'namespace params did not roundtrip.'
 →0
:EndIf