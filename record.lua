---- log_dict做临时记录用 result_dict记录最终需要采集的数据
local log_dict = ngx.shared.log_dict
local result_dict = ngx.shared.result_dict
local cjson = require "cjson"
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
---local Que = {first=0,last=0}
---function Que:push(value)
---    local last = self.last
---    self[last] = value
---    self.last = last+1
---end
---function Que:pop()
---    if self.first == self.last then
------        ngx.say("队列空")
---        return nil
---    end
---    local first = self.first
---    self.first = first+1
---    return self[first]
---end
---function Que:showValue()
---    for i=self.first,self.last-1 do
------        ngx.say("value:"..self[i])
---    end
---end
---Que:push(2)
---Que:push(3)





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
---- request_time统计, counter
---request_time_var = host.."_reqtimesum"
---local request_time = tonumber(ngx.var.request_time)
---local sum = result_dict:get(request_time_var) or 0
---sum = sum + request_time
---result_dict:set(request_time_var, sum)
