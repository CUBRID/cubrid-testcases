--+ holdcas on;

--- VARCHAR
drop table if exists var_t;

create table var_t(s1 varchar,s2 varchar(200));

insert into var_t values('a','b');

insert into var_t values(repeat('a',200),repeat('b',300));

insert into var_t values(repeat('a',300),repeat('b',300));

create index idx_1 on var_t(s1,s2);

select * from var_t order by 1;

select length(s1),disk_size(s1),length(s2),disk_size(s2) from var_t order by 1;

drop table var_t;


--- VARNCHAR
drop table if exists t1;

create table t1(s1 nchar varying,s2 nchar(1000));

insert into t1 values(N'a',N'b');

insert into t1 values(repeat(N'a',1000),repeat(N'a',1000));

create index idx_t1 on t1(s1,s2);

select * from t1 order by 1;

select length(s1),disk_size(s1),length(s2),disk_size(s2) from t1 order by 1;

drop table t1;


-- bit varying/STRING/CHAR
drop table if exists var_t;

create table var_t(i1 int,s1 bit varying,s2 string,S3 char(300));

insert into var_t values(1,'a','d','c');

insert into var_t values(2,repeat('a',254),repeat('b',254),repeat('c',254));

insert into var_t values(3,repeat('a',255),repeat('b',255),repeat('c',255));

insert into var_t values(4,repeat('a',500),repeat('b',500),repeat('c',500));

create index idx_var_t on var_t(i1,s1,s2);

select i1,s1,s2,s3,length(s1),length(s2),length(s3),disk_size(s1),disk_size(s2),disk_size(s3) from var_t where i1>2 and s2>'a' order by i1;

drop table var_t;


--- clob/blob
drop table if exists t;

create table t(b blob,c clob,s1 string);

insert into t(b,c) values(char_to_blob(repeat('abc',300)),char_to_clob(repeat('def',300)));

insert into t(s1) select clob_to_char(c) from t;

create index idx_t on t(s1);

select clob_to_char(c),s1 from t order by 1;

select disk_size(clob_to_char(c)) from t order by 1;

select disk_size(s1) from t order by 1;

drop table t;


-- ENUM
drop table if exists enum_t;

create table enum_t(
col1 enum('abc',
'testanmdmklmlllllllllllllllnnnnnnnnnnnnnnnnnnnnnnnnnnnnoooooooooooopppppppppppppppppkkkkkkkkkkkkkkkkkkllllllllllllllllmmmmmmmmmmmmmmmmmmcccccccccccccccvvvvvvvvvvvvvv4444444444444888888888888888883333333333000000000000000pppppppppppppppbbbbbbbbbbbbbbbbgggggggggggggggggggggmmmmmmmmmm',
'The ENUM type is a data type consisting of an ordered set of distinct constant char literals called enum values. If you run the above query, backslash is regarded as an escape character. Therefore, above two strings are the same If you run the above query, backslash is regarded as an escape character. Therefore, above two strings are the same The syntax for creating an enum column is CUBRID supports two kinds of methods to escape special characters. One is using quotes and the other is using backslash If you run the above query, backslash is regarded as an escape character. Therefore, above two strings are the same If you run the above query, backslash is regarded as an escape character. Therefore, above two strings are the same'));

insert into enum_t values(1);

insert into enum_t values(2);

insert into enum_t values(3);

create index idx_enum_t on enum_t(col1);

select disk_size(col1),length(col1),col1 from enum_t order by 1,2;

select * from enum_t where col1>'b';

select * from enum_t where col1>2;

drop table enum_t;

-- set
drop table if exists set_t;

create table set_t(s1 SET (CHAR(300)),s2 SET (varchar));

insert into set_t values({'a'},{'b'});

insert into set_t values({repeat('a',100)},{repeat('b',100)});

insert into set_t values({repeat('a',500)},{repeat('b',500)});

select disk_size(s1),disk_size(s2),s1,s2 from set_t order by 1,2;

SELECT disk_size(CAST (s1 AS MULTISET)), disk_size(CAST (s1 AS LIST)),disk_size(CAST (s2 AS MULTISET)), disk_size(CAST (s2 AS LIST)) FROM set_t order by 1,2,3;

drop table set_t;


-- multiset
drop table if exists multset_t;

create table multset_t(s1 MULTISET (CHAR(300)),s2 MULTISET (varchar));

insert into multset_t values({'a'},{'b'});

insert into multset_t values({repeat('a',100)},{repeat('b',100)});

insert into multset_t values({repeat('a',500)},{repeat('b',500)});

select disk_size(s1),disk_size(s2),s1,s2 from multset_t order by 1,2;

drop table multset_t;


-- list
drop table if exists list_t;

create table list_t(s1 LIST (CHAR(300)),s2 LIST (varchar));

insert into list_t values({'a'},{'b'});

insert into list_t values({repeat('a',100)},{repeat('b',100)});

insert into list_t values({repeat('a',500)},{repeat('b',500)});

select disk_size(s1),disk_size(s2),s1,s2 from list_t order by 1,2;

drop table list_t;

--+ holdcas off;