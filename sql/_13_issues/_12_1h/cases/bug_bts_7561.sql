--TEST: [Multi-table Update] core dumped when updating 2 tables with left outer join on clob columns.


create table t1(id1 int, col2 clob);
insert into t1 values(1, 'cubrid'), (2, 'mysql'), (3, 'abc');

create table t2(col1 clob, id2 int);
insert into t2 values('aa', 1), ('mysql', 2);


select t1.id1, clob_to_char(t1.col2), t2.id2, clob_to_char(t2.col1) from t1 left outer join t2 on clob_to_char(t2.col1)=clob_to_char(t1.col2) order by 1, 2, 3, 4;
update t1 m1 left outer join t2 on clob_to_char(t2.col1)=clob_to_char(m1.col2) set t2.col1=char_to_clob('updated2'), t2.id2=m1.id1;

select if(clob_to_char(col1)='updated2', 'ok', 'nok') from t2 where id2=2 order by 1;


select t1.id1, clob_to_char(t1.col2), t2.id2, clob_to_char(t2.col1) from t1 right join t2 on t1.id1=t2.id2 order by 1, 2, 3, 4;
update t1 right outer join t2 on t2.id2=t1.id1 set t1.col2=char_to_clob(t2.col1), t2.id2=t1.id1+10;
select id1, clob_to_char(col2) from t1 order by 1;
select id2, clob_to_char(col1) from t2 order by 1;

delete t1, t2 from t1, t2;



drop table t1, t2;
