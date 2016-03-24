--Create unique index with keyword asc/desc and char,varchar datatype
create class ddl_0001(col1 char(10), col2 varchar(20), col3 varchar(4096), col4 char(1024), col5 char(1) );
insert into ddl_0001 values('1001','1001','2041','100001','1');
insert into ddl_0001 values('1002','1002','2042','100002','2');
insert into ddl_0001 values('1003','1003','2043','100003','3');
insert into ddl_0001 values('1004','1004','2044','100004','4');
insert into ddl_0001 values('1005','1005','2045','100005','5');
insert into ddl_0001 values('1006','1006','2046','100006','6');
insert into ddl_0001 values('1007','1007','2047','100007','7');
insert into ddl_0001 values('1008','1008','2048','100008','8');
create unique index ddl_0001_idx0 on ddl_0001(col1 asc);
create unique index ddl_0001_idx1 on ddl_0001(col3 desc);
create unique index ddl_0001_idx2 on ddl_0001(col2 asc);
create unique index ddl_0001_idx7 on ddl_0001(col4 asc);
create unique index ddl_0001_idx8 on ddl_0001(col5 asc);
create unique index ddl_0001_idx3 on ddl_0001(col1 asc, col2 desc);
create unique index ddl_0001_idx4 on ddl_0001(col1 asc, col2 desc, col3 asc);
create unique index ddl_0001_idx5 on ddl_0001(col1 asc,col2 desc, col3 desc, col4 asc);
create unique index ddl_0001_idx6 on ddl_0001(col1 asc, col2 desc, col3 asc, col4 desc, col5 asc);
select * from db_index where class_name='ddl_0001' order by 1,2,3;
select * from db_index_key where class_name='ddl_0001' order by 1,2,3;
select * from ddl_0001 where col1 not like '100%' order by 1,2,3;
delete from ddl_0001 where col1='1008'
update ddl_0001 set col1='2050' where col1='1001';
drop class ddl_0001;
