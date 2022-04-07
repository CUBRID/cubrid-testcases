autocommit off;
create vclass co_1_1_c
method co_1_1_met(int,float,int,double,date,time,monetary) string
function impl_sd_6_1_met
file 'impl_test_methods.o';
create vclass priceunion (pr monetary)
as
select price from joe.inventory_v 
union
select price from joe.inventory_v;
select pr from priceunion;
create vclass priceintersect (pr monetary)
as
select price from joe.inventory_v 
intersection
select price from joe.inventory_v;
select pr from priceintersect;
create vclass pricedif (pr monetary)
as
select price from joe.inventory_v 
difference
select price from joe.inventory_v;
select pr from pricedif;
create vclass foo (a integer)
as
select na from joe.product_c;
create vclass foo2 (a smallint)
as
select 2 from joe.product_c;
create vclass type_table_rr
(
  num integer,
  t_var_char string,
  t_integer1 smallint,
  t_integer2 smallint,
  t_integer4 integer,
  t_float4 float,
  t_float8 double,
  t_date date,
  t_money monetary
);
create vclass type_class_o
(
  num integer,
  t_smallint smallint,
  t_int int,
  t_float float,
  t_double double,
  t_time time,
  t_timestamp timestamp,
  t_date date,
  t_monetary monetary
);
create vclass type__class
(
  num integer,
  t_str string,
  t_int1 smallint,
  t_int2 smallint,
  t_int4 integer,
  t_float float,
  t_double double,
  t_time time,
  t_timestamp timestamp,
  t_date date,
  t_monetary monetary
)
as
  select num, t_var_char, t_integer1, t_integer2, t_integer4,
         t_float4, t_float8, NA, NA, t_date, t_money
    from type_table_rr,
  select num, NA, NA, t_smallint, t_int, t_float, t_double,
         t_time, t_timestamp, t_date, t_monetary
    from type_class_o;
rollback;
