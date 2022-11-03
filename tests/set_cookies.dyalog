set_cookies ← {
    ⍝ https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie
    ⍵.Response.Payload←'pong'
    c ← ⎕a,⎕d,⎕c⎕a
    r ← {⍵[8↑?⍨≢⍵]}
    'Set-Cookie' ⍵.SetHeader ('key',r c),'=',(r c),'; Max-Age=5'
}