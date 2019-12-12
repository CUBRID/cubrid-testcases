-- case 1
select json_valid(1); 

-- case 2
drop table if exists a;
create table a (i int ,j json);
insert into a values (1, 1); 
insert into a values (2, '1');
select * from a order by 1,2;
drop table if exists a;


drop table if exists t_json,t_numeric;
create table t_json( i int , j json);
create table t_numeric(
  id            int auto_increment,
  c_sint        smallint,
  c_int         int,
  c_bigint      bigint,
  c_numeric     numeric(38,10),
  c_float       float,
  c_real        real,
  c_doublepre   double precision
);
insert into t_numeric values ( null, 
-32768, -2147483648, -9223372036854775808, 9876543210987654321012345678.0123456789, 
987654.321, 987654321.987654321,9876.1);

insert into t_json(i,j) select 1,c_int       from t_numeric;     
insert into t_json(i,j) select 2,c_bigint    from t_numeric;     
insert into t_json(i,j) select 3,c_numeric   from t_numeric; 
insert into t_json(i,j) select 4,c_doublepre from t_numeric;     
insert into t_json(i,j) select 5,c_sint      from t_numeric;     
insert into t_json(i,j) select 6,c_float     from t_numeric;     
insert into t_json(i,j) select 7,c_real      from t_numeric;     

select * from t_json order by i;
drop table if exists t_json,t_numeric;
