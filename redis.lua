local redis = require "resty.redis"
local cache = redis.new()
local ok, err = cache.connect(cache, '127.0.0.1', '6379')
cache:set_timeout(60000)
if not ok then
        ngx.say("failed to connect:", err)
        return
end
res, err = cache:set("pig", "an aniaml")
if not ok then
        ngx.say("failed to set dog: ", err)
        return
end
ngx.say("set result: ", res)
local res, err = cache:get("pig")
if not res then
        ngx.say("failed to get dog: ", err)
        return
end
if res == ngx.null then
        ngx.say("dog not found.")
        return
end
ngx.say("pig: ", res)
local ok, err = cache:close()
if not ok then
        ngx.say("failed to close:", err)
        return
end
