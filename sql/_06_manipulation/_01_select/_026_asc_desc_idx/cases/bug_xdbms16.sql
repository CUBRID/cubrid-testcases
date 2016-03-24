--Test create class with asc/desc index

create table ddl_0001 ( col1 int ,col2 varchar(10), col3 char(10), col4 varchar(20) );
insert into ddl_0001 values(1, '1', '1', '1');
insert into ddl_0001(col2,col4) values('1', '1');
insert into ddl_0001 values(2, '2', '2', '2');
insert into ddl_0001(col2,col4) values('2', '2');
insert into ddl_0001 values(3, '3', '3', '3');
insert into ddl_0001(col2,col4) values('3', '3');
insert into ddl_0001 values(4, '4', '4', '4');
insert into ddl_0001(col2,col4) values('4', '4');
insert into ddl_0001 values(5, '5', '5', '5');
insert into ddl_0001(col2,col4) values('5', '5');
insert into ddl_0001 values(6, '6', '6', '6');
insert into ddl_0001(col2,col4) values('6', '6');
insert into ddl_0001 values(7, '7', '7', '7');
insert into ddl_0001(col2,col4) values('7', '7');
insert into ddl_0001 values(8, '8', '8', '8');
insert into ddl_0001(col2,col4) values('8', '8');
insert into ddl_0001 values(9, '9', '9', '9');
insert into ddl_0001(col2,col4) values('9', '9');
insert into ddl_0001 values(10, '10', '10', '10');
insert into ddl_0001(col2,col4) values('10', '10');
insert into ddl_0001 values(11, '11', '11', '11');
insert into ddl_0001(col2,col4) values('11', '11');
create index ddl_0001_idx1 on ddl_0001(col1 asc, col2 desc, col3 asc, col4 desc ); 

drop class ddl_0001;
