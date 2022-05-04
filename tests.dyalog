 sizeTest port;params;c;try;orig
⍝
 (params←⎕NS'').(size body)←1000
 c←HttpCommand.New'get'('http;//localhost:',(⍕port),'/size')params
 ⎕←'Using: ',2⊃⎕WG'APLVersion'
 try←c∘{
     ⍺.(BufferSize DOSLimit)←⍵
     ⎕←⍺{⍵,⍪⍺⍎⍕⍵}'BufferSize' 'DOSLimit'
     ⍺.Run
 }
 orig←c.(BufferSize DOSLimit)

 try orig
 try 500,orig[2]
 try orig[1],500
 try 500 500
