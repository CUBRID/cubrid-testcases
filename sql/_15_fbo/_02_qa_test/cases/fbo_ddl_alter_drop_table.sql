-- need recheck, create 5 temp file, bug find 4.
--1. change column name

--change name of table with blob column
create table rn_t (a int, b blob, c string);
insert into rn_t values (1, bit_to_blob(X'010010'), 'hello');
rename table rn_t as rn_t1;
select a, blob_to_bit(b), c from rn_t1;
delete from rn_t1;
drop rn_t1;

--change name of table with clob column
create table rn2_t (a int, b clob, c string);
insert into rn2_t values(2, char_to_clob('test.....'), 'what are you doing');
rename table rn2_t as rn2_t1;
select a, clob_to_char(b), c from rn2_t1;
delete from rn2_t1
drop rn2_t1;

--change name of table with blob&clob column
create table rn3_t (a int, b blob, c clob);
insert into rn3_t values (1, bit_to_blob(X'010010'), char_to_clob('hello'));
rename table rn3_t as rn3_t1;
select blob_to_bit(b), clob_to_char(c) from rn3_t1;
delete from rn3_t1;
drop rn3_t1;

--change table name to the same name as the original one
create table rn4_t (a int, b blob, c clob);
insert into rn4_t values (1, bit_to_blob(X'010010'), char_to_clob('hello'));
rename table rn4_t as rn4_t;
delete from rn4_t;
drop rn4_t;

--2. add/change/drop blob/clob columns with no constraint

create table acd_t (a int primary key, b float);

--add blob/clob columns with no constraints
insert into acd_t values (1, 2.0001);
alter table acd_t add column image blob;
alter table acd_t add column text clob;
insert into acd_t values (2, 3.333, bit_to_blob(B'0101'), char_to_clob('alter and insert'));
select * from db_attribute where class_name='acd_t' order by attr_name;
select a, b, blob_to_bit(image), clob_to_char(text) from acd_t order by a;

--add blob/clob column with the same name as the existed column
--error
alter table acd_t add column image blob;
--error
alter table acd_t add column text clob;

--change blob/clob column name
alter table acd_t rename column image as photo;
alter table acd_t rename column text as doc;
select * from db_attribute where class_name='acd_t' order by attr_name;
select blob_to_bit(photo), clob_to_char(doc) from acd_t;

--change column name to the same name as the original one
--error
alter table acd_t rename column photo as photo;
--error
alter table acd_t rename column doc as doc;

--drop blob/clob column
alter table acd_t drop column photo;
alter table acd_t drop column doc;
select * from db_attribute where class_name='acd_t' order by attr_name;
--error
select blob_to_bit(photo), clob_to_char(doc) from acd_t;

--drop 2 columns at the same time
alter table acd_t add column image blob;
alter table acd_t add column text clob;
alter table acd_t drop column text, b;
select * from db_attribute where class_name='acd_t' order by attr_name;

delete from acd_t;
drop table acd_t;


--3. add/change/drop blob/clob columns with constraints

create table acd2_t (a1 int, a2 blob, a3 string);
insert into acd2_t values(1, bit_to_blob(x'01010100000'), 'add columns with constraints');

--add blob column with shared constraint
--??
alter table acd2_t add column a4 blob shared bit_to_blob(X'010010');

--add blob column with default constraint;
--error
alter table acd2_t add column a5 blob default bit_to_blob(X'010010');

--add blob column with not null constraint;
--error
alter table acd2_t add column a6 blob not null;

--add blob column with auto increment constraint;
--error
alter table acd2_t add column a7 blob auto_increment;

--add blob column with 2 constraints 
--error
alter table acd2_t add column a8 blob shared bit_to_blob(X'010010') not null;

select * from db_attribute where class_name='acd2_t' order by attr_name;


--add clob column with shared constraint
--??
alter table acd2_t add column a9 clob shared char_to_clob('010010');

--add clob column with default constraint;
--error
alter table acd2_t add column a10 clob default char_to_clob('010010');

--add clob column with not null constraint;
--error
alter table acd2_t add column a11 clob not null;

--add clob column with auto increment constraint;
--error
alter table acd2_t add column a12 clob auto_increment;

--add clob column with 2 constraints 
--error
alter table acd2_tacd2_t add column a13 clob shared char_to_clob('hahaha') not null;

select * from db_attribute where class_name='acd2_t' order by attr_name;

--change the name of blob/clob with constraints 
alter table acd2_t add column a4 blob;
alter table acd2_t add column a5 clob;
alter table acd2_t rename column a4 as new1;
alter table acd2_t rename column a5 as new2;
select * from db_attribute where class_name='acd2_t' order by attr_name;


--drop blob/clob column with constraints
alter table acd2_t drop column new1, new2;
select * from db_attribute where class_name='acd2_t' order by attr_name;

delete from acd2_t
drop table acd2_t;

--4. add/change/drop constraints to blob/clob column

create table acd3_t (a1 int, a2 string, a3 blob, a4 clob, a5 blob, a6 clob, a7 char(100), a8 clob, a9 blob);
insert into acd3_t values (55, 'alter constraints', bit_to_blob(X'92484'), char_to_clob('add'), bit_to_blob(B'00101111111'), char_to_clob('change'), 'drop', char_to_clob('forever'), bit_to_blob(B'10101010'));

--add primary key constraint to blob/clob column
--error
alter table acd3_t add constraint pk_blob primary key (a3);
--error
alter table acd3_t add constraint pk_clob primary key (a4);

--add foreign key constraint to blob/clob column
create table acd3_t1 (b1 int primary key not null, b2 clob, b3 blob);
--error
alter table acd3_t add constraint foreign key (a5) references acd3_t1(b1);
--error
alter table acd3_t add constraint foreign key (a6) references acd3_t1(b1);
--add normal foreign key
alter table acd3_t add column aa int not null;
alter table acd3_t add constraint foreign key (aa) references acd3_t1(b1);

--add unique constraint to blob/clob column
--error
alter table acd3_t add constraint u_a9 unique (a9);
--error
alter table acd3_t add constraint u_a8 unique (a8);

delete from acd3_t;
delete from acd3_t1;
drop table acd3_t;
drop table acd3_t1;

