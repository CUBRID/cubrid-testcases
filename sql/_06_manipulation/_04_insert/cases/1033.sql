set system parameters 'create_table_reuseoid=no';
--[er]Test insert with a variable in common table
create class t1 (col1 integer, col2 varchar(20));
insert into t1 values( 101, 'xxx');
insert into t1 values( 102, 'aaa');
insert into t1 values( 103, 'bbb');
insert into t1 values( 104, 'ccc');
insert into t1 values( 105, 'ddd');
insert into t1 values( 106, 'eee');
insert into t1 values( 107, 'fff');
insert into t1 values( 108, 'zzz');
insert into t1 values( 109, 'ggg');

insert into t1 values(101, 'test') into t01;
insert into  t1 (col1, col2) values(t01);


drop class t1;
set system parameters 'create_table_reuseoid=yes';
