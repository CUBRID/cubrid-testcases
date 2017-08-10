--test rw column used in prepared statements

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
prepare st from 'select t.enum, clob_to_char(t.clob), t. set from t;';
execute st;
deallocate prepare st;

--test: in where condition
prepare st from 'select t.enum, t.short, t.string from t where t.bigint=?;';
execute st using 100;
deallocate prepare st;

--test: in order by clause
prepare st from 'select t.timestamp, clob_to_char(t.clob) from t where t.enum=? order by t.bit;';
execute st using 'a';
deallocate prepare st;

--test: in group by/having clause
prepare st from 'select t.set, t.double from t where t.double < ? group by t.short, t.bigint having clob_to_char(t.clob)=? order by t.enum;';
execute st using 999, 'abc';
deallocate prepare st;


drop table t;


 
	
