--TEST: [Merge Statement] The tuples that are not updated by the update_clause can be deleted by the delete_clause when the update_clause is with where conditions.


drop table if exists t1, t2;

create table t1(a int, c clob);
insert into t1 values(1, char_to_clob ('aaa'));
insert into t1 values(2, char_to_clob ('bbb'));
insert into t1 values(3, char_to_clob ('ccc'));

create table t2(a int, c clob);
insert into t2 values(1, char_to_clob ('AAA'));
insert into t2 values(2, char_to_clob ('BBB'));
insert into t2 values(4, char_to_clob ('DDD'));


merge into t1 using t2 on (t1.a = t2.a)
when matched then 
update set t1.c = char_to_clob (clob_to_char (t2.c)) where t1.a > 1
delete where clob_to_char (t1.c)='bbb';

select a, clob_to_char (c) from t1 order by 1;

drop table t1, t2;


create table t1(a int, c clob);
insert into t1 values(1, char_to_clob ('aaa'));
insert into t1 values(2, char_to_clob ('bbb'));
insert into t1 values(3, char_to_clob ('ccc'));

create table t2(a int, c clob);
insert into t2 values(1, char_to_clob ('AAA'));
insert into t2 values(2, char_to_clob ('BBB'));
insert into t2 values(4, char_to_clob ('DDD'));


merge into t1 using t2 on (t1.a = t2.a)
when matched then 
update set t1.c = char_to_clob (clob_to_char (t2.c)) where t1.a > 3
delete where clob_to_char (t1.c)='bbb';

select a, clob_to_char (c) from t1 order by 1;

drop table t1, t2;


create table t1(a int, c clob);
insert into t1 values(1, char_to_clob ('aaa'));
insert into t1 values(2, char_to_clob ('bbb'));
insert into t1 values(3, char_to_clob ('ccc'));

create table t2(a int, c clob);
insert into t2 values(1, char_to_clob ('AAA'));
insert into t2 values(2, char_to_clob ('BBB'));
insert into t2 values(4, char_to_clob ('DDD'));

create trigger trg before update on t1 execute insert into t2 values (NULL, NULL);

merge into t1 using t2 on (t1.a = t2.a)
when matched then 
update set t1.c = char_to_clob (left(clob_to_char (t2.c),1)) where t1.a > 1
delete where left(clob_to_char (t1.c), 1) = 'B';

select a, clob_to_char (c) from t1 order by 1;

drop table t1, t2;


create table t1(a int, c clob);
insert into t1 values(1, char_to_clob ('aaa'));
insert into t1 values(2, char_to_clob ('bbb'));
insert into t1 values(3, char_to_clob ('ccc'));

create table t2(a int, c clob);
insert into t2 values(1, char_to_clob ('AAA'));
insert into t2 values(2, char_to_clob ('BBB'));
insert into t2 values(4, char_to_clob ('DDD'));


merge into t1 using t2 on (t1.a = t2.a)
when matched then 
update set t1.c = char_to_clob (left(clob_to_char (t2.c),1)) where t1.a > 1
delete where left(clob_to_char (t1.c), 1) > 'B';

select a, clob_to_char (c) from t1 order by 1;

drop table t1, t2;


create table t1(a int, c clob);
insert into t1 values(1, char_to_clob ('aaa'));
insert into t1 values(2, char_to_clob ('bbb'));
insert into t1 values(3, char_to_clob ('ccc'));

create table t2(a int, c clob);
insert into t2 values(1, char_to_clob ('AAA'));
insert into t2 values(2, char_to_clob ('BBB'));
insert into t2 values(4, char_to_clob ('DDD'));

create trigger trg before update on t1 execute insert into t2 values (NULL, NULL);

merge into t1 using t2 on (t1.a = t2.a)
when matched then 
update set t1.c = char_to_clob (right(clob_to_char (t2.c),1)) where t1.a > 1
delete where right(clob_to_char (t1.c), 1) > 'B';

select a, clob_to_char (c) from t1 order by 1;
select if(count(*)=4, 'ok', 'nok') from t2;

drop table t1, t2;
