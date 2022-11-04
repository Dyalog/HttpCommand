:NameSpace set_cookies

⍝ https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie

c ← ⎕a,⎕d,⎕c⎕a
r ← {⍵[8↑?⍨≢⍵]}

path ← {
    ⍵.Response.Payload←⎕A
    'Set-Cookie' ⍵.SetHeader 'user=name; Path=/set_cookies/path'
}

max_age ← {
    ⍵.Response.Payload←⎕A
    'Set-Cookie' ⍵.SetHeader ('key',r c),'=',(r c),'; Max-Age=5'
}

ping ← {
    ⍵.Response.Payload←⎕A
}

:EndNameSpace