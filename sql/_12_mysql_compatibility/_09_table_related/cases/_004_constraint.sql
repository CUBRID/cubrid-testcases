create table tree(id int not null, parentid int, text varchar(32), constraint id primary key(id));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,3,'AAB');

insert into tree values(7,3,'AAB');

drop table tree;

create table tree(id int not null, parentid int, text varchar(32), constraint unique key nq_index(id));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,3,'AAB');

insert into tree values(7,3,'AAB');

drop table tree;

create table ex1(id int primary key);
create table ex2(id int unique);
create table ex3(id int primary key unique);
create table ex4(id int unique primary key);
create table ex5(id int primary key unique key);
create table ex6(id int unique key primary key);
create table err1(id key);
create table err2(id primary);

drop table ex1;
drop table ex2;
drop table ex3;
drop table ex4;
drop table ex5;
drop table ex6;

create table referenced (id int primary key, col int unique);
create table points (col int foreign key references referenced(id));

insert into referenced values(1,2);
insert into referenced values(2,4);
insert into points values(2);
insert into points values(2);
insert into points values(4);
insert into points values(3);

drop table points;
drop table referenced;