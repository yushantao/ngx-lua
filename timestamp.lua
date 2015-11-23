local cjson = require "cjson"
require("os")
local res = {}
local total = {}
local pstr
local jstr

host = os.time()
res["ts"]= host
jstr = cjson.encode(res)

total["data"]= res
total["status"]="200"
pstr = cjson.encode(total)
ngx.say(pstr)
