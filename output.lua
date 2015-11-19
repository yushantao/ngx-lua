----
local res = {}
local status = {}
local domain = {}
local uricount = {}
local reqtime = {}
local apit = {}
local jstr
local cjson = require "cjson"
local log_dict = ngx.shared.log_dict
local result_status_dict = ngx.shared.result_status_dict
local result_domain_dict = ngx.shared.result_domain_dict
local result_uri_count_dict = ngx.shared.result_uri_count_dict
local result_reqtime_dict = ngx.shared.result_reqtime_dict
local result_api_dict = ngx.shared.result_api_dict

for k,v in pairs(result_status_dict:get_keys())do
  status[v] = result_status_dict:get(v)
end

for k,v in pairs(result_domain_dict:get_keys())do
  domain[v] = result_domain_dict:get(v)
end
for k,v in pairs(result_uri_count_dict:get_keys())do
  uricount[v] = result_uri_count_dict:get(v)
end
for k,v in pairs(result_reqtime_dict:get_keys())do
  reqtime[v] = result_reqtime_dict:get(v)
end
for k,v in pairs(result_api_dict:get_keys())do
  apit[v] = result_api_dict:get(v)
end


  res["status"]= status
  res["domain"]= domain
  res["uricount"]= uricount
  res["reqtime"]= reqtime
  res["api"] = apit
  jstr = cjson.encode(res)
  ngx.say(jstr)
