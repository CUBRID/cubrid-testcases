--buf fix for BTS 389 issue

create table tb1 ( col1 numeric(10,0));
insert into tb1(col1) values(1);
alter table tb1 add column col2 varchar(16);
create index i_tb1 on tb1(col1, col2);
update tb1 set col2 = 'TKI' where col1 =1;
select * from tb1 using index i_tb1(+);

create table tb2 ( col1 numeric(10,0) primary key);
insert into tb2(col1) values(1);
alter table tb2 add column col2 varchar(16);
create index i_tb2 on tb2(col1, col2);
update tb2 set col2 = 'TKI' where col1 =1;
select * from tb2  using index i_tb2(+);
delete from tb2;

create table tb3 ( col1 numeric(10,0));
insert into tb3(col1) values(1);
alter table tb3 add column col2 varchar(16);
create reverse index i_tb3 on tb3(col1, col2);
update tb3 set col2 = 'TKI' where col1 =1;
select * from tb3 using index i_tb3(+);

create table tb4 ( col1 numeric(10,0));
insert into tb4(col1) values(1);
alter table tb4 add column col2 varchar(16);
create  index i_tb4 on tb4(col1 desc, col2 desc);
update tb4 set col2 = 'TKI' where col1 =1;
select * from tb4 using index i_tb4(+);

create table tb5 ( col1 numeric(10,0));
insert into tb5(col1) values(1);
alter table tb5 add column col2 varchar(16);
create  index i_tb5 on tb5(col1 desc, col2 desc);
create  index i_tb51 on tb5(col1 , col2 );
update tb5 set col2 = 'TKI' where col1 =1;
select * from tb5 using index i_tb5(+);



drop tb1, tb2, tb3, tb4, tb5;