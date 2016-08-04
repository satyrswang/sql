/*select tb2.rank,
count(1),
avg(datediff(tb2.liangpin_trade_create_date,tb1.liangpin_trade_create_date))
#tb1.rank,tb1.liangpin_user_key,datediff(tb2.liangpin_trade_create_date,tb1.liangpin_trade_create_date)

#tb1.rank,avg(datediff(tb2.liangpin_trade_create_date,tb1.liangpin_trade_create_date))
#tb1.rank,tb1.liangpin_user_key,*/
SELECT *
from
(
SELECT
liangpin_user_key,
liangpin_trade_create_date,
rank
FROM
(
SELECT
heyf_tmp.liangpin_user_key,
heyf_tmp.liangpin_trade_create_date,

IF (

@pdept = heyf_tmp.liangpin_user_key ,@rank :=@rank + 1 ,@rank := 1
) AS rank,
@pdept := heyf_tmp.liangpin_user_key
FROM
(
SELECT
liangpin_user_key,
liangpin_trade_create_date
FROM
warehouse.dim_liangpin_trade
where liangpin_trade_status_key=5
ORDER BY
liangpin_user_key,
liangpin_trade_create_date
) heyf_tmp,
(
SELECT
@pdept := NULL ,@rank := 0
) a
) result)tb1

inner join

(
SELECT
liangpin_user_key,
liangpin_trade_create_date,
rank
FROM
(
SELECT
heyf_tmp.liangpin_user_key,
heyf_tmp.liangpin_trade_create_date,

IF (

@pdept = heyf_tmp.liangpin_user_key ,@rank :=@rank + 1 ,@rank := 1
) AS rank,
@pdept := heyf_tmp.liangpin_user_key
FROM
(
SELECT
liangpin_user_key,
liangpin_trade_create_date
FROM
warehouse.dim_liangpin_trade
where liangpin_trade_status_key=5
ORDER BY
liangpin_user_key,
liangpin_trade_create_date
) heyf_tmp,
(
SELECT
@pdept := NULL ,@rank := 0
) a
) result)tb2

on tb2.rank=tb1.rank+1 and tb1.liangpin_user_key=tb2.liangpin_user_key

limit 10000