create table t(a set string);
insert into t values({cast('가' as string charset iso88591),cast('伽'as string charset iso88591)});
select * from t;
drop table t;

