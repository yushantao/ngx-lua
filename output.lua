----
local tab = {}
local jstr
local cjson = require "cjson"
local log_dict = ngx.shared.log_dict
local result_dict = ngx.shared.result_dict
for k,v in pairs(result_dict:get_keys())do
---  ngx.say("domain_name: ", v)
---  ngx.say(result_dict:get(v))
---  pstr=cjson.encode(v)
---  jstr=cjson.encode(result_dict:get(v))
  tab[v] = result_dict:get(v)

end
  jstr = cjson.encode(tab)
  ngx.say(jstr)
