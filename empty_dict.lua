----
---第一种方式清空内存 第二种方式清空value值
ngx.shared.result_api_dict:flush_all()
ngx.shared.result_uri_count_dict:flush_all()
ngx.shared.result_uri_sumcount_dict:flush_all()
ngx.shared.result_reqtime_dict:flush_all()
local result_dict = ngx.shared.result_dict
---- 将字典中每个key的值重置为0
for k,v in pairs(result_dict:get_keys())do
  result_dict:set(v, 0)
  log_dict:set(v, 0)
end

