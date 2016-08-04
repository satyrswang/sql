select
   uv_all.dt,  uv_all.SOURCE1,uv_all.MEDIUM,uv_all.campaign,
  uv_all.platform,
  uv_all.channel_flag,
  uv_all.source,
  uv_all.city,uv_all.area,
case when uv is NULL then '0' else uv end as uv ,case when inquiry_uv is NULL then '0' else inquiry_uv end as inquiry_uv ,case when submit_success_uv is NULL then '0'else submit_success_uv end as submit_success_uv,
case when submit_success_cnt is NULL then '0' else submit_success_cnt end as submit_success_cnt ,case when trade_success_uv is NULL then '0' else trade_success_uv end as trade_success_uv,
case when trade_success_cnt is NULL then '0' else trade_success_cnt end as trade_success_cnt,case when trade_num is NULL then '0' else trade_num end as trade_num
from
(     
   select dt,platform,case when channel_flag='' or platform in ('Android','IOS') then 'ֱ�ӷ���' else channel_flag end as channel_flag
   ,case when source='' or platform in ('Android','IOS') then 'ֱ�ӷ���' else source end as source
   ,city,area,SOURCE1,MEDIUM,campaign
   ,count(distinct idvisitor) as uv
   from 
			(SELECT
				to_date(dateAdd(log.server_time,"hour",8)) dt,
				CASE WHEN  idaction_url_ref is null or referer_url='' or referer_type = 1
					THEN 'ֱ�ӷ���'
				  WHEN referer_url LIKE '%sem%' or referer_name like '%sem%'
					THEN '�������'
				  WHEN referer_type = 2 AND referer_url NOT LIKE '%sem%'
					THEN '��Ȼ����'
				  when referer_type = 3 then  referer_name
				  when referer_type=6 then regexp_extract(referer_url
					   ,'http(s)?//:(.[^/]*)/')
				  else '����' END AS channel_flag,
				CASE WHEN idaction_url_ref IS NULL OR referer_url = '' OR referer_type = 1
					  THEN 'ֱ�ӷ���'
					WHEN referer_type = 2
					  THEN referer_name
					WHEN referer_type = 3
					  THEN referer_name
					WHEN referer_type = 6
					  THEN regexp_extract(referer_url
					   ,'http(s)?//:(.[^/]*)/') 
					else '����' end AS source,
			    cityName(location_ip) as city,
			    case when cityName(location_ip) in ('����','���') then '��������'
					when cityName(location_ip) in ('����','����','��ɽ','��ݸ') then '���ϴ���'
					when cityName(location_ip) in ('�Ϻ�','�Ͼ�','����','����') then '��������'
					when cityName(location_ip) in ('����','�ɶ�') then '��������'
					else '����' end as area,
				case when visit.visit_entry_idaction_url=38729 then 'IOS'
				   when visit.visit_entry_idaction_url=38557 then 'Android'
				   when log.idsite=6 then 'm�汾'
				   when log.idsite=1 then '����'
				  else '����' end as platform,
				  regexp_extract(action.name,'utm_source=(\\w*)&?', 1) AS SOURCE1, 
		 regexp_extract(action.name, 'utm_medium=(\\w*)&?', 1) AS MEDIUM, 
		 regexp_extract(action.name, 'utm_campaign=(\\w*)&?', 1) AS campaign,
				log.idvisitor
				FROM ahs_tk.ahs_log_link_visit_action log
				left join ahs_tk.ahs_log_visit visit
              on log.idvisitor=visit.idvisitor
				left join ahs_tk.ahs_log_action action
			    on log.idaction_url=action.idaction
				WHERE log.idsite IN (1, 6) 
				  and to_date(dateAdd(log.server_time,"hour",8)) = '2016-07-10'
			) a
	group by dt,platform,case when channel_flag='' or platform in ('Android','IOS') then 'ֱ�ӷ���' else channel_flag end
		,case when source='' or platform in ('Android','IOS') then 'ֱ�ӷ���' else source end
		,city,area,SOURCE1,MEDIUM,campaign
) uv_all
left join 
(     
   select dt,platform,case when channel_flag='' or platform in ('Android','IOS') then 'ֱ�ӷ���' else channel_flag end as channel_flag
		,case when source='' or platform in ('Android','IOS') then 'ֱ�ӷ���' else source end as source
		,city,area, SOURCE1,MEDIUM, campaign
		,count(distinct idvisitor) as inquiry_uv
   from 
			(SELECT
				to_date(dateAdd(log.server_time,"hour",8)) dt,
				CASE WHEN  idaction_url_ref is null or referer_url='' or referer_type = 1
					THEN 'ֱ�ӷ���'
				  WHEN referer_url LIKE '%sem%' or referer_name like '%sem%'
					THEN '�������'
				  WHEN referer_type = 2 AND referer_url NOT LIKE '%sem%'
					THEN '��Ȼ����'
				  when referer_type = 3 then  referer_name
				  when referer_type=6 then regexp_extract(referer_url
					   ,'http(s)?//:(.[^/]*)/')
				  else '����' END AS channel_flag,
				CASE WHEN idaction_url_ref IS NULL OR referer_url = '' OR referer_type = 1
					  THEN 'ֱ�ӷ���'
					WHEN referer_type = 2
					  THEN referer_name
					WHEN referer_type = 3
					  THEN referer_name
					WHEN referer_type = 6
					  THEN regexp_extract(referer_url
					   ,'http(s)?//:(.[^/]*)/') 
					else '����' end AS source,
				cityName(location_ip) as city,
			    case when cityName(location_ip) in ('����','���') then '��������'
					when cityName(location_ip) in ('����','����','��ɽ','��ݸ') then '���ϴ���'
					when cityName(location_ip) in ('�Ϻ�','�Ͼ�','����','����') then '��������'
					when cityName(location_ip) in ('����','�ɶ�') then '��������'
					else '����' end as area,
				case when visit.visit_entry_idaction_url=38729 then 'IOS'
				   when visit.visit_entry_idaction_url=38557 then 'Android'
				   when log.idsite=6 then 'm�汾'
				   when log.idsite=1 then '����'
				  else '����' end as platform,
				  regexp_extract(action.name,
         'utm_source=(\\w*)&?', 1) AS SOURCE1, 
		 regexp_extract(action.name, 'utm_medium=(\\w*)&?', 1) AS MEDIUM, 
		 regexp_extract(action.name, 'utm_campaign=(\\w*)&?', 1) AS campaign,
				log.idvisitor
				FROM ahs_tk.ahs_log_link_visit_action log
				left join  ahs_tk.ahs_log_visit visit
				on log.idvisitor=visit.idvisitor
				left join ahs_tk.ahs_log_action entry_action
				on visit.visit_entry_idaction_url=entry_action.idaction
				left join ahs_tk.ahs_log_action action
				on log.idaction_url=action.idaction
				WHERE log.idsite IN (1, 6) AND (action.name LIKE '%/userinquiry/%' OR action.name LIKE '%/inquiry?key=%')
				  and to_date(dateAdd(log.server_time,"hour",8)) = '2016-07-10'
			) b
	group by dt,platform,case when channel_flag='' or platform in ('Android','IOS') then 'ֱ�ӷ���' else channel_flag end
		,case when source='' or platform in ('Android','IOS') then 'ֱ�ӷ���' else source end
		,city,area,SOURCE1,MEDIUM, campaign
)inquiry_success 
on uv_all.dt=inquiry_success.dt
  and uv_all.channel_flag=inquiry_success.channel_flag
  and uv_all.source=inquiry_success.source
  and uv_all.platform=inquiry_success.platform
  and uv_all.city=inquiry_success.city
  and uv_all.area=inquiry_success.area
  and uv_all.SOURCE1=inquiry_success.SOURCE1
   and uv_all.MEDIUM=inquiry_success.MEDIUM
   and uv_all.campaign=inquiry_success.campaign
