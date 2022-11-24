r←test_base64 dummy
r←''

⎕RL←0 0

⍝ If the argument is integer ((⎕DR ⍵)∊83 163) Base64Encode treats it as a
⍝ vector of octets - numbers outside the inclusive range of 0 to 255 will
⍝ wrap around accordingly.
:If ~ 0∊⍴ #.HttpCommand.{(256|⍵) (∪~∩) ⎕UCS 0 Base64Decode Base64Encode ⍵}?⍨256
 r←'HttpCommand did not roundtrip base64-encoded octets. ⎕RL is [',(⍕⎕RL),']'
:Else
:EndIf

⍝ Otherwise, the argument is assumed to be UTF-8 as a convenience.
⍝ :ElseIf 0=⎕NC'cpo' ⋄ r←base64

⍝ If 0=⎕NC'cpo' ⋄ r←'UTF-8'⎕UCS base64 w

⍝ If a left argument (cpo) is supplied, no assumption is made
⍝ :Else ⋄ r←base64 ⎕UCS w