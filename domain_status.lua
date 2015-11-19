local access = ngx.shared.access
local args = ngx.req.get_uri_args()
local count = args["count"]
local host = args["host"]
local uri = args["uri"]
local status = args["status"]
local one_minute_ago = tonumber(os.date("%s")) - 60
local now = tonumber(os.date("%s"))
 
local status_total = 0
local flow_total = 0
local reqt_total = 0
local req_total = 0
local api_time_total = 0
local api_total = 0
 
if not host then
        ngx.print("host arg not found.")
        ngx.exit(ngx.HTTP_OK)
end
 
if count == "status" and not status then
        ngx.print("status arg not found.")
        ngx.exit(ngx.HTTP_OK)
end
 
if not (count == "status" or count == "flow" or count == "reqt" or count == "apit") then
        ngx.print("count arg invalid.")
        ngx.exit(ngx.HTTP_OK)
end

 
#for second_num=one_minute_ago,now do
for second_num=now do
        local flow_key = table.concat({host,"-flow-",second_num})
        local req_time_key = table.concat({host,"-reqt-",second_num})
        local total_req_key = table.concat({host,"-total_req-",second_num})
        local api_time_key = table.concat({host,uri,"-time-",second_num})
        local total_api_key = table.concat({host,uri,"-count-",second_num})
 
        if count == "status" then
                local status_key = table.concat({host,"-",status,"-",second_num})
                local status_sum = access:get(status_key) or 0
                status_total = status_total + status_sum
        elseif count == "flow" then
                local flow_sum = access:get(flow_key) or 0
                flow_total = flow_total + flow_sum
        elseif count == "reqt" then
                local req_sum = access:get(total_req_key) or 0
                local req_time_sum = access:get(req_time_key) or 0
                reqt_total = reqt_total + req_time_sum
                req_total = req_total + req_sum
        elseif count == "apit" then
                local api_sum = access:get(total_api_key) or 0
                local api_time_sum = access:get(api_time_key) or 0
                api_time_total = api_time_total + api_time_sum
                api_total = api_total + api_sum
        end
end
 
if count == "status" then
        ngx.print(status_total)
elseif count == "flow" then
        ngx.print(flow_total)
elseif count == "reqt" then
        if req_total == 0 then
                reqt_avg = 0
        else
                reqt_avg = reqt_total/req_total
        end
        ngx.print(reqt_avg)
elseif count == "apit" then
        if api_total == 0 then
                api_time_avg = 0
        else
                api_time_avg = api_time_total / api_total
        end
        ngx.print(api_time_avg)
end