left join 
(     
   select dt,platform,case when channel_flag='' or platform in ('Android','IOS') then 'ֱ�ӷ���' else channel_flag end as channel_flag
		,case when source='' or platform in ('Android','IOS') then 'ֱ�ӷ���' else source end as source
		,city,area,SOURCE1,MEDIUM, campaign
		,count(distinct idvisitor) as submit_success_uv
		,count(DISTINCT tradeNo) as submit_success_cnt
	    ,count(distinct(case when success_trade_ob is not null then idvisitor else null end)) as trade_success_uv
		,count(DISTINCT success_trade_ob) as trade_success_cnt
		,sum(trade_pay_amount_num) as trade_num
   from 
			(SELECT
				to_date(dateAdd(log.server_time,"hour",8)) dt,
				CASE WHEN  idaction_url_ref is null or referer_url='' or referer_type = 1
					THEN 'ֱ�ӷ���'
				  WHEN referer_url LIKE '%sem%' or referer_name like '%sem%'
					THEN '�������'
				  WHEN referer_type = 2 AND referer_url NOT LIKE '%sem%'
					THEN '��Ȼ����'
				  when referer_type = 3 then  referer_name
				  when referer_type=6 then regexp_extract(referer_url
					   ,'http(s)?//:(.[^/]*)/')
				  else '����' END AS channel_flag,
				CASE WHEN idaction_url_ref IS NULL OR referer_url = '' OR referer_type = 1
					  THEN 'ֱ�ӷ���'
					WHEN referer_type = 2
					  THEN referer_name
					WHEN referer_type = 3
					  THEN referer_name
					WHEN referer_type = 6
					  THEN regexp_extract(referer_url
					   ,'http(s)?//:(.[^/]*)/') 
					else '����' end AS source,
				cityName(location_ip) as city,
			    case when cityName(location_ip) in ('����','���') then '��������'
					when cityName(location_ip) in ('����','����','��ɽ','��ݸ') then '���ϴ���'
					when cityName(location_ip) in ('�Ϻ�','�Ͼ�','����','����') then '��������'
					when cityName(location_ip) in ('����','�ɶ�') then '��������'
					else '����' end as area,					
				case when visit.visit_entry_idaction_url=38729 then 'IOS'
				   when visit.visit_entry_idaction_url=38557 then 'Android'
				   when log.idsite=6 then 'm�汾'
				   when log.idsite=1 then '����'
				  else '����' end as platform,
				  regexp_extract(action.name,
         'utm_source=(\\w*)&?', 1) AS SOURCE1, 
		 regexp_extract(action.name, 'utm_medium=(\\w*)&?', 1) AS MEDIUM, 
		 regexp_extract(action.name, 'utm_campaign=(\\w*)&?', 1) AS campaign,
				log.idvisitor,
				regexp_extract(action.name,'tradeNo=([0-9]*)') as tradeNo,
			    trade.trades_cd as success_trade_ob,
				trade_pay_amount_num
				FROM ahs_tk.ahs_log_link_visit_action log
				left join  ahs_tk.ahs_log_visit visit
				on log.idvisitor=visit.idvisitor
				left join ahs_tk.ahs_log_action entry_action
				on visit.visit_entry_idaction_url=entry_action.idaction
				left join ahs_tk.ahs_log_action action
				on log.idaction_url=action.idaction
				left join ahs_tk.dim_trade_trades trade
                on regexp_extract(action.name,'tradeNo=([0-9]*)')=trade.trades_cd
				WHERE log.idsite IN (1, 6) AND (action.name LIKE '%/trade/Success.html?tradeNo=%' OR action.name LIKE '%/Trade/Success?tradeNo=%')
				  and to_date(dateAdd(log.server_time,"hour",8)) = '2016-07-10'
			) c
	group by dt,platform,case when channel_flag='' or platform in ('Android','IOS') then 'ֱ�ӷ���' else channel_flag end
		,case when source='' or platform in ('Android','IOS') then 'ֱ�ӷ���' else source end
		,city,area,SOURCE1,MEDIUM, campaign
)success  
on uv_all.dt=success.dt
  and uv_all.channel_flag=success.channel_flag
  and uv_all.source=success.source
  and uv_all.platform=success.platform
  and uv_all.city=success.city
  and uv_all.area=success.area
  and uv_all.SOURCE1=success.SOURCE1
   and uv_all.MEDIUM=success.MEDIUM
   and uv_all.campaign=success.campaign;
  
  