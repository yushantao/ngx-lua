----
local tab = {}
local res = {}
local jstr
local cjson = require "cjson"
local log_dict = ngx.shared.log_dict
local result_status_dict = ngx.shared.result_status_dict
local result_dict = ngx.shared.result_dict

for k,v in pairs(result_status_dict:get_keys())do
  tab[v] = result_status_dict:get(v)
end
  res["status"]= tab
  jstr = cjson.encode(res)
  ngx.say(jstr)
