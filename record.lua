---- log_dict做临时记录用 result_dict记录最终需要采集的数据
local log_dict = ngx.shared.log_dict
local result_dict = ngx.shared.result_dict

local args = ngx.req.get_uri_args()
local host = ngx.var.host
local uri = ngx.var.uri
local request_time = ngx.var.request_time

---- 请求次数统计, counter
query_nb_var = host.."_count"

local newval, err = result_dict:incr(query_nb_var, 1)
if not newval and err == "not found" then
    result_dict:add(query_nb_var, 0)
    result_dict:incr(query_nb_var, 1)
end


---- request_time统计, counter
request_time_var = host.."_reqtimesum"

local request_time = tonumber(ngx.var.request_time)
local sum = result_dict:get(request_time_var) or 0
sum = sum + request_time
result_dict:set(request_time_var, sum)

---- 单个uri count 统计
local request_uri = result_dict:get(uri) or 0
        local newval, err = result_dict:incr(uri, 1)
        if not newval and err == "not found" then
            result_dict:add(uri, 0)
            result_dict:incr(uri, 1)
        end
---end
---单个uri time 统计
---local help_api = host.."_/api/help/version"
---local request_time_api = tonumber(ngx.var.upstream_response_time)
---local api_time = result_dict:get(help_api) or 0
---  api_time = api_time + request_time_api
---  result_dict:set(help_api,api_time)

