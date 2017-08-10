create table _1122_index_all_column02
( id1 date, index i__1122_index_all_column02_id1 (id1), id2 time);

create reverse index ri__1122_index_all_column02_id1 on _1122_index_all_column02(id1);

create table _1122_index_all_column03
( id1 date, index i__1122_index_all_column03_id1 (id1), id2 time);

create index i__1122_index_all_column03_id2 on _1122_index_all_column03(id2);

create table _1122_index_all_column04
( id1 date, index i__1122_index_all_column04_id1 (id1), id2 time);

select class_name, index_name from db_index where class_name like '%_11%' order by 1,2 ;

drop table _1122_index_all_column02;

drop table _1122_index_all_column03;

drop table _1122_index_all_column04;

