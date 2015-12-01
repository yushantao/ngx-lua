---全局变量定义
local redis = require "resty.redis"
local cjson = require "cjson"
---取关键字内容
local args = ngx.req.get_headers()["Host"]
---取redis内容
local red = redis.new()
red:set_timeout(60000)
local ok, err = red:connect("10.36.4.86", 6379)
if not ok then
    ngx.say("failed to connect: ", err)
    return
end
local ok, err = red:get(args)
if ok == ngx.null then
        return
else
 ngx.req.set_header("X-Fooooooooooooo", ok)
end
