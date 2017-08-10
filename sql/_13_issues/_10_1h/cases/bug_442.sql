create table tbl_A (a int primary key, b int);
create table tbl_B (ba int primary key, a int);
alter table tbl_B add constraint tbl_B_fk
FOREIGN KEY(a) REFERENCES tbl_A(a) on delete no action on update no action;
insert into tbl_A values (1, 1);
insert into tbl_A values (2, 2);
insert into tbl_A values (3, 3);
insert into tbl_B values (1, 1);
insert into tbl_B values (2, 2);
insert into tbl_B values (3, 3);
delete from tbl_A where a=3;
DROP TABLE tbl_B;
DROP TABLE tbl_A;

create table tbl_A (a int primary key, b int);
create table tbl_C (ba int primary key, a int);
alter table tbl_C add constraint tbl_C_fk
FOREIGN KEY(a) REFERENCES tbl_A(a) on delete cascade;
insert into tbl_A values (1, 1);
insert into tbl_A values (2, 2);
insert into tbl_A values (3, 3);
insert into tbl_C values (1, 1);
insert into tbl_C values (2, 2);
insert into tbl_C values (3, 3);
delete from tbl_A where a=3;
select count(*) from tbl_A where a=3;
select count(*) from tbl_C where a=3;
DROP TABLE tbl_C;
DROP TABLE tbl_A;

create table tbl_A (a int primary key, b int);
create table tbl_D (ba int primary key, a int);
alter table tbl_D add constraint tbl_D_fk
FOREIGN KEY(a) REFERENCES tbl_A(a) on delete restrict;
insert into tbl_A values (1, 1);
insert into tbl_A values (2, 2);
insert into tbl_A values (3, 3);
insert into tbl_D values (1, 1);
insert into tbl_D values (2, 2);
insert into tbl_D values (3, 3);
delete from tbl_A where a=3;
DROP TABLE tbl_D;
DROP TABLE tbl_A;