local cjson = require "cjson"
local access = ngx.shared.access
local host = ngx.var.host
local uri = ngx.var.uri
local status = ngx.var.status
local body_bytes_sent = ngx.var.body_bytes_sent
local request_time = ngx.var.request_time
local timestamp = os.date("%s")
local expire_time = 60
 
local status_key = table.concat({host,"-",status,"-",timestamp})
local flow_key = table.concat({host,"-flow-",timestamp})
local req_time_key = table.concat({host,"-reqt-",timestamp})
local total_req_key = table.concat({host,"-total_req-",timestamp})
local api_time_key = table.concat({host,uri,"-time-",timestamp})
local total_api_key = table.concat({host,uri,"-count-",timestamp})
 
-- count total req
local total_req_sum = access:get(total_req_key) or 0
total_req_sum = total_req_sum + 1
access:set(total_req_key, total_req_sum, expire_time)
 
-- count status
local status_sum = access:get(status_key) or 0
status_sum = status_sum + 1
access:set(status_key, status_sum, expire_time)
 
-- count flow
local flow_sum = access:get(flow_key) or 0
flow_sum = flow_sum + body_bytes_sent
access:set(flow_key, flow_sum, expire_time)
 
-- count request time
local req_sum = access:get(req_time_key) or 0
req_sum = req_sum + request_time
access:set(req_time_key, req_sum, expire_time)

-- count total api
local total_api_sum = access:get(total_api_key) or 0
total_api_sum = total_api_sum + 1
access:set(total_api_key, total_api_sum, expire_time)

-- count uri request time
local api_time = access:get(api_time_key) or 0
api_time = api_time + request_time
access:set(api_time_key, api_time, expire_time)

