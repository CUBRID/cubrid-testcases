create table a1 (b int default);
create table a2 (b int shared);
create table a3 (b int default not null);
create table a4 (b int shared not null);

create table d1 (b int default null);
create table d2 (b int default null null);
create table d3 (b int default null not null);
create table s1 (b int shared null);
create table s2 (b int shared null null);
create table s3 (b int shared null not null);

drop table d1,d2,s1,s2;