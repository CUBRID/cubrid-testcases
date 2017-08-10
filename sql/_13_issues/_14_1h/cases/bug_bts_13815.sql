drop table if exists t;
create table t(b bigint, h clob);
insert into t( b,h) values(100,'abc');
update t set  t.h='345' where t.b=100;
select b,clob_to_char(h) from t;
drop t;
