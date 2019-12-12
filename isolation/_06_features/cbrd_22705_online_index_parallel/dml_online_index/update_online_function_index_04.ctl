
MC: setup NUM_CLIENTS = 8;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level read committed;

C5: set transaction lock timeout INFINITE;
C5: set transaction isolation level read committed;

C6: set transaction lock timeout INFINITE;
C6: set transaction isolation level read committed;

C7: set transaction lock timeout INFINITE;
C7: set transaction isolation level read committed;

C8: set transaction lock timeout INFINITE;
C8: set transaction isolation level read committed;



/* preparation */
C1: drop table if exists t2;
C1: drop table if exists t1;
C1: create table t1(stu_id int primary key, stu_name varchar(30));
C1: insert into t1 values(1,'james'),(4,'mikey'),(8,'lucy'),(-8,'un');
C1: create table t2(class_id bigint, class_name varchar(10),stu_id int, birty_date timestamp default '2000-01-01 00:00:00', constraint foreign key(stu_id) references t1(stu_id));
C1: insert into t2(class_id, class_name,stu_id) values(1,'math',4),(1,'math',8),(2,'english',1),(2,'english',4),(3,'history',1),(3,'history',8),(4,'art',-8);
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: insert into t1 values(-16,'bob');
C1: update t2 set stu_id=-16 where class_name='history' and stu_id=8;
MC: wait until C1 ready;

C2: create index idx_t2_3 on t2(DAYOFMONTH(birty_date)) with online parallel 2;
MC: wait until C2 blocked;

C3: create index idx1 on t2(ADDDATE(birty_date, INTERVAL '12:12' HOUR_MINUTE)) with online parallel 2;
MC: wait until C3 blocked;

/* 'addtime ' function cannot be used for function based index
C4: create index idx2 on t2(ADDTIME(birty_date, time'1:1:2')) with online parallel 2;
MC: wait until C4 blocked;
*/

C4: create index idx2 on t2(DAYOFWEEK(birty_date)) with online parallel 2;
MC: wait until C4 blocked;

C5: create index idx3 on t2(ADD_MONTHS(birty_date,1)) with online parallel 2;
MC: wait until C5 blocked;

C6: create index idx3 on t2(DATE(birty_date)) with online parallel 2;
MC: wait until C6 blocked;

C7: create index idx3 on t2(DATEDIFF(birty_date,'2000-12-12 12:12:12')) with online parallel 2;
MC: wait until C7 blocked;

C8: create index idx3 on t2(SUBDATE(birty_date,INTERVAL 24 HOUR)) with online parallel 2;
MC: wait until C8 blocked;


C1: commit;
MC: wait until C1 ready;

MC: wait until C2 ready;
C2: show indexes from t2;
C2: commit;

MC: wait until C3 ready;
C3: show indexes from t2;
C3: commit;

MC: wait until C4 ready;
C4: show indexes from t2;
C4: commit;

MC: wait until C5 ready;
C5: show indexes from t2;
C5: commit;

MC: wait until C6 ready;
C6: show indexes from t2;
C6: commit;

MC: wait until C7 ready;
C7: show indexes from t2;
C7: commit;


MC: wait until C8 ready;
C8: show indexes from t2;
C8: commit;

MC: wait until C2 ready;
C1: select /*+ recompile */ * from t2 where DAYOFMONTH(birty_date)=1 using index idx_t2_3(+)  ;
C1: select /*+ recompile */ * from t2 where ADDDATE(birty_date, INTERVAL '12:12' HOUR_MINUTE)='2000-01-01 12:12:00' using index idx1(+)  ;
/* C1: select /*+ recompile */ * from t2 where ADDTIME(birty_date, time'1:1:2')='2000-01-01 01:01:02' using index idx2(+)  ; */
C1: select /*+ recompile */ * from t2 where DAYOFWEEK(birty_date)=7 using index idx2(+)  ;
C1: select /*+ recompile */ * from t2 where ADD_MONTHS(birty_date,1)=2 using index idx3(+)  ;
C1: select /*+ recompile */ * from t2 where DATE(birty_date)='2000-01-01' using index idx4(+)  ;
C1: select /*+ recompile */ * from t2 where DATEDIFF(birth_date,'1999-12-31 00:00:00')=1 using index idx5(+)  ;
C1: select /*+ recompile */ * from t2 where SUBDATE(birty_date,INTERVAL 24 HOUR)='1999-12-31 00:00:00' using index idx6(+)  ;
C1: commit work;

C1: quit;
C2: quit;
C3: quit;
C4: quit;
C5: quit;
C6: quit;
C7: quit;
C8: quit;
