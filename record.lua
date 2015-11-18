---- log_dict做临时记录用 result_dict记录最终需要采集的数据
local log_dict = ngx.shared.log_dict
local result_dict = ngx.shared.result_dict
local result_status_dict = ngx.shared.result_status_dict
local result_api_dict = ngx.shared.result_api_dict
local result_domain_dict = ngx.shared.result_domain_dict
local cjson = require "cjson"
local args = ngx.req.get_uri_args()
local host = ngx.var.host
local uri = ngx.var.uri
local request_time = ngx.var.request_time
local body_bytes_sent = ngx.var.body_bytes_sent
---- 请求次数统计, count
local newval, err = result_domain_dict:incr(host, 1)
if not newval and err == "not found" then
    result_domain_dict:add(host, 0)
    result_domain_dict:incr(host, 1)
end

---- request_time统计, counte
if string.find(uri,"(api)") then
request_time_var = host.."_reqtimesum"
local request_time = tonumber(ngx.var.request_time)
local sum = result_dict:get(request_time_var) or 0
sum = sum + request_time
result_dict:set(request_time_var, sum)

---- uri 请求次数
query_var=host..uri.."count"
local request_uri = result_dict:get(uri) or 0
        local newval, err = result_dict:incr(query_var, 1)
        if not newval and err == "not found" then
            result_dict:add(query_var, 0)
            result_dict:incr(query_var, 1)
     	end

---- uri 请求总时间
        request_time_var = host..uri.."_reqtimesum"
        local request_time = tonumber(ngx.var.upstream_response_time)
        local sum = result_dict:get(request_time_var) or 0
        sum = sum + request_time
        result_dict:set(request_time_var,sum)

---- uri 平均请求时间
request_avg_time = uri.."avgtime"
local avg = result_dict:get(request_avg_time) or 0
local count = result_dict:get(query_var)
    avg = sum/count
    result_dict:set(request_avg_time,avg)
end
---- 传输字节
local body_byte_sent = tonumber(ngx.var.body_bytes_sent)
body_byte_var = host..uri.."body-byte"
if body_byte_sent >= 1048576 and host == "img1.cdn.daling.com" then
	result_dict:set(body_byte_var,body_byte_sent)
end

---- 状态码统计, 2xx,4xx, 5xx, counter
local status_code = tonumber(ngx.var.status)
        local newval, err = result_status_dict:incr(status_code, 1)
        if not newval and err == "not found" then
            result_status_dict:add(status_code, 0)
            result_status_dict:incr(status_code, 1)
        end


---uri count and sum time
---local request_uri = result_dict:get(uri) or 0
---if uri =="/api/goods/special" then
---        local newval, err = result_dict:incr(uri, 1)
------uri request time	
---        request_time_var = host..uri.."_reqtimesum"
---        local request_time = tonumber(ngx.var.upstream_response_time)
---        local sum = result_dict:get(request_time_var) or 0
---        sum = sum + request_time
---        result_dict:set(request_time_var, sum)
------end uri request time
---        if not newval and err == "not found" then
---            result_dict:add(uri, 0)
---            result_dict:incr(uri, 1)
---        end
---end
