drop x;
create table x (i int primary key);
create table y (i int shared 1 foreign key references x(i));
create table z (i int shared 1, foreign key (i) references x(i));
drop table x;

create table x (i int primary key);
create table y (i int shared 1);
alter table y add constraint foreign key (i) references x(i);
drop table y;
drop table x;

create table x (i int primary key);
create table y;
alter table y add attribute i int shared 1 foreign key references x(i);
drop table y;
drop table x;

create table x (i int primary key);
create table y (i int foreign key references x(i));
create table z (i int, foreign key (i) references x(i));
create table p (i int);
alter table p add constraint foreign key (i) references x(i);
create table q;
alter table q add attribute i int foreign key references x(i);

drop table q;
drop table p;
drop table z;
drop table y;
drop table x;

-- Error
create table x (i int primary key);
create table y (i int not null foreign key references x(i) on delete set null);
create table z (i int not null, foreign key (i) references x(i) on update set null);
drop table x;

-- No error
create table x (i int primary key);
create table y (i int foreign key references x(i) on delete set null);
create table z (i int, foreign key (i) references x(i) on update set null);
drop table y;
drop table z;
drop table x;

