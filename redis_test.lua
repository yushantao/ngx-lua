---全局变量定义
local redis = require "resty.redis"
local cjson = require "cjson"
---取关键字内容
local args = ngx.req.get_headers()["Host"]
---取redis内容
local red = redis.new()
red:set_timeout(60000)
local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
    ngx.say("failed to connect: ", err)
    return
end
local ok, err = red:get(args)
if not ok then
        ngx.say("failed to get key: ", err)
        return
end
if ok == ngx.null then
        ngx.say("key not found.")
        return
end
----	ngx.header["X-My-Header"] = ok;
--- set header to proxy backend
 ngx.req.set_header("X-Fooooooooooooo", ok)
