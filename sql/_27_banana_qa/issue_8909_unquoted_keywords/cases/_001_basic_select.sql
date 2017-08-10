--test with table operations

drop table if exists t;

create table t(
	"short" short unique,
	"bigint" bigint,
	"bit" bit(10),
	"double" double,
	"string" string,
	"timestamp" timestamp,
	"enum" enum('a', 'b', 'c'),
	"clob" clob,
	"set" set(varchar(100) collate iso88591_en_cs)
);

--Test: insert
insert into t(short) values(1000);
insert into t(t.bigint) values(1000);
insert into t(bit) values(B'1010');
insert into t(t.double) values(10);
insert into t(string) values('aaa');
insert into t(t.timestamp) values('2000-10-10 12:12:12');
insert into t(enum) values('b');
insert into t(t.clob) values('abc');
insert into t(set) values({'a', 'b', 'c'});
insert into t(short, enum) values(1000, 'c');
insert into t(string, clob) values('aaa', 'abc');
insert into t("short", "bigint", "bit", "double", "string", "timestamp", "enum", "clob", "set") values(1, 100, B'1010', 123.1, 'aaa', '2000-10-10 12:12:12', 'a', 'abc', {'a', 'b', 'c'});


--test: as select expressions
select t.short from t;
select bigint from t;
select t.bit, t.double from t;
select t.string, timestamp from t;
select t.enum, clob_to_char(t.clob), t. set from t;

--test: in where condition
select t.enum, t.short, t.string from t where t.bigint=100;
select t.enum, t.short, t.string from t where bigint=100;

--test: in order by clause
select t.timestamp, clob_to_char(t.clob) from t where t.enum='a' order by t.bit;
select t.timestamp, clob_to_char(t.clob) from t where t.enum='a' order by bit;

--test: in group by/having clause
select t.set, t.double from t where t.double < 999 group by t.short, t.bigint order by t.enum;
select t.set, t.double from t where t.double < 999 group by short, bigint order by t.enum;
select t.set, t.double from t where t.double < 999 group by t.short, t.bigint having clob_to_char(t.clob)='abc' order by t.enum;
select t.set, t.double from t where t.double < 999 group by t.short, t.bigint having clob_to_char(clob)='abc' order by t.enum;

drop table t;


 
	
