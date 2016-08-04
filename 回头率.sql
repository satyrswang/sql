
/*select user_id,trade_success_date
FROM  dim_trade
WHERE user_id=257 and trade_success_date is not NULL*/

create VIEW t_num as (select user_id,count(*) as num
 from dim_trade
 WHERE trade_success_date is not NULL
 GROUP BY user_id
 having num>1);

/*select avg(t_num.num) as avg
FROM  t_num
*/


/* SELECT user_id,trade_success_date
 FROM （ CREATE  VIEW  v_ut as(select user_id,trade_success_date
FROM dim_trade
WHERE user_id inSELECT  user_id
FROM  t_ub) and trade_success_date is not NULL）） a
 WHERE  (SELECT  count(*) FROM  v_ut b WHERE b.user_id=a.user_id and b.trade_success_date >a.trade_success_date)<2*/
CREATE VIEW t_tr(user_id,trade_success_date) as(
 select user_id,trade_success_date
FROM dim_trade
WHERE user_id in(SELECT  user_id
FROM  t_num) and dim_trade.trade_success_date is not NULL
 )
/*
select row_number() over(order by user_id asc) as rowid ,*  from t_tr*/

/*CREATE PROCEDURE p_trans()
 BEGIN
  DECLARE first_d DATE;
  DECLARE  second_d DATE;
  DECLARE  third_d DATE;
  DECLARE  fourth_d DATE;
  DECLARE  i  INT DEFAULT 0;
  set @s='select user_id';
  WHILE  i< t_ub.num DO
   set  first_d = ();
  END WHILE;
 END;*/



/* create view v_backinterval as(
   SELECT user_id,datediff()
 from v_ut
GROUP BY  user_id)*/
/*
create temporary table w_r AS
  (
    DECLARE @var1 date,@var2 date,@usr int(11),@usr2 int(11),@intervals int(10),@num,@col;
set @num := 0;
set  @col1 := 0;
select user_id,trade_success_date
   @num := if(@col1 = user_id, @num + 1, 1) as row_number,
   @col1 := user_id
from t_tr
order by user_id,trade_success_date;

)
*/
/*select user_id, row_number,trade_success_date
  from w_r a LEFT OUTER JOIN w_r  b on b.row_number =a.row_number+1 and a.user_id = b.user_id*/


/*
DECLARE up CURSOR FOR t_tr
set @usr :=1;
set @usr2:=1;
set @var1:= '2011-04-22';
set @var2:=0
open upd
fetch next from up into @usr2,@var2
while (@@fetch_status)<>-1
begin
 case when @usr2 =@usr1 then @intervals = datediff(@var1,@var2)
 else

 select  @var1=@var2,@usr1=@usr2
FETCH next from upd into @usr2,@var2
end
CLOSE upd
deallocate upd*/




/*select A.user_id,
 DATEDIFF(A.trade_success_date,B.trade_success_date) as inv
 from
 ( SELECT user_id
       ,trade_success_date
       , ROW_NUMBER() over(partition by user_id order by trade_success_date asc) as num
 FROM t1 ) A
 left outer join
 (SELECT user_id
       ,trade_success_date
       , ROW_NUMBER() over(partition by user_id order by trade_success_date asc) as num
 FROM t1 ) B
 on A.user_id=B.user_id
 where A.num=1
 and B.num=2*/
/*
create view v_withr as(
)
*/


 /*SELECT @rn:=@rn+1 AS rank,
     product_sku_key,
     operation_timestamp ,
     recycle_history_price_num
    from
    (SELECT
      product_sku_key,
      concat(sku_recycle_price_history_operation_date, ' ',
             sku_recycle_price_history_operation_time) AS operation_timestamp,
      recycle_history_price_num
    FROM warehouse.fact_quote_sku_recycle_price_history
    where quoter_type_key=1 and date(sku_recycle_price_history_operation_date)='" + context.dateStr + "'
    group by product_sku_key,operation_timestamp,recycle_history_price_num
    order by product_sku_key,operation_timestamp
    ) test,(SELECT @rn:=0) t2*/


create TEMPORARY TABLE dif as (
 SELECT tb1.user_id as user_id, tb1.trade_success_date as trade_success_date, tb1.rank as rank,
  tb2.user_id as 2u,tb2.trade_success_date as 2t ,tb2.rank as 2r
from
(
SELECT
user_id,
trade_success_date,
rank
FROM
(
SELECT
heyf_tmp.user_id,
heyf_tmp.trade_success_date,

IF (

@pdept = heyf_tmp.user_id ,@rank :=@rank + 1 ,@rank := 1
) AS rank,
@pdept := heyf_tmp.user_id
FROM
(
SELECT
user_id,
trade_success_date
FROM
warehouse.dim_trade
where trade_is_success_flag=1
ORDER BY
user_id,
trade_success_date
) heyf_tmp,
(
SELECT
@pdept := NULL ,@rank := 0
) a
) result)tb1

inner join

(
SELECT
user_id,
trade_success_date,
rank
FROM
(
SELECT
heyf_tmp.user_id,
heyf_tmp.trade_success_date,

IF (

@pdept = heyf_tmp.user_id ,@rank :=@rank + 1 ,@rank := 1
) AS rank,
@pdept := heyf_tmp.user_id
FROM
(
SELECT
user_id,
trade_success_date
FROM
warehouse.dim_trade
where trade_is_success_flag=1
ORDER BY
user_id,
trade_success_date
) heyf_tmp,
(
SELECT
@pdept := NULL ,@rank := 0
) a
) result)tb2

on tb2.rank=tb1.rank+1 and tb1.user_id=tb2.user_id

)
select user_id
FROM (select user_id,count(*) as m
FROM  dif
WHERE dif.rank > 3 and datediff(2t,trade_success_date)<7
group by user_id) a
WHERE  a.m>=8





select user_id ,trade_success_date
FROM  dif JOIN dim_date ON dif.trade_success_date=date
WHERE user_id=8

drop TEMPORARY table dif

select user_id,b.n FROM (
SELECT  user_id, count(*) AS n
FROM  dim_trade join dim_date on trade_success_date=date
GROUP BY  user_id,week_year_cd ) b
WHERE  b.n>=3

select count(*)/2141777 FROM
 (select DISTINCT user_id  FROM (
SELECT  user_id, count(*) AS n
FROM  dim_trade join dim_date on trade_success_date=date
GROUP BY  user_id,week_year_cd ) b
WHERE  b.n>=3 ) c


select count(*)
FROM  dim_user

declare @i int
set @i=3
while @i<1000
begin
select count(*)/2141777 FROM
(select DISTINCT user_id  FROM (
SELECT  user_id, count(*) AS n
FROM  dim_trade join dim_date on trade_success_date=date
GROUP BY  user_id,week_year_cd ) b
WHERE  b.n>=@i ) c
set @i=@i+1;
end

delimiter $

create procedure wk()　　
begin
declare i int
set i = 1
while i < 11 do 　
insert into user_profile (uid) values (i);
set i = i +1
end while
end $

