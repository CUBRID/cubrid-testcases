drop table if exists show_create1;
drop table if exists show_create2;
create table show_create1 (a int primary key);
create table show_create2 (b int, foreign key t2_fk(b) references show_create1(a));
show create table show_create2;

drop table if exists show_create3;
drop table if exists show_create4;
create table show_create3(a int, b int,  primary key(a, b));
create table show_create4 (c int, d int, foreign key t4_fk(c, d) references show_create3(a, b));
show create table show_create4;

drop table if exists show_create5;
drop table if exists show_create6;
create table show_create5(a int, b int,  primary key(a, b));
create table show_create6(c int, d int, foreign key t6_fk(c, d) references show_create5(b, a));
show create table show_create6;

drop table if exists show_create2;
drop table if exists show_create1;

drop table if exists show_create4;
drop table if exists show_create3;

drop table if exists show_create6;
drop table if exists show_create5;
