select t.years as '年度',t.months as '月份',
count(1) as '总购买用户数',
sum(case when t.buy_times=1 then 1 else 0 end) as '购买一次',
sum(case when t.buy_times=2 then 1 else 0 end) as '购买两次',
sum(case when t.buy_times=3 then 1 else 0 end) as '购买三次',
sum(case when t.buy_times>3 then 1 else 0 end) as '购买大于三次',
concat( left (sum(case when t.buy_times>1 then 1 else 0 end)/count(1) *100,5),'%') as '用户复购率',
sum(case when t.usertype='新用户' then 1 else 0 end) as '新用户数',
sum(case when t.usertype='老用户' then 1 else 0 end) as '老用户数',
concat(left(sum(case when t.usertype='老用户' then 1 else 0 end)/count(1)*100,5),'%') as '回购率',
sum(t.buy_times) as '总订单数',
sum(case when t.buy_times=1 then t.buy_times else 0 end) as '一次订单',
sum(case when t.buy_times=2 then t.buy_times else 0 end) as '两次订单',
sum(case when t.buy_times=3 then t.buy_times else 0 end) as '三次订单',
sum(case when t.buy_times>3 then t.buy_times else 0 end) as '大于三次以上订单',
concat(left (sum(case when t.buy_times>1 then t.buy_times else 0 end)/sum(t.buy_times) *100,5),'%') as '订单复购率'
from 
(select year(trade.liangpin_trade_create_date) as years,
month(trade.liangpin_trade_create_date) as months,
min(trade.liangpin_trade_create_date),
trade.liangpin_user_key,
count(1) as 'buy_times',
user.liangpin_user_create_date,
if(DATEDIFF(min(trade.liangpin_trade_create_date),user.liangpin_user_create_date)<=30,'新用户','老用户') as usertype
from warehouse.dim_liangpin_trade trade
join
warehouse.dim_liangpin_user user
on trade.liangpin_user_key=user.liangpin_user_key
where trade.liangpin_trade_status_key=5
group by year(trade.liangpin_trade_create_date),month(trade.liangpin_trade_create_date),trade.liangpin_user_key) t
group by t.years,t.months
limit 30000



SELECT  user_id, trade_success_date,trade_finish_date,trade_is_success_flag,trade_is_active_flag
FROM  dim_trade
WHERE  trade_is_success_flag =1 and trade_success_date is NULL