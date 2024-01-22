socket = require "socket"
moonscript = require "moonscript.base"
-- import dump from "xi.moondump"
-- require "moon.all"
for k, v in pairs(require "xi")
  _G[k] = v

clock = DefaultClock
clock\start!
host = "*"
port = 8080
s = assert(socket.bind(host, port))
i, p = s\getsockname!
assert(i, p)
c = assert(s\accept!)
c\settimeout(0.001)
print("Connected to Xi")

getstring = (a) ->
  if a
    func, err = moonscript.loadstring(a)
    if func
      ok, res = pcall(func)
      if ok
        print res
      else
        print("Execution error:", ok)
    else
      print("Compilation error:", err)

listen = (client) ->
  l, e = client\receive()
  while not e do
    getstring(l)
    l, e = client\receive()

while coroutine.resume(clock.notifyCoroutine)
  listen(c)
