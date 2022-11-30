--+ holdcas on;
-- INDEX_CARDINALITY  -- 
set system parameters 'return_null_on_function_errors = no';

-- target tables
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




-- target table, with diff name, same index names
create table t2( i1 integer , i2 integer , i3 integer, i4 integer not null);
		  
create unique index i_t1_i3_i1_i2 on t2 (i3,i1,i2);



-- data tables:
create table data_tb_1(tbl_name varchar(30), idx_name varchar(30), key_pos int);
insert into data_tb_1 values ('t1','i_t1_i1',0);
insert into data_tb_1 values ('t1','i_t1_i2_i1',0);
insert into data_tb_1 values ('t1','i_t1_i2_i1',1);
insert into data_tb_1 values ('t1','i_t1_i1_i3',0);
insert into data_tb_1 values ('t1','i_t1_i1_i3',1);
insert into data_tb_1 values ('t1','i_t1_i3',0);
insert into data_tb_1 values ('t1','i_t1_i4',0);
insert into data_tb_1 values ('t1','i_t1_i2_i1_i3',0);
insert into data_tb_1 values ('t1','i_t1_i2_i1_i3',1);
insert into data_tb_1 values ('t1','i_t1_i2_i1_i3',2);
insert into data_tb_1 values ('t1','i_t1_i3_i1_i2',1);
insert into data_tb_1 values ('t1','i_t1_i3_i1_i2',2);

-- check index is found in correct class name:
insert into data_tb_1 values ('t2','i_t1_i3_i1_i2',2);

-- wrong data : 
insert into data_tb_1 values ('t2','i_t1_i3_i1_i2',2);
insert into data_tb_1 values ('t1_a','i_t1_i3_i1_i2',2);
insert into data_tb_1 values ('t1','i_t1_i3_i1_i2_a',2);
insert into data_tb_1 values ('t2','i_t1_i3_i1_i2',2);
insert into data_tb_1 values ('t1','i_t1_i1',-1);
insert into data_tb_1 values ('','i_t1_i3_i1_i2',1);
insert into data_tb_1 values ('t1','',1);
insert into data_tb_1 values (NULL,'i_t1_i1_i3',2);
insert into data_tb_1 values ('t1',NULL,3);
insert into data_tb_1 values ('t1a','i_t1_i3_i1_i2',1);
insert into data_tb_1 values ('t1','i_t1_i3_i1_i2_',2);
insert into data_tb_1 values ('t1','i_t1_i3_i1_i2',3);
insert into data_tb_1 values ('t1','i_t1_i3_i1_i2',NULL);

create table data_tb_2(tbl_name char(30), idx_name char(30), key_pos float);
insert into data_tb_2 values ('t1','i_t1_i1',0.1);
insert into data_tb_2 values ('t1','i_t1_i1',0.8);
insert into data_tb_2 values ('t1','i_t1_i3_i1_i2',2.3);
insert into data_tb_2 values ('t1','i_t1_i3_i1_i2',2.6);

-- other table:
insert into data_tb_2 values ('t2','i_t1_i3_i1_i2',2);

-- wrong data : 
insert into data_tb_2 values ('t2','i_t1_i3_i1_i2',2);
insert into data_tb_2 values (NULL,'i_t1_i1_i3',2);
insert into data_tb_2 values ('t1',NULL,3);
insert into data_tb_2 values ('t1','i_t1_i3_i1_i2',3);
insert into data_tb_2 values ('t1','i_t1_i3_i1_i2',NULL);


create table data_tb_3(tbl_name nchar varying(30), idx_name nchar varying(30), key_pos varchar(10));
insert into data_tb_3 values (n't1',n'i_t1_i1','0');
insert into data_tb_3 values (n't1',n'i_t1_i1','1');
insert into data_tb_3 values (n't1',n'i_t1_i3_i1_i2','2');

update statistics on t1;
update statistics on t2;
update statistics on data_tb_1;
update statistics on data_tb_2;
update statistics on data_tb_3;
-- constants:
--OK:
select index_cardinality ('dba.t1','i_t1_i1',0);
select index_cardinality ('dba.t1','i_t1_i1',0.3);
-- out of range
select index_cardinality ('dba.t1','i_t1_i1',0.9);

-- national not allowed
select index_cardinality (n'dba.t1','i_t1_i1',0);
select index_cardinality ('dba.t1',n'i_t1_i1',0);

-- invalid arg : arg1 is number
select index_cardinality (4,'i_t1_i1',-1);

-- out of range
select index_cardinality ('dba.t1','i_t1_i1',-1);


-- NULL args
select index_cardinality (NULL,'i_t1_i1',0);

select index_cardinality (NULL,n'i_t1_i1',0);


-- HV : TODO
PREPARE st FROM 'SELECT index_cardinality(?,?,?)';
EXECUTE st USING 'dba.t1', 'i_t1_i1', 0; 

PREPARE st FROM 'SELECT index_cardinality(?,?,?)';
EXECUTE st USING 'dba.t1', 'i_t1_i1', '0';

PREPARE st FROM 'SELECT index_cardinality(?,?,?)';
EXECUTE st USING 1, 'i_t1_i1', '0'; 

PREPARE st FROM 'SELECT index_cardinality(?,?,?)';
EXECUTE st USING date'2001-10-01', 'i_t1_i1', '0'; 

-- tables:
select tbl_name, idx_name, key_pos, index_cardinality ('dba.' || tbl_name, idx_name, key_pos) from data_tb_1 order by 1,2,3;

select tbl_name, idx_name, key_pos, index_cardinality ('dba.' || tbl_name, idx_name, key_pos) from data_tb_2 order by 1,2,3;

select tbl_name, idx_name, key_pos, index_cardinality ('dba.' || tbl_name, idx_name, key_pos) from data_tb_3 order by 1,2,3;


select data_tb_1.tbl_name, data_tb_1.idx_name, data_tb_3.key_pos, index_cardinality ('dba.' || data_tb_1.tbl_name, data_tb_1.idx_name, data_tb_3.key_pos) from data_tb_1,data_tb_3 order by 1,2,3;


drop table t1;
drop table t2;
drop table data_tb_1;
drop table data_tb_2;
drop table data_tb_3;








commit;
--+ holdcas off;
