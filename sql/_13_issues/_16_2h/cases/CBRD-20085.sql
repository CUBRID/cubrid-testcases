set names euckr;
select concat('_', trim('       aa         '), '_');
select concat('_', rtrim('       aa         '), '_');
select concat('_', ltrim('       aa         '), '_');

set names binary;
select concat('_', trim('       aa         '), '_');
select concat('_', rtrim('       aa         '), '_');
select concat('_', ltrim('       aa         '), '_');


drop table if exists t;
set names binary;
create table t ( str_binary varchar(50) charset binary);
insert into t values ('       aa         ');

select * from t;
select concat('_',rtrim(str_binary),'_') from t;
select concat('_',ltrim(str_binary),'_') from t;
select concat('_',trim(str_binary),'_') from t;


drop table if exists t;
set names euckr;
create table t ( str_euckr varchar(50) charset euckr);
insert into t values ('       aa         ');

select * from t;
select concat('_',rtrim(str_euckr),'_') from t;
select concat('_',ltrim(str_euckr),'_') from t;
select concat('_',trim(str_euckr),'_') from t;

drop table t;
