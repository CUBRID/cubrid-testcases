--+ holdcas on;
create table t1 (s1 string collate utf8_bin);
insert into t1 values ('abc');
set names utf8;
create view v1 as select char_length(concat(s1,'ABCİ')) as vs1 from t1;
show create view v1;

select * from v1;
set names iso88591;
select * from v1;

drop view v1;
drop table t1;

-- create in ISO names
set names iso88591;
create table t1 (s1 string collate iso88591_bin);
insert into t1 values ('abc');
create view v1 as select char_length(concat(s1,'ABCİ')) as vs1 from t1;
show create view v1;

set names utf8;
select * from v1;
set names iso88591;
select * from v1;


drop view v1;

drop table t1;

set names iso88591;

commit;
--+ holdcas off;
