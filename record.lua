----定义ngx内存空间
local result_uri_count_dict = ngx.shared.result_uri_count_dict
local result_reqtime_dict = ngx.shared.result_reqtime_dict
local result_status_dict = ngx.shared.result_status_dict
local result_domain_dict = ngx.shared.result_domain_dict
local result_api_dict = ngx.shared.result_api_dict
local result_uri_sumcount_dict = ngx.shared.result_uri_sumcount_dict
---定义ngx变量 需要cjson支持
local cjson = require "cjson"
local host = ngx.var.host
local uri = ngx.var.uri
local status = ngx.var.status
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
local a = string.find(uri,"(/api/)")
local b = string.find(uri,".+%.(%w+)$")
if a~=nil and b==nil then
---if string.find(uri,"[^.]*") then
--uri 请求总数-递增
count_var=host..uri
local request_uri = result_uri_sumcount_dict:get(uri) or 0
        local newval, err = result_uri_sumcount_dict:incr(count_var, 1)
        if not newval and err == "not found" then
            result_uri_sumcount_dict:add(count_var, 0)
            result_uri_sumcount_dict:incr(count_var, 1)
        end
---uri 请求数量10s归零
query_var=host..uri
local request_uri = result_uri_count_dict:get(uri) or 0
        local newval, err = result_uri_count_dict:incr(query_var, 1)
        if not newval and err == "not found" then
            result_uri_count_dict:add(query_var, 0,30)
            result_uri_count_dict:incr(query_var, 1)
        end
---uri 请求总时间 10s归零
local request_uri = result_reqtime_dict:get(uri) or 0
        local request_time = tonumber(ngx.var.upstream_response_time) or 0
        local newval, err = result_reqtime_dict:incr(query_var, request_time)
        if not newval and err == "not found" then
            result_reqtime_dict:add(query_var, 0,30)
            result_reqtime_dict:incr(query_var, request_time)
        end
---- uri 平均请求时间
 request_avg_time = host..uri
 local avg =result_api_dict:get(query_var) or 0
 local count = result_uri_count_dict:get(query_var)
 local sum = result_reqtime_dict:get(query_var)
     avg = sum/count
     result_api_dict:set(query_var,avg,180)
end

