-- references rule   

create table t1 (i1 integer primary key);

create table t2 (i2 integer foreign key references t1(i1) on delete set null); 
drop table t2;


create table t2 (i2 integer foreign key references t1(i1) on delete set null on delete set null); 
drop table t2;

create table t2 (i2 integer foreign key references t1(i1) on update set null );
drop table t2;


create table t2 (i2 integer foreign key references t1(i1) on update set null on update set null);
drop table t2;

drop table t1;


-- constant literal boolean

create table t1(i1 integer default true);
drop table t1;