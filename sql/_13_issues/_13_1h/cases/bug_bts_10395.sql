drop table if exists t1;
create table t1 (a bigint);
prepare s from 'select a from t1 where a between ? and ?';
execute s using 1, 2;


set names utf8;

drop table if exists t1;
create table t1 (a bigint);
prepare s from 'select a from t1 where a between ? and ?';
execute s using 1, 2;


drop table if exists t1;
create table t1 (a bigint);
prepare s from 'select a from t1 where a between ? and ? and rownum < ?';
execute s using 1, 2,3;



drop table if exists t1;
create table t1 (a bigint,b int,c varchar(2000),d char(200),e numeric(10,0),f CHARACTER VARYING(100));
insert into t1 select rownum,rownum,rownum,rownum,rownum,rownum from db_class limit 10;
prepare s from 'select a from t1 where a between ? and ? and rownum < ?';
execute s using 1, 2,3;


drop table if exists t1;
create table t1 (a bigint,b int,c varchar(2000),d char(200),e numeric(10,0),f CHARACTER VARYING(100));
insert into t1 select rownum,rownum,rownum,rownum,rownum,rownum from db_class limit 10;
prepare s from 'select a from t1 where a between ? and ? and rownum < ? and b between ? and ? and c between ? and ?' ;
execute s using 1, 2,3,4,5,6,7;


set names euckr;

drop table if exists t1;
create table t1 (a bigint);
prepare s from 'select a from t1 where a between ? and ?';
execute s using 1, 2;



drop table if exists t1;
create table t1 (a bigint);
prepare s from 'select a from t1 where a between ? and ? and rownum < ?';
execute s using 1, 2,3;



drop table if exists t1;
create table t1 (a bigint,b int,c varchar(2000),d char(200),e numeric(10,0),f CHARACTER VARYING(100));
insert into t1 select rownum,rownum,rownum,rownum,rownum,rownum from db_class limit 10;
prepare s from 'select a from t1 where a between ? and ? and 1';
execute s using 1, 2;
execute s using 1, 2;
execute s using 100, 200;



drop table if exists t1;
create table t1 (a bigint,b int,c varchar(2000),d char(200),e numeric(10,0),f CHARACTER VARYING(100));
insert into t1 select rownum,rownum,rownum,rownum,rownum,rownum from db_class limit 10;
prepare s from 'select a from t1 where a between ? and ? and rownum < ? and b between ? and ? and c between ? and ?' ;
execute s using 1, 2,3,4,5,6,7;
drop table t1;

set names iso88591;
