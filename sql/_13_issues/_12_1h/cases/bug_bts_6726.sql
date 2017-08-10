create table tb (a int not null, b int);
create index i_tb_a on tb(a) where a is null;
create index i_tb_b on tb(a) where b is null;
drop table tb;

create table tb (a int not null, b int);
create index i_tb_a on tb(a) where b is not null;
drop table tb;

create table tb (a int not null, b int);
create index i_tb_a on tb(a) where b is not null;
drop table tb;


create table tb (a int , b int not null);
create index i_tb_a on tb(a) where a is null;
create index i_tb_b on tb(a) where b is null;
drop table tb;

create table tb (a int, b int not null);
create index i_tb_a on tb(a) where b is not null;
drop table tb;

create table tb (a int , b int not null);
create index i_tb_a on tb(a) where b is not null;
drop table tb;

