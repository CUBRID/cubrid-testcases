--foreing key related change


create table coo_pk(col1 int primary key, b nchar(20));
insert into coo_pk values(1, n'aaa');
insert into coo_pk values(2, n'bbb');
insert into coo_pk values(3, n'ccc');
select * from coo_pk order by 1;

create table coo_fk(a int unique, b string,
		    constraint id foreign key(a) references coo_pk(col1));
insert into coo_fk values(1, 'AAA'), (3, 'CCC');
select * from coo_fk order by 1;


--change a column with a referencing foreign key
--1. ?? change with the same content
alter table coo_fk change a a int unique;
--2. [er] change name and constraint
alter table coo_fk change a aa int not null;


--change a column referenced by a foreign key
--1. ?? change with the same content
alter table coo_pk change col1 col1 int primary key;
--2. [er] change name and constraint
alter table coo_pk change col1 col5 int unique first;


drop table coo_fk;
drop table coo_pk;

