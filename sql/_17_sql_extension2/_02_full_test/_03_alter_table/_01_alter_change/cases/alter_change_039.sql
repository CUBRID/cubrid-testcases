--auto_increment with pk


create table coo(col1 int auto_increment primary key, col2 int);

insert into coo(col2) values(33);
insert into coo(col2) values(44);
insert into coo(col2) values(55);


--auto_increment -> auto_increment
alter table coo change col1 aaa int auto_increment;
insert into coo(col2) values(66);

select * from coo order by 1;

drop table coo;
