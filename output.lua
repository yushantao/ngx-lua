----
local status = {}
local res = {}
local domain = {}
local api = {}
local jstr
local cjson = require "cjson"
local log_dict = ngx.shared.log_dict
local result_status_dict = ngx.shared.result_status_dict
local result_domain_dict = ngx.shared.result_domain_dict
local result_dict = ngx.shared.result_dict

for k,v in pairs(result_status_dict:get_keys())do
  status[v] = result_status_dict:get(v)
end

for k,v in pairs(result_domain_dict:get_keys())do
  domain[v] = result_domain_dict:get(v)
end

for k,v in pairs(result_dict:get_keys())do
  api[v] = result_dict:get(v)
end
  res["status"]= status
  res["api"]= api
  res["domain"]= domain
  jstr = cjson.encode(res)
  ngx.say(jstr)
