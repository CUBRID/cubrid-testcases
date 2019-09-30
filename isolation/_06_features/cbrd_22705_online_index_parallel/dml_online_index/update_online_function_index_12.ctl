
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;


/* preparation */
C1: drop table if exists t2;
C1: drop table if exists t1;
C1: create table t1(stu_id int primary key, stu_name varchar(30));
C1: insert into t1 values(1,'james'),(4,'mikey'),(8,'lucy'),(-8,'un');
C1: create table t2(class_id bigint, class_name varchar(10),stu_id int, constraint foreign key(stu_id) references t1(stu_id));
C1: insert into t2(class_id, class_name,stu_id) values(1,'math',4),(1,'math',8),(2,'english',1),(2,'english',4),(3,'history',1),(3,'history',8),(4,'art',-8);
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: insert into t1 values(-16,'bob');
C1: update t2 set stu_id=-16 where class_name='history' and stu_id=8;
C1: alter table t2 add column birty_date timestamp default '2000-01-01 00:00:00';
MC: wait until C1 ready;
C2: create index idx3 on t2(DAYOFYEAR(birty_date)) with online parallel 2;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;

MC: wait until C2 ready;
C2: insert into t2(class_id,class_name,stu_id,birty_date) values(10,'extra',4,'2008-01-01 00:00:00');
C2: update statistics on t2 with fullscan;
C2: show indexes from t2;
C2: commit;

 /* 'extract',from_tz function cannot be used for function based index
C1: update t2 set birty_date='2001-02-01 00:00:00' where class_id=10;
MC: wait until C1 ready;
C2: create index idx4 on t2(EXTRACT(MONTH FROM birty_date)) with online parallel 3;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;

MC: wait until C2 ready;
C2: insert into t2(class_id,class_name,stu_id,birty_date) values(11,'extra',4,'2008-01-01 00:00:00');
C2: update statistics on t2 with fullscan;
C2: show indexes from t2;
C2: commit;


C1: update t2 set birty_date='2002-01-01 00:00:00' where class_id=11;
MC: wait until C1 ready;
C2: create index idx5 on t2(FROM_TZ(birty_date,'Asia/Seoul')) with online parallel 3;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;

MC: wait until C2 ready;
C2: insert into t2(class_id,class_name,stu_id,birty_date) values(10,'extra',4,'2008-01-01 00:00:00');
C2: update statistics on t2 with fullscan;
C2: show indexes from t2;
C2: commit;

*/
C1: update t2 set birty_date='2003-01-01 01:00:00' where class_id=10;
MC: wait until C1 ready;
C2: create index idx6 on t2(HOUR(birty_date)) with online parallel 3;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;

MC: wait until C2 ready;
C2: insert into t2(class_id,class_name,stu_id,birty_date) values(11,'extra',4,'2008-01-01 01:00:00');
C2: update statistics on t2 with fullscan;
C2: show indexes from t2;
C2: commit;


C1: update t2 set birty_date='2004-01-01 00:00:00' where class_id=11;
MC: wait until C1 ready;
C2: create index idx7 on t2(LAST_DAY(birty_date)) with online parallel 3;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;

MC: wait until C2 ready;
C2: insert into t2(class_id,class_name,stu_id,birty_date) values(12,'extra',4,'2008-01-01 01:00:00');
C2: update statistics on t2 with fullscan;
C2: show indexes from t2;
C2: commit;


C1: update t2 set birty_date='2005-01-01 00:01:00' where class_id=12;
MC: wait until C1 ready;
C2: create index idx8 on t2(MINUTE(birty_date)) with online parallel 3;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;

MC: wait until C2 ready;
C2: insert into t2(class_id,class_name,stu_id,birty_date) values(13,'extra',4,'2008-01-01 00:01:00');
C2: update statistics on t2 with fullscan;
C2: show indexes from t2;
C2: commit;



C1: update t2 set birty_date='2006-06-01 00:00:00' where class_id=13;
MC: wait until C1 ready;
C2: create index idx9 on t2( MONTH(birty_date)) with online parallel 3;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;

MC: wait until C2 ready;
C2: insert into t2(class_id,class_name,stu_id,birty_date) values(10,'extra',4,'2008-02-01 00:00:00');
C2: update statistics on t2 with fullscan;
C2: show indexes from t2;
C2: commit;

MC: wait until C2 ready;
C1: select /*+ recompile */ * from t2 where  MONTH(birty_date) >=2 using index idx9(+) ;
C1: select /*+ recompile */ * from t2 where  MINUTE(birty_date) >=1 using index idx8(+) ;
C1: select /*+ recompile */ * from t2 where  Last_day(birty_date) >='01/31/2008' using index idx7(+) ;
C1: select /*+ recompile */ * from t2 where  HOUR(birty_date) >=1 using index idx6(+) ;
C1: select /*+ recompile */ * from t2 where  dayofyear(birty_date) >=50 using index idx3(+) ;
C1: commit work;

C2: quit;
C1: quit;
