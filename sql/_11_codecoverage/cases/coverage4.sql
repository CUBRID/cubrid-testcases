set system parameters 'create_table_reuseoid=no';
--get statistics '#objects' of _db_class;
--get statistics '#pagess' of _db_class;
--get statistics '#attributes' of _db_class;
--get statistics 'min(class_type)' of _db_class;
--get statistics 'min(class_type)' of _db_class;
--get statistics 'min(class_type)' of _db_class;

--set optimization level on;
--set optimization level off;

autocommit off;
set system parameters 'dont_reuse_heap_file=yes';
get optimization cost 'iscan' into :default_iscan;

get optimization level into :l;

set optimization cost 'iscan' '0';
get optimization cost 'iscan' into :c;

--set system parameters 'error_log_level=notification','log_trace_debug=yes';
--get trigger trace into :t1;
--get trigger depth into :t2;

--select :l, :c, :t1, :t2 from db_root;

create class xxx(
active int,
analyze int,
cache int,
committed int,
decrement int,
inactive int,
infinite int,
instances int,
invalidate int, 
lock int,
maximum int,
members int);

create class yyy(
--partition int,
--partitioning int,
--partitions int,
--print int,
reject int,
remove int,
reorganize int,
repeatable int,
retain int,
reverse int,
stability int,
statement int,
than int,
timeout int,
trace int,
uncommitted int,
workspace int
);

create class alter_test
class attribute (x string default 'a')
(y int);

alter class alter_test modify class attribute x string default 'b';

grant add, drop, reference to public on alter_test, yyy;
grant add, drop, references to public on alter_test, yyy;
revoke add, drop, references from public on alter_test, yyy;

create class aa(
a int unique not deferrable,
b int primary key deferrable, initially deferred,
c int not null initially immediate, not deferrable
);

drop xxx;
drop yyy;
drop alter_test;
drop aa;

create /*+ NO_STATS */ class hinttest (a int);
create /*+ NO_STATS */ index idx on hinttest (a);

insert /*+ LOCK_TIMEOUT(10) */ into hinttest values (1);
select /*+ LOCK_TIMEOUT(10) */ * from hinttest;
update /*+ LOCK_TIMEOUT(10) */ hinttest set a = 2 where a = 1;
delete /*+ LOCK_TIMEOUT(10) */ from hinttest;

insert /*+ NO_LOGGING */ into hinttest values (1);
update /*+ NO_LOGGING */ hinttest set a = 2 where a = 1;
delete /*+ NO_LOGGING */ from hinttest;

insert /*+ RELEASE_LOCK */ into hinttest values (1);
update /*+ RELEASE_LOCK */ hinttest set a = 2 where a = 1;
delete /*+ RELEASE_LOCK */ from hinttest;
drop hinttest;

-- CREATE TABLE WITH RANGE PARTITIONS
CREATE TABLE participant3 (host_year INT,host_date DATE, nation CHAR(3), gold INT, silver INT, bronze INT) 
PARTITION BY RANGE (host_year) 
(PARTITION before_2000 VALUES LESS THAN (2000), 
PARTITION after_2000 VALUES LESS THAN (2008) ); 
 
-- INSERT DATA
INSERT INTO participant3 VALUES (1988,'1988-01-01', 'NZL', 3, 2, 8); 
INSERT INTO participant3 VALUES (1988,'1988-01-01', 'CAN', 3, 2, 5); 
INSERT INTO participant3 VALUES (1996,'1996-01-01', 'KOR', 7, 15, 5); 
INSERT INTO participant3 VALUES (2000,'2000-01-01', 'RUS', 32, 28, 28); 
INSERT INTO participant3 VALUES (2004,'2004-01-01', 'JPN', 16, 9, 12); 

--INSERT NULL DATA
INSERT INTO participant3 VALUES(NULL,NULL, 'AAA', 0, 0, 0); 

