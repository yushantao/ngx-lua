local result_uri_count_dict = ngx.shared.result_uri_count_dict
local result_reqtime_dict = ngx.shared.result_reqtime_dict
local result_status_dict = ngx.shared.result_status_dict
local result_domain_dict = ngx.shared.result_domain_dict
local result_api_dict = ngx.shared.result_api_dict
local result_host_dict = ngx.shared.result_host_dict


local cjson = require "cjson"
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
---- 状态码统计, 2xx,4xx, 5xx, counter
local status_code = tonumber(ngx.var.status)
        local newval, err = result_status_dict:incr(status_code, 1)
        if not newval and err == "not found" then
            result_status_dict:add(status_code, 0)
            result_status_dict:incr(status_code, 1)
        end


	
---- uri 请求次数
query_var="count"
local request_uri = result_uri_count_dict:get(uri) or 0
        local newval, err = result_uri_count_dict:incr(query_var, 1)
        if not newval and err == "not found" then
            result_uri_count_dict:add(query_var, 0)
            result_uri_count_dict:incr(query_var, 1)
     	end

---- uri 请求总时间
        request_time_var = "reqtimesum"
        local request_time = tonumber(ngx.var.upstream_response_time)
        local sum = result_reqtime_dict:get(request_time_var) or 0
        sum = sum + request_time
        result_reqtime_dict:set(request_time_var,sum)


----url:encode json
local obj = {
count = result_uri_count_dict:get(query_var),
sum = result_reqtime_dict:get(request_time_var),
}
local str = cjson.encode(obj)
result_api_dict:set(uri,str)


----uri how to variable 
local hostobj = {
    uri,
   obj = result_api_dict:get(str),

}
local pstr= cjson.encode(hostobj)
result_host_dict:set(host,uri,pstr)

