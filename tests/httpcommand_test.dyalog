:Namespace httpcommand_test

    (⎕IO ⎕ML)←1 1

    _httpbin←'httpbin.org/'
    _typicode←'https://jsonplaceholder.typicode.com/'

    _AplVersion←2⊃⎕VFI{⍵/⍨∧\⍵≠'.'}2⊃#.⎕WG'APLVersion'
    fromJSON←{16≤_AplVersion:⎕JSON ⍵ ⋄ (7159⌶)⍵}

    nl cr ← ⎕ucs 10 13 
    
    check←{⍺≡⍵:'' ⋄ (2⊃⎕SI),': Expected [',(1↓,cr,⍕⍺),'] got [',(1↓,cr,⍕⍵),']'}

    _true←⊂'true'

    port ← 8090

    ∇ r←localhost
      r←'http://localhost:',(⍕port),'/'
    ∇

    ⍝ Methods to parse instance.Show
    split ← {((~∊∘⍺)⊆⊢)⍵}
    lines ← nl cr∘split

    getCookies ← {
      params ← ': '∘split¨ 1↓ lines ⍵
      ⊃,/{⍵/⍨0@1≠\(⊂'Cookie')⍷⍵}¨ params
    }

    getContentType ← {
      ∊'Content-Type: '∘{⍵/⍨∨\(-n)↓(0⍴⍨n←⍴⍺),⍺⍷⍵}¨ lines  ⍵
    }

:EndNamespace