SELECT * FROM participant3 WHERE (extract(year from host_date)) between 2002 and 2005;

--REORGANIZE
ALTER TABLE participant3 REORGANIZE PARTITION before_2000 INTO ( 
PARTITION before_1996 VALUES LESS THAN (1996), 
PARTITION before_2000 VALUES LESS THAN (2000) 
);
-- ADD PARTITION
ALTER TABLE participant3 ADD PARTITION (PARTITION after_2008 VALUES LESS THAN MAXVALUE); 

-- DROP PARTITION
ALTER TABLE participant3 DROP PARTITION before_2000; 

ALTER TABLE participant3 REMOVE PARTITIONING;

-- CREATE TABLE 
CREATE TABLE nation3 
( code CHAR(3), NAME VARCHAR(50) );

ALTER TABLE nation3 
PARTITION BY HASH ( code) PARTITIONS 0; 

ALTER TABLE nation3 
PARTITION BY HASH ( code) PARTITIONS 4; 

INSERT INTO nation3 VALUES (NULL, 'Korea');

-- COALEASCE PARTITION
ALTER TABLE nation3 COALESCE PARTITION 4; 
ALTER TABLE nation3 COALESCE PARTITION 2;
 
-- CREATE TABLE WITH LIST PARTITIONS
CREATE TABLE athlete2( NAME VARCHAR(40), event VARCHAR(30) ) 
PARTITION BY LIST (event) ( 
PARTITION event1 VALUES IN ('Swimming', 'Athletics' ), 
PARTITION event2 VALUES IN ('Judo', 'Taekwondo','Boxing'), 
PARTITION event3 VALUES IN ('Football', 'Basketball', 'Baseball', NULL) 
); 

--INSERT DATA TO LIST PARTITIONS
INSERT INTO athlete2 VALUES ('Hwang Young-Cho', 'Athletics'); 
INSERT INTO athlete2 VALUES ('Lee Seung-Yuop', 'Baseball'); 
INSERT INTO athlete2 VALUES ('Moon Dae-Sung','Taekwondo'); 
INSERT INTO athlete2 VALUES ('Cho In-Chul', 'Judo'); 
INSERT INTO athlete2 VALUES ('Hong Kil-Dong', 'Volleyball'); 

INSERT INTO athlete2 VALUES ('Choo Shin-Soo', NULL); 
UPDATE athlete2 SET event='Baseball' WHERE name='Choo Shin-Soo'; 

-- SPLIT PARTITIONS
ALTER TABLE athlete2 REORGANIZE PARTITION event2 INTO 
(PARTITION event2_1 VALUES IN ('Judo'), 
PARTITION event2_2 VALUES IN ( 'Taekwondo','Boxing')); 

-- MERGE PARTITIONS
ALTER TABLE athlete2 REORGANIZE PARTITION event2_1, event2_2 INTO 
(PARTITION event2 VALUES IN('Judo','Taekwondo','Boxing')); 


-- ���� ���̺��� ����ϴ� college_student ���̺� ��
CREATE TABLE college_student UNDER athlete2( 
college_year INT, 
grade double, 
subject MULTISET(VARCHAR(20)) 
);
 
-- college_student ���̺? ������ ���� SQL�� --> 
INSERT INTO college_student VALUES ('Hwang Young-Cho', 'Athletics', 4, 3.14567324, {'JAVA',' C'}); 
INSERT INTO college_student VALUES ('Lee Seung-Yuop', 'Baseball', 1, 2.987364762, {});
 
-- DROP PARTITIONS
ALTER TABLE athlete2 DROP PARTITION event2; 
drop participant3;
drop nation3;
drop college_student;
DROP athlete2; 

create class hi ( a int , b string );
create class tt1( a int, b string );
create trigger tt1_insert
after insert on tt1
execute insert into hi(a, b) values( obj.a ,to_char(obj.a));
insert into tt1(a,b) values(1, 'test');

drop trigger tt1_insert;

