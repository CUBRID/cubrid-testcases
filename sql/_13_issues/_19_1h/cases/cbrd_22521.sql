drop if exists ddl_0001,ddl_0002;
create class ddl_0001(col1 int, col2 varchar(10), col3 date, col4 time, col5 monetary, col6 char(10));
insert into ddl_0001 values(101, '101', date '08/08/2008', time '10:18',10001,'100001');
create class ddl_0002 under ddl_0001(col7 timestamp, col8 double, col9 float(6));
insert into ddl_0002 values(101, '101', date '08/08/2008', time '10:18',10001,'100001',timestamp '08/08/2008 10:18:00',1001.1,100.1);
create index ddl_0001_idx0 on ddl_0001(col1 asc) with online;
show indexes from ddl_0001;
drop if exists ddl_0001,ddl_0002;
