--test  BIN()
select bin(0);

select bin(1);

select bin(123);

select bin(-0);

select bin(-1);

select bin(-123);

select bin(9223372036854775807);

select bin(-9223372036854775808);

create table t (i bigint);

insert into t values(0);

insert into t values(1);

insert into t values(123);

insert into t values(-0);

insert into t values(-1);

insert into t values(-123);

insert into t values(9223372036854775807);

insert into t values(-9223372036854775808);

select i, bin(i) from t order by i;

drop table t;

$short, $123
select bin(?);

$int, $123
select bin(?);

$float, $123.01f
select bin(?);

$double, $123e0
select bin(?);

$numeric, $123.01
select bin(?);

$bigint, $123
select bin(?);

$varchar, $123
select bin(?);

create table t(bi bigint);

insert into t values(0);
insert into t values(1);
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) * 2 from t; 
insert into t select max(bi) -1 + max(bi) from t;
insert into t select -bi from t where bi != 9223372036854775807;
insert into t values(-9223372036854775808);

select bin(bi) from t order by bi;

drop table t;