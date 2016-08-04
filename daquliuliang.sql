select date,type_flag_id,type_flag_name,region_id,region_name,
       sum(case tag when 'uv' then uv else 0 end) as session_num,
       sum(case tag when 'inquiry' then uv else 0 end) as inquiry_session_num,
       sum(case tag when 'inquiry' then trade_cnt else 0 end) as trade_cnt_num,
       sum(case tag when 'inquiry' then trade_uv else 0 end) as trade_session_num,
       sum(case tag when 'success' then trade_uv else 0 end) as trade_success_cnt_num,
       sum(case tag when 'success' then uv else 0 end) as trade_success_session_num,
       sum(case tag when 'success' then trade_cnt else 0 end) as trade_success_amount_num
       
from (
select 
		a1.date,
		a1.region_id,
		a1.region_name,
        a1.type_flag_id,
		a1.type_flag_name,
		count(distinct a1.session_id) as uv,
		null as trade_uv,
        null as trade_cnt,
        'uv' as tag
from 
	(
		select session.date,
		       session.session_id,
               source_agent.trade_source_agent_key,
		       source_agent.trade_source_agent_name,
		case when session.host_landing_referer_key=-1 then '直接访问'
		  when (lcase(landing_referer_host.host_txt) like '%.baidu.com' or
			   lcase(landing_referer_host.host_txt) like 'www.google.%' or
			   lcase(landing_referer_host.host_txt) in ('www.sogou.com','3g.sogou.com','wap.sogou.com','m.sogou.com') or
			   lcase(landing_referer_host.host_txt) in ('www.so.com','www.haosou.com','www.haosou.cn','3g.so.com','wap.so.com','m.so.com','3g.haosou.com','wap.haosou.com','m.haosou.com') or
			   lcase(landing_referer_host.host_txt) like '%shenma%'  or
			   lcase(landing_referer_host.host_txt)='cn.bing.com' )
			 and lcase(landing_url.nurl_utm_campaign_name) not like 'sem%' then '自然搜索'
			when lcase(landing_url.nurl_utm_campaign_name) like 'sem%' then '广告流量'
             else '其他流量' end as type_flag_name,
		case when session.host_landing_referer_key=-1 then 1
		    when (lcase(landing_referer_host.host_txt) like '%.baidu.com' or
			  	 lcase(landing_referer_host.host_txt) like 'www.google.%' or
			  	 lcase(landing_referer_host.host_txt) in ('www.sogou.com','3g.sogou.com','wap.sogou.com','m.sogou.com') or
			  	 lcase(landing_referer_host.host_txt) in ('www.so.com','www.haosou.com','www.haosou.cn','3g.so.com','wap.so.com','m.so.com','3g.haosou.com','wap.haosou.com','m.haosou.com') or
			  	 lcase(landing_referer_host.host_txt) like '%shenma%'  or
			  	 lcase(landing_referer_host.host_txt)='cn.bing.com' )
			 and lcase(landing_url.nurl_utm_campaign_name) not like 'sem%' then 2
			 when lcase(landing_url.nurl_utm_campaign_name) like 'sem%' then 3
             else 4 end as type_flag_id,
		case when city.web_log_city_name in ('北京','天津') then '华北大区'
					 when city.web_log_city_name in ('深圳','广州','佛山') then '华南大区'
					 when city.web_log_city_name in ('上海','南京','宁波','无锡','杭州','苏州') then '华东大区'
					 else '其他' end as region_name,
        case when city.web_log_city_name in ('北京','天津') then 1
		     when city.web_log_city_name in ('深圳','广州','佛山') then 2
		     when city.web_log_city_name in ('上海','南京','宁波','无锡','杭州','苏州') then 3
		     else -1 end as region_id
       from weblog.fact_web_log_day_session session 
		join weblog.dim_nurl landing_url 
		on session.nurl_landing_key=landing_url.nurl_key
		join weblog.dim_host landing_referer_host 
		on session.host_landing_referer_key=landing_referer_host.host_key
		join weblog.dim_weblog_city city
		on session.web_log_city_key=city.web_log_city_key
		join warehouse.dim_trade_source_agent source_agent
		on session.trade_source_agent_key=source_agent.trade_source_agent_key
		where source_agent.trade_source_type_key in (0,-2) and session.is_bot_flag=0 and (session.http_status_cd between 200 and 299) and session.session_id <>-1 and landing_url.is_page_flag=1 
         and session.date between '2016-01-01' and '2016-03-31'
	) a1
  group by a1.date,a1.region_id,a1.region_name,a1.type_flag_id,a1.type_flag_name
union all
select 
		a2.date,
		a2.region_id,
		a2.region_name,
        a2.type_flag_id,
		a2.type_flag_name,
        count(distinct a2.session_id) as inquiry_uv,
        count(distinct case when trade_key<>-1 then a2.session_id end) as trade_uv,
        count((case when trade_key <> -1 then trade_key else null end)) as trade_cnt,
        'inquiry' as tag
from 
	(
		select session.date,
               session.trade_key,
			 case when session.session_id=-1 then session.trade_key else session.session_id end as session_id,
             source_agent.trade_source_agent_key,
			 source_agent.trade_source_agent_name,
		case when session.host_landing_referer_key=-1 then '直接访问'
		  when (lcase(landing_referer_host.host_txt) like '%.baidu.com' or
			   lcase(landing_referer_host.host_txt) like 'www.google.%' or
			   lcase(landing_referer_host.host_txt) in ('www.sogou.com','3g.sogou.com','wap.sogou.com','m.sogou.com') or
			   lcase(landing_referer_host.host_txt) in ('www.so.com','www.haosou.com','www.haosou.cn','3g.so.com','wap.so.com','m.so.com','3g.haosou.com','wap.haosou.com','m.haosou.com') or
			   lcase(landing_referer_host.host_txt) like '%shenma%'  or
			   lcase(landing_referer_host.host_txt)='cn.bing.com' )
			 and lcase(landing_url.nurl_utm_campaign_name) not like 'sem%' then '自然搜索'
			when lcase(landing_url.nurl_utm_campaign_name) like 'sem%' then '广告流量'
             else '其他流量' end as type_flag_name,
		case when session.host_landing_referer_key=-1 then 1
		    when (lcase(landing_referer_host.host_txt) like '%.baidu.com' or
			  	 lcase(landing_referer_host.host_txt) like 'www.google.%' or
			  	 lcase(landing_referer_host.host_txt) in ('www.sogou.com','3g.sogou.com','wap.sogou.com','m.sogou.com') or
			  	 lcase(landing_referer_host.host_txt) in ('www.so.com','www.haosou.com','www.haosou.cn','3g.so.com','wap.so.com','m.so.com','3g.haosou.com','wap.haosou.com','m.haosou.com') or
			  	 lcase(landing_referer_host.host_txt) like '%shenma%'  or
			  	 lcase(landing_referer_host.host_txt)='cn.bing.com' )
			 and lcase(landing_url.nurl_utm_campaign_name) not like 'sem%' then 2
			 when lcase(landing_url.nurl_utm_campaign_name) like 'sem%' then 3
             else 4  end as type_flag_id,
		case when city.web_log_city_name in ('北京','天津') then '华北大区'
					 when city.web_log_city_name in ('深圳','广州','佛山') then '华南大区'
					 when city.web_log_city_name in ('上海','南京','宁波','无锡','杭州','苏州') then '华东大区'
					 else '其他' end as region_name,
        case when city.web_log_city_name in ('北京','天津') then 1
		     when city.web_log_city_name in ('深圳','广州','佛山') then 2
		     when city.web_log_city_name in ('上海','南京','宁波','无锡','杭州','苏州') then 3
		     else -1 end as region_id
       from weblog.fact_web_log_inquiry_trade session 
		join weblog.dim_nurl landing_url 
		on session.nurl_landing_key=landing_url.nurl_key
		join weblog.dim_host landing_referer_host 
		on session.host_landing_referer_key=landing_referer_host.host_key
		join weblog.dim_weblog_city city
		on session.web_log_city_key=city.web_log_city_key
		join warehouse.dim_trade_source_agent source_agent
		on session.trade_source_agent_key=source_agent.trade_source_agent_key
        where source_agent.trade_source_type_key in (0,-2) 
		   and (session.is_bot_flag=0 OR (session.is_bot_flag=1 and session.trade_key<>-1))
           and (session.session_id<>-1 or (session.session_id=-1 and session.trade_key<>-1))
           and (session.http_status_cd between 200 and 299) 
		   and landing_url.is_page_flag=1 
           and session.date between '2016-01-01' and '2016-03-31'
         ) a2
	group by a2.date,a2.region_id,a2.region_name,a2.type_flag_id,a2.type_flag_name
union all
select 
		success_date,
		a2.region_id,
		a2.region_name,
        a2.type_flag_id,
		a2.type_flag_name,
	   count(distinct session_id) as uv,
       count(*) as trade_success_cnt,
	   sum(trade_pay_amount_num) as trade_success_amount_num,
       'success' as tag
from 
	(
		select trade_success.success_date,
               case when session.session_id =-1 then trade_success.trade_key else session.session_id end as session_id,
               trade_success.trade_pay_amount_num,
		       source_agent.trade_source_agent_key,
		       source_agent.trade_source_agent_name,
		case when session.host_landing_referer_key=-1 then '直接访问'
		  when (lcase(landing_referer_host.host_txt) like '%.baidu.com' or
			   lcase(landing_referer_host.host_txt) like 'www.google.%' or
			   lcase(landing_referer_host.host_txt) in ('www.sogou.com','3g.sogou.com','wap.sogou.com','m.sogou.com') or
			   lcase(landing_referer_host.host_txt) in ('www.so.com','www.haosou.com','www.haosou.cn','3g.so.com','wap.so.com','m.so.com','3g.haosou.com','wap.haosou.com','m.haosou.com') or
			   lcase(landing_referer_host.host_txt) like '%shenma%'  or
			   lcase(landing_referer_host.host_txt)='cn.bing.com' )
			 and lcase(landing_url.nurl_utm_campaign_name) not like 'sem%' then '自然搜索'
			when lcase(landing_url.nurl_utm_campaign_name) like 'sem%' then '广告流量'
             else '其他流量' end as type_flag_name,
		case when session.host_landing_referer_key=-1 then 1
		    when (lcase(landing_referer_host.host_txt) like '%.baidu.com' or
			  	 lcase(landing_referer_host.host_txt) like 'www.google.%' or
			  	 lcase(landing_referer_host.host_txt) in ('www.sogou.com','3g.sogou.com','wap.sogou.com','m.sogou.com') or
			  	 lcase(landing_referer_host.host_txt) in ('www.so.com','www.haosou.com','www.haosou.cn','3g.so.com','wap.so.com','m.so.com','3g.haosou.com','wap.haosou.com','m.haosou.com') or
			  	 lcase(landing_referer_host.host_txt) like '%shenma%'  or
			  	 lcase(landing_referer_host.host_txt)='cn.bing.com' )
			 and lcase(landing_url.nurl_utm_campaign_name) not like 'sem%' then 2
			 when lcase(landing_url.nurl_utm_campaign_name) like 'sem%' then 3
             else 4  end as type_flag_id,
		case when city.web_log_city_name in ('北京','天津') then '华北大区'
					 when city.web_log_city_name in ('深圳','广州','佛山') then '华南大区'
					 when city.web_log_city_name in ('上海','南京','宁波','无锡','杭州','苏州') then '华东大区'
					 else '其他' end as region_name,
        case when city.web_log_city_name in ('北京','天津') then 1
		     when city.web_log_city_name in ('深圳','广州','佛山') then 2
		     when city.web_log_city_name in ('上海','南京','宁波','无锡','杭州','苏州') then 3
		     else -1 end as region_id
	from  warehouse.v_fact_trade_success trade_success 
		join warehouse.dim_trade trade 
          on trade.trade_key=trade_success.trade_key
		join warehouse.dim_trade_source_agent source_agent
		  on trade.trade_source_agent_key=source_agent.trade_source_agent_key
     left  join weblog.fact_web_log_inquiry_trade session on session.trade_key=trade_success.trade_key
	 left  join weblog.dim_nurl landing_url 
		  on session.nurl_landing_key=landing_url.nurl_key
	 left  join weblog.dim_host landing_referer_host 
		  on session.host_landing_referer_key=landing_referer_host.host_key
	 left join weblog.dim_weblog_city city
		  on session.web_log_city_key=city.web_log_city_key
	where source_agent.trade_source_type_key in (0,-2)  and trade_success.success_date between '2016-01-01' and '2016-03-31'
	) a2
	group by success_date,a2.region_id,a2.region_name,a2.type_flag_id,a2.type_flag_name
)all_table
group by date,region_id,region_name,type_flag_id,type_flag_name



