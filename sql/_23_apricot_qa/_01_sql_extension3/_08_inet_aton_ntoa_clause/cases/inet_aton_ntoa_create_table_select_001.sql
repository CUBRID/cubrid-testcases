--inet_aton_ntoa_create_table_select_001.sql

select inet_aton('1.2.3.4');
select inet_ntoa(16909060);

drop table if exists test;
drop table if exists test2;

create table test( a bigint primary key, b char(10));
insert test values(inet_aton('1.2.3.4'),'1.2.3.4');
select * from test where a = inet_aton('1.2.3.4');

create table test2( a bigint primary key, b varchar(10));
insert test2 values(inet_aton('1.2.3.4'),'1.2.3.4');
select * from test2 where b = inet_ntoa(16909060);

drop table if exists test;
drop table if exists test2;
