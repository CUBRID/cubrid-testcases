autocommit off;
create table t(t time);
insert into t values($1234567890.12);
insert into t values(1);
insert into t values(987654321);
insert into t values(3.14f);
insert into t values(2.71828123456789e+8);
select * from t order by case t
  when time'23:31:30' then 1
  when time'00:00:01' then 2
  when time'04:25:21' then 3
  when time'00:00:03' then 4
  else 5
end;
rollback work;
create table m(f float, d double);
insert into m values($1234567.89, $98765432101234567.89);
select * from m;
rollback work;
rollback;
