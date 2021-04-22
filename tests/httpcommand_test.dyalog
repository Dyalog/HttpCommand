:Namespace httpcommand_test

    (⎕IO ⎕ML)←1 1

    _httpbin←'httpbin.org/'
    _typicode←'https://jsonplaceholder.typicode.com/'

    _AplVersion←2⊃⎕VFI{⍵/⍨∧\⍵≠'.'}2⊃#.⎕WG'APLVersion'
    fromJSON←{16≤_AplVersion:⎕JSON ⍵ ⋄ (7159⌶)⍵}  
    
  ⍝  check←{⍺≡⍵:'' ⋄ (2⊃⎕SI),': Expected [',(1↓,(⎕UCS 13),⍕⍺),'] got [',(1↓,(⎕UCS 13),⍕⍵),']'}

    _true←⊂'true'

:EndNamespace
