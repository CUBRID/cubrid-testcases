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


-- create table ordering of attributes    
-- 
create table t1 ( i1 integer , i2 integer first);
drop table t1;

create table t1 ( i1 integer ,  i2 integer , i3 integer after i1);
drop table t1;
