 -- [er]create a index for primary keys with two columns


create table p7 (a int primary key, b int primary key);
create unique index u_idx  on p7 ( a, b);





drop table p7;
