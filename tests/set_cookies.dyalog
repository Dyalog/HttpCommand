set_cookies←{
    chars ← ⎕a,⎕d,⎕c⎕a
    'Set-Cookie' ⍵.SetHeader 'id=',chars[8↑?⍨≢chars]
 }