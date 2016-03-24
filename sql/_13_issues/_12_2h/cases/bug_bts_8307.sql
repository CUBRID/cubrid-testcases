--TEST: [Merge Statement] Core dumped when doing roll back after executing a merge statement.


autocommit off;

drop table if exists c1, c2, t1, t2, actions;


create table c1 as select rownum a from db_class d1, db_class d2, db_class d3 limit 100;
create table c2 as select rownum a from db_class d1, db_class d2, db_class d3 limit 20;
create table t1(a int primary key, b smallint, c varchar(100));
insert into t1 select rownum aaa, 100, rownum||'' from c1, c2 order by aaa limit 1000;
insert into t1 select rownum+1000 aaa, 200, (rownum+1000)||'' from c1, c2 order by aaa limit 1000;
create table t2(a int primary key, b smallint, c varchar(100));
insert into t2 select rownum aaa, 888, rownum||'a' from c1, c2 where rownum <=2000 order by aaa for (orderby_num()+1)%2=0;
insert into t2 select rownum+2000 aaa, 999, 'inserted' from c1, c2 where rownum <= 2000 order by aaa for (orderby_num()+1)%2=0;
create table actions(a int primary key auto_increment, b char(10));
create trigger tr1 before statement update on t1 execute insert into actions(b) values('updated');
create trigger tr2 after statement delete on t1 execute insert into actions(b) values('deleted');
create trigger tr3 before statement insert on t1 execute insert into actions(b) values('inserted');

commit;


merge into t1 using t2 on (t1.a=t2.a) when matched then update set t1.b=t2.b, t1.c=t2.c;
select if(count(*)=2000, 'ok', 'nok') from t1;
select if(count(*)=1, 'ok', 'nok') from actions;

rollback;


merge into t1 using t2 on (t1.a=t2.a) when matched then update set t1.c=t2.c when not matched then insert values(t2.a, t2.b, t2.c);
select if(count(*)=3000, 'ok', 'nok') from t1;
select if(count(*)=2, 'ok', 'nok') from actions;

rollback;


drop table c1, c2,actions,t1,t2;
commit;


autocommit on;
