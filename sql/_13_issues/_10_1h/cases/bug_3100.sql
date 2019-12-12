create table t (a varchar(30) not null);
create index i on t(a(2));
drop index i on t;
drop table t;

create table p (a varchar(30) primary key);
create table f (a varchar(30), foreign key(a) references p(a));
create table u (a varchar(30) unique);
create index i_p on p(a(2)); 
create index i_f on f(a(2)); 
create index i_u on u(a(2)); 
drop table u;
drop table f;
drop table p;

create table n (a varchar(30) not null);
create table p (a varchar(30) primary key);
create table f (a varchar(30), foreign key(a) references p(a));
create table u (a varchar(30) unique);
create index i_n on n(a);
create index i_p on p(a); 
create index i_f on f(a); 
create index i_u on u(a); 
drop index i_n on n;
drop table u;
drop table f;
drop table p;
drop table n;

