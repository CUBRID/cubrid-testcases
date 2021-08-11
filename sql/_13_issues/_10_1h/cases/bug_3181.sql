-- RESTRICT
create table pk (id int primary key);
create table fk (id int);
alter table fk add constraint foreign key (id) references pk(id) on delete restrict;
insert into pk values (1);
insert into fk values (1), (1), (1);

truncate pk cascade; 
drop table fk;
drop table pk;

-- NO ACTION
create table pk (id int primary key);
create table fk (id int);
alter table fk add constraint foreign key (id) references pk(id) on delete no action;
insert into pk values (1);
insert into fk values (1), (1), (1);

truncate pk cascade; 
drop table fk;
drop table pk;

-- CASCADE
create table pk (id int primary key);
create table fk (id int);
alter table fk add constraint foreign key (id) references pk(id) on delete cascade;
insert into pk values (1);
insert into fk values (1), (1), (1);

truncate pk cascade;

select count(*) from pk; 
select count(*) from fk; 
drop table fk;
drop table pk;

-- SET NULL
create table pk (id int primary key);
create table fk (id int);
alter table fk add constraint foreign key (id) references pk(id) on delete set null;
insert into pk values (1);
insert into fk values (1), (1), (1);

truncate pk cascade;

select count(*) from pk; 
select * from fk; 
drop table fk;
drop table pk;

--trigger
create table x (a int);
create table y (a int);
 
create trigger x_t before delete on x execute insert into y values (1);

insert into x values (1), (1), (1), (1), (1);

delete from x;
select count(*) from y; 
delete from y;

truncate x;
select count(*) from y; 

drop trigger x_t;
drop table x;
drop table y;

--trigger
create table pk (id int primary key);
create table x (id int);
create table y (id int);

alter table x add constraint foreign key (id) references pk(id) on delete cascade; 
create trigger x_tr before delete on x execute insert into y values (1);

insert into pk values (1);

insert into x values (1), (1), (1), (1), (1);
delete from x;
select count(*) from y; 
delete from y;

insert into x values (1), (1), (1), (1), (1);
truncate x;
select count(*) from y; 

insert into x values (1), (1), (1), (1), (1);
delete from x;
select count(*) from y; 

drop trigger x_tr;
drop table x;
drop table y;
drop table pk;

--trigger
create table pk (id int primary key);
create table x (id int);
create table y (id int);

alter table x add constraint foreign key (id) references pk(id) on delete cascade; 
create trigger x_tr before delete on x execute insert into y values (1);

insert into pk values (1);

insert into x values (1), (1), (1), (1), (1);
delete from x;
select count(*) from y; 
delete from y;

insert into x values (1), (1), (1), (1), (1);
truncate pk cascade;
select count(*) from y; 

insert into pk values (1);

insert into x values (1), (1), (1), (1), (1);
delete from x;
select count(*) from y; 

drop trigger x_tr;
drop table x;
drop table y;
drop table pk;

