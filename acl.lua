local devicemode = ngx.req.get_headers()["devicemode"]
local channelid = ngx.req.get_headers()["channelid"]
local appversion = ngx.req.get_headers()["appversion"]

if channelid == "019" and string.len(devicemode) == 5 then
   ngx.exit(ngx.HTTP_FORBIDDEN)
end

if channelid == "019" and (appversion) ~= '5.3.0' then
   ngx.exit(ngx.HTTP_FORBIDDEN)
end
