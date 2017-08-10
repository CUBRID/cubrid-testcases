--test with table operations

drop table if exists t;

create table t(
	"true" short unique,
	"then" bigint,
	"sum" bit(10),
	"off" double,
	"not" string,
	"rollup" timestamp,
	"under" enum('a', 'b', 'c'),
	"where" clob,
	"sql" set(varchar(100) collate iso88591_en_cs)
);

--Test: insert
insert into t(true) values(1000);
insert into t(t.then) values(1000);
insert into t(sum) values(B'1010');
insert into t(t.off) values(10);
insert into t(not) values('aaa');
insert into t(t.rollup) values('2000-10-10 12:12:12');
insert into t(under) values('b');
insert into t(t.where) values('abc');
insert into t(sql) values({'a', 'b', 'c'});
insert into t(true, under) values(1000, 'c');
insert into t(not, where) values('aaa', 'abc');
insert into t("true", "then", "sum", "off", "not", "rollup", "under", "where", "sql") values(1, 100, B'1010', 123.1, 'aaa', '2000-10-10 12:12:12', 'a', 'abc', {'a', 'b', 'c'});


--test: update
update t set t.true=999, t.sum=B'1111', t.off=99, t.not='updated', t.under=3, t.where='updated' where t.then=100;
select t.then, t.true, t.sum, t.off, t.not, t.under, clob_to_char(t.where) from t where t.then=100 order by t.then;

--test:
replace into t set t.true=999, t.sql={'updated'};
select t.true, t.sql from t where t.true=999 order by t.true;

--test: delete
delete from t where t.then=1000;
select t.true, t.then, t.sum, t.off, t.not, t.rollup, t.under, clob_to_char(t.where), t.sql from t order by t.true;

drop table t;


