	
create table top_n_test (a int, b varchar(10));

insert into top_n_test values (1,   'one');
insert into top_n_test values (2,   'two');
insert into top_n_test values (3, 'three');
insert into top_n_test values (4,  'four');
insert into top_n_test values (5,  'five');
insert into top_n_test values (6,   'six');
insert into top_n_test values (7, 'seven');
insert into top_n_test values (8, 'eight');
insert into top_n_test values (9,  'nine');

select a, b from (
  select
    a,b,
    rank() over (order by b) r
  from
    top_n_test
  ) derived
where
  r<4 order by 1 desc;

drop top_n_test;

create table item_price (dt date, item varchar(30), price float);

insert into item_price values(to_date('14.05.2001','DD.MM.YYYY'),'beans',15.4);
insert into item_price values(to_date('17.05.2001','DD.MM.YYYY'),'pears', 2.8);
insert into item_price values(to_date('28.05.2001','DD.MM.YYYY'),'beans',16.2);
insert into item_price values(to_date('26.05.2001','DD.MM.YYYY'),'pears', 3.1);
insert into item_price values(to_date('03.06.2001','DD.MM.YYYY'),'beans',14.9);
insert into item_price values(to_date('01.06.2001','DD.MM.YYYY'),'pears', 2.9);

create table dummy (i int);
insert into dummy values(1);
insert into dummy select * from dummy;
insert into dummy select * from dummy;
insert into dummy select * from dummy;
insert into dummy select * from dummy;
insert into dummy select * from dummy;
insert into dummy select * from dummy;

create table date_range as 
  select 
    adddate(to_date('14.05.2001','DD.MM.YYYY'),rownum-1) dt
  from 
    dummy
  where 
    rownum <= 20;

select 
  dr_dt,
  sum(ip_price) over (partition by new_price) price   
from (
  select 
    dr.dt                               dr_dt, 
    ip.price                            ip_price, 
    sum(ip.price) over (order by dr.dt) new_price
  from
    date_range dr left join
    item_price ip on dr.dt=ip.dt
  where 
    nvl(ip.item,'beans') = 'beans'
) derived 
order by dr_dt;

drop dummy;
drop date_range;
drop item_price;

create table test_month (val int, dt date);

insert into test_month (val,dt) values (18,to_date('28.08.2000','DD.MM.YYYY'));
insert into test_month (val,dt) values (19,to_date('02.08.2000','DD.MM.YYYY'));
insert into test_month (val,dt) values (22,to_date('27.09.2000','DD.MM.YYYY'));
insert into test_month (val,dt) values (23,to_date('04.09.2000','DD.MM.YYYY'));
insert into test_month (val,dt) values (20,to_date('12.08.2000','DD.MM.YYYY'));
insert into test_month (val,dt) values (24,to_date('15.09.2000','DD.MM.YYYY'));
insert into test_month (val,dt) values (19,to_date('27.07.2000','DD.MM.YYYY'));
insert into test_month (val,dt) values (18,to_date('01.07.2000','DD.MM.YYYY'));
insert into test_month (val,dt) values (21,to_date('26.07.2000','DD.MM.YYYY'));
insert into test_month (val,dt) values (24,to_date('03.06.2000','DD.MM.YYYY'));
insert into test_month (val,dt) values (22,to_date('11.07.2000','DD.MM.YYYY'));
insert into test_month (val,dt) values (21,to_date('14.06.2000','DD.MM.YYYY'));

select val, dt, case when dt=max_dt then 'Y' else 'N' end last_dt
  from (select val, dt, max(dt) over (partition by to_char(dt,'YYYY.MM')) max_dt from test_month) as derived
  order by 2 asc;

drop test_month;
