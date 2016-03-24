-- SHOW INDEX  -- with multiple indexes on same column
-- two, three columns in same index
create table t1( i1 integer , i2 integer , i3 integer, i4 integer not null);
		  
insert into t1 values (1,1,1,0);
insert into t1 values (2,2,2,0);
insert into t1 values (3,3,3,0);
insert into t1 values (4,4,4,0);
insert into t1 values (5,5,5,0);
insert into t1 values (6,6,6,0);
insert into t1 values (7,7,7,0);
insert into t1 values (8,8,8,0);
insert into t1 values (9,9,9,0);
insert into t1 values (10,10,10,0);
insert into t1 values (1,1,100,0);
insert into t1 values (1,2,0,0);
insert into t1 values (1,3,30,0);
insert into t1 values (1,4,40,0);
insert into t1 values (2,10,99,0);
insert into t1 values (3,11,101,0);
insert into t1 values (4,12,102,0);
insert into t1 values (5,13,103,0);
insert into t1 values (6,14,104,0);
insert into t1 values (7,15,105,0);
insert into t1 values (8,16,106,0);
insert into t1 values (9,17,107,0);
insert into t1 values (10,18,108,0);
insert into t1 values (2,1,21,0);
insert into t1 values (3,1,31,0);
insert into t1 values (4,1,41,0);
insert into t1 values (5,1,51,0);
insert into t1 values (6,1,61,0);
insert into t1 values (7,1,71,0);
insert into t1 values (8,1,81,0);
insert into t1 values (9,1,91,0);
insert into t1 values (10,1,111,0);
insert into t1 values (10,1,NULL,0);
insert into t1 values (NULL,1,121,0);

create index i_t1_i1 on t1(i1);

create index i_t1_i2_i1 on t1(i2,i1);

create unique index i_t1_i1_i3 on t1(i1,i3);

create unique index i_t1_i3 on t1(i3);

create index i_t1_i4 on t1(i4);

create index i_t1_i2_i1_i3 on t1 (i2,i1,i3);

create unique index i_t1_i3_i1_i2 on t1 (i3,i1,i2);
update statistics on all classes;
show index from t1;
		  
drop table t1;








