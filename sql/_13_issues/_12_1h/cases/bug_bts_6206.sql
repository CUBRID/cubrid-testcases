select concat_ws('-', 'a1');
select concat_ws('-', 'a2', 'b2');
select concat_ws(NULL, 'a3', 'b3');
select concat_ws('-', NULL);
select concat_ws(1, 'a4','b4');
select concat_ws('-', date '2012-05-24');
CREATE TABLE t1 (name VARCHAR(20));
insert into t1 values (concat_ws('-', 'a1'));
insert into t1 values (concat_ws('-', 'a2', 'b2'));
insert into t1 values (concat_ws(NULL, 'a3', 'b3'));
insert into t1 values (concat_ws('-', NULL));
insert into t1 values (concat_ws(1, 'a4','b4'));
insert into t1 values (concat_ws('-', date '2012-05-24'));

select * from t1 order by 1;

drop table t1;
create table del (d char(1));
insert into del values ('-');
evaluate concat_ws((select '-'), 'a', 'b');
evaluate concat_ws((select max(d) from del), (select 'a'), date '2012-05-24');
drop table del;