CREATE CLASS dddl_0001
(
       aa_no numeric(8,0) NOT NULL,
       num numeric(8,0) NOT NULL
);
create unique index u_idx on dddl_0001(aa_no, num);
CREATE CLASS dddl_0002
(
       aa_no numeric(8,0) NOT NULL unique,
       aa set(dddl_0001)
);
CREATE TRIGGER dddl_0002_01
  STATUS ACTIVE
  PRIORITY 0.000000
  BEFORE UPDATE ON dddl_0001(aa_no)
  EXECUTE PRINT '********** aa_update_del trigger **********';
CREATE TRIGGER dddl_0002_02
  STATUS ACTIVE
  PRIORITY 0.000000
  BEFORE UPDATE ON dddl_0001(aa_no)
  EXECUTE update dddl_0002 set aa=aa-{obj} where aa_no=obj.aa_no;
CREATE TRIGGER dddl_0002_03
  STATUS ACTIVE
  PRIORITY 0.000000
  AFTER UPDATE ON dddl_0001(aa_no)
  EXECUTE PRINT '********** aa_update_ins trigger **********';
CREATE TRIGGER dddl_0002_04
  STATUS ACTIVE
  PRIORITY 0.000000
  AFTER UPDATE ON dddl_0001(aa_no)
  EXECUTE update dddl_0002 set aa=aa+{obj} where aa_no=obj.aa_no;

CREATE CLASS DCL1 (id int);	
CREATE TRIGGER DCL1	
BEFORE UPDATE ON DCL1	
EXECUTE REJECT;	

update dcl1 set id=id+1;

drop trigger DCL1;

create class cl1(col1 integer, col2 varchar(20));
create trigger tr1
  before insert on cl1
  if new.col1 is null
  execute reject;

insert into cl1 values (null,'test');

create class cl10 ( col1 int, col2 varchar(10));

create trigger tr10
  before insert on cl10
  if new.col1 > 9
  execute insert into cl10 values (new.col1 - 5, 'nhn');
  
insert into cl10 values(10,'nhnchina');

CREATE CLASS DCL2 (id int);	
CREATE TRIGGER DCL2	
DEFERRED INSERT ON DCL2	
EXECUTE INVALIDATE TRANSACTION; 

insert into dcl2 values (1);

drop trigger  dddl_0002_01;
drop trigger  dddl_0002_02;
drop trigger  dddl_0002_03;
drop trigger  dddl_0002_04;
drop trigger tr10
drop trigger tr1
drop trigger DCL2;

drop hi;
drop tt1;
drop dddl_0001;
drop dddl_0002;
drop DCL1;
drop cl1;
drop cl10;
drop DCL2;


create table aaa(a int, b nchar);
insert into aaa values(null, null);
select exp(a) from aaa;
select sqrt(a) from aaa;
select chr(a) from aaa;

SELECT INSTR('United Arab Emirates', '', 4) FROM db_root;
SELECT INSTR('United Arab Emirates', NULL, 4) FROM db_root;

SELECT POSITION ('' IN 'United States of America') FROM db_root;
SELECT POSITION (NULL IN 'United States of America') FROM db_root;

select lower('') from aaa; 
select lower(NULL) from aaa; 
select lower(b) from aaa; 

select upper('') from aaa; 
select upper(NULL) from aaa; 
select upper(b) from aaa; 


SELECT TO_DATETIME('6/5/2009 10:12:13') FROM db_root;
SELECT TO_DATETIME('10:12:13 AM 6/5/2009') FROM db_root;

select case when local_transaction_id>0 then 'OK' else 'NOK' end local_transaction_id_level from db_root;
drop aaa;

set optimization cost 'iscan' :default_iscan;
get optimization cost 'iscan' into :xxx;
select :xxx;
set system parameters 'dont_reuse_heap_file=no';
commit;
autocommit on;

set system parameters 'create_table_reuseoid=yes';
