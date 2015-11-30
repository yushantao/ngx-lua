----定义ngx内存空间
local result_uri_count_dict = ngx.shared.result_uri_count_dict
local result_reqtime_dict = ngx.shared.result_reqtime_dict
local result_status_dict = ngx.shared.result_status_dict
local result_domain_dict = ngx.shared.result_domain_dict
local result_api_dict = ngx.shared.result_api_dict
local result_size_dict = ngx.shared.result_size_dict
---定义ngx变量 需要cjson支持
local cjson = require "cjson"
local host = ngx.var.host
local uri = ngx.var.uri
local status = ngx.var.status
local request_time = ngx.var.upstream_response_time
local body_bytes_sent = ngx.var.body_bytes_sent
---- 请求次数统计, count
local newval, err = result_domain_dict:incr(host, 1)
if not newval and err == "not found" then
    result_domain_dict:add(host, 0)
    result_domain_dict:incr(host, 1)
end
---- 状态码统计, 2xx,4xx, 5xx, counter
local status_code = tonumber(ngx.var.status)
---status_code_var = host..uri..status_code
        local newval, err = result_status_dict:incr(status_code, 1)
        if not newval and err == "not found" then
            result_status_dict:add(status_code, 0)
            result_status_dict:incr(status_code, 1)
        end


---- uri 请求次数
if string.find(uri,"(api)") then
query_var=host..uri.."_count"
local request_uri = result_uri_count_dict:get(uri) or 0
        local newval, err = result_uri_count_dict:incr(query_var, 1)
        if not newval and err == "not found" then
            result_uri_count_dict:add(query_var, 0,10)
            result_uri_count_dict:incr(query_var, 1)
     	end

---- uri 请求总时间
        request_time_var =host..uri.."_reqtimesum"
        local request_time = tonumber(ngx.var.upstream_response_time)
        local sum = result_reqtime_dict:get(request_time_var) or 0
        sum = sum + request_time
        result_reqtime_dict:set(request_time_var,sum,10)
---- uri 平均请求时间
 request_avg_time = host..uri.."_avgtime"
 local avg =result_api_dict:get(request_avg_time) or 0
 local count = result_uri_count_dict:get(query_var)
     avg = sum/count
     result_api_dict:set(request_avg_time,avg)
end

---- 传输字节
local body_bytes_sent = tonumber(ngx.var.body_bytes_sent)
local sent = result_size_dict:get(body_bytes_sent) or 12
body_byte_var = uri.."_body-byte"
if body_bytes_sent >= 1048569 then
	result_size_dict:set(body_byte_var,body_bytes_sent)
end
