create table t1 (code char(900));
create index idx on t1(code desc);
insert into t1 values('00035');
insert into t1 values('00036');
insert into t1 values('00037');
insert into t1 values('00038');
insert into t1 values('00039');
select if(count(*)=0, 'OK', 'NOK') from t1 where code > '00010' and code < '00035';
drop table t1;
