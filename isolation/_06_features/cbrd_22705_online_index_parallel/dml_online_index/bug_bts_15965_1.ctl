/*
Test Case: related to CUBRIDSUS-15965
Priority: 1
Reference case:
Author: Lily

Test Point:
the most important aspect of this cache is making sure it is always consistent and that entries are correctly added and removed. 
To test this situation, An entry is added once a table is accessed by using DML and are removed once the table is dropped and the transaction commits. I recommend using various combinations of such scenarios (multiple transactions) and try dropping the table with commit , rollback, while others attempt to access the table.
*/

/* preparation */
MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;
C2: commit;
C3: commit;

C1: drop table if exists t;
C1: drop table if exists foo;
C1: create table t(id int,col1 char(10),col2 VARCHAR(2000)) partition by range(id)(partition p1 values less than (5000),partition p2 values less than (10000),partition p3 values less than (15000),partition p4 values less than (20000),partition p5 values less than (25000),partition p6 values less than (30000),partition p7 values less than (35000),partition p8 values less than (40000),partition pm values less than MAXVALUE);
C1: create table foo(id int,col1 char(10) ,col2 VARCHAR(2000));
C1: insert into t select rownum, 'abc',repeat('abcdefg',200) from db_class a, db_class b, db_class c, db_class d limit 10000;
C1: insert into t select id+10000,col1,col2 from t;
C1: insert into t select id+20000,col1,col2 from t;
C1: commit;
MC: wait until C1 ready;

/* test case 1 - move record between partitions to test if entries are correctly added and removed. */
C1: update t set id=id+5000,col1='bcde' where id<5000;   --p1 to p2
C1: update t set id=id+5000,col1='river' where col1='bcde';    --p2 to p3
C1: update t set id=id+5000,col2=repeat('abcdefg',1) where col1='river';    --p3 to p4
C1: update t set id=id+5000,col2=repeat('abcdefg',200) where col1='river';    --p4 to p5
C1: update t set id=id+5000,col2=repeat('abcdefghi',200) where col1='river';    --p5 to pm
MC: wait until C1 ready;
C2: insert into foo select rownum, 'abc',repeat('abcdefg',200) from db_class a, db_class b, db_class c, db_class d limit 1000;
C2: alter table t drop partition p2,p4;
MC: wait until C2 blocked;
C3: insert into foo select rownum, 'abc',repeat('abcdefg',200) from db_class a, db_class b, db_class c, db_class d limit 1000;
C3: alter table t drop partition p3,pm;
MC: wait until C3 blocked;
C1: commit;
MC: wait until C1 ready;
C2: rollback;
MC: wait until C2 ready;
C3: show tables;
C3: commit;
MC: wait until C3 ready;

/* preparation 2*/
C1: drop table if exists t;
C1: drop table if exists foo;
C1: create table t(id int,col1 char(10),col2 VARCHAR(2000)) partition by range(id)(partition p1 values less than (5000),partition p2 values less than (10000),partition p3 values less than (15000),partition p4 values less than (20000),partition p5 values less than (25000),partition p6 values less than (30000),partition p7 values less than (35000),partition p8 values less than (40000),partition pm values less than MAXVALUE);
C1: create table foo(id int,col1 char(10) ,col2 VARCHAR(2000));
C1: commit;
MC: wait until C1 ready;

/* test case 2 - transaction is rollbacked */
C1: alter table t drop partition pm;
MC: wait until C1 ready;
C2: insert into foo select rownum, 'abc',repeat('abcdefg',200) from db_class a, db_class b, db_class c, db_class d limit 1000;
C2: insert into t select rownum, 'abc',repeat('abcdefg',200) from db_class a, db_class b, db_class c, db_class d limit 10000;
MC: wait until C2 blocked;
C3: create index idx_foo on foo(id,col1) with online parallel 2;
MC: wait until C3 blocked;
C1: commit;
MC: wait until C1 ready;
C2: rollback;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C2: select count(*) from t;
C2: show tables;
MC: wait until C1 ready;
C2: commit;

C3: quit;
C2: quit;
C1: quit;
