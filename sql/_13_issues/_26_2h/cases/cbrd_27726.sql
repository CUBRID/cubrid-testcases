/**
 *  This test case verifies CBRD-27726: UPDATE and DELETE with an IN subquery that has an 'attr = const' term
 *  use the constant of each statement when they differ only in the constant.
 *
 *  qo_reduce_equality_terms () keeps a copy of the reduced constant in the constant_value of the select list
 *  column of the subquery, and auto-parameterization turned only the constant of the term into a host variable.
 *  UPDATE and DELETE build the XASL cache key from the auto-parameterized statement and rewrite the SELECT
 *  built for them again, where the IN subquery becomes a derived table and the literal copy is pulled up
 *  into the outer query. The literal was baked into an XASL whose cache key has no literal,
 *  so every later statement of the same shape reused the first constant.
 *
 *  The fix replaces the literal constant_value with the host variable of the term,
 *  which is in WHERE, or in HAVING when WITH ROLLUP keeps it there.
 *
 *  Each case runs the same statement with the constants 1, 2 and 3 without RECOMPILE,
 *  so the second and the third statements hit the XASL cache.
 *  Without the fix, they change the row of the first constant again and leave their own rows untouched.
 *
 *  Coverage:
 *    Case 1:  UPDATE, 'attr = const' in WHERE of the subquery (the reported query)
 *    Case 2:  DELETE, 'attr = const' in WHERE of the subquery
 *    Case 3:  UPDATE, an index on the subquery column ('attr range (const =)' term)
 *    Case 4:  UPDATE, 'attr = const' in HAVING of the subquery with GROUP BY ... WITH ROLLUP
 *    Case 5:  DELETE, 'attr = const' in HAVING of the subquery with GROUP BY ... WITH ROLLUP
 *    Case 6:  PREPARE with user host variables after a statement of the same text with literals
 *    Case 7:  MERGE ... USING a subquery with 'attr = const'
 *    Case 8:  UPDATE, 'const = attr' in WHERE of the subquery (the operands are swapped before the lookup)
 *             on its own table, because it would otherwise get the XASL cache key of Case 1
 *    Case 9:  UPDATE, '= ANY' subquery instead of IN
 *    Case 10: UPDATE, 'attr = const' in a derived table nested in the IN subquery
 */

drop table if exists xt, xids, xids_idx, xids_rev;

create table xt (id int primary key, s varchar (20));
create table xids (id int);
insert into xids values (1), (2), (3), (4);
create table xids_idx (id int);
insert into xids_idx values (1), (2), (3), (4);
create index i_xids_idx_id on xids_idx (id);
create table xids_rev (id int);
insert into xids_rev values (1), (2), (3), (4);


evaluate 'Case 1: UPDATE, WHERE of the subquery; expected 1 one / 2 two / 3 three / 4 base';
delete from xt;
insert into xt values (1, 'base'), (2, 'base'), (3, 'base'), (4, 'base');
update xt set s = 'one' where id in (select id from xids where id = 1);
update xt set s = 'two' where id in (select id from xids where id = 2);
update xt set s = 'three' where id in (select id from xids where id = 3);
select * from xt order by 1;


evaluate 'Case 2: DELETE, WHERE of the subquery; expected 4 base';
delete from xt;
insert into xt values (1, 'base'), (2, 'base'), (3, 'base'), (4, 'base');
delete from xt where id in (select id from xids where id = 1);
delete from xt where id in (select id from xids where id = 2);
delete from xt where id in (select id from xids where id = 3);
select * from xt order by 1;


evaluate 'Case 3: UPDATE, index on the subquery column; expected 1 one / 2 two / 3 three / 4 base';
delete from xt;
insert into xt values (1, 'base'), (2, 'base'), (3, 'base'), (4, 'base');
update xt set s = 'one' where id in (select id from xids_idx where id = 1);
update xt set s = 'two' where id in (select id from xids_idx where id = 2);
update xt set s = 'three' where id in (select id from xids_idx where id = 3);
select * from xt order by 1;


evaluate 'Case 4: UPDATE, HAVING of the subquery with ROLLUP; expected 1 one / 2 two / 3 three / 4 base';
delete from xt;
insert into xt values (1, 'base'), (2, 'base'), (3, 'base'), (4, 'base');
update xt set s = 'one' where id in (select id from xids group by id with rollup having id = 1);
update xt set s = 'two' where id in (select id from xids group by id with rollup having id = 2);
update xt set s = 'three' where id in (select id from xids group by id with rollup having id = 3);
select * from xt order by 1;


evaluate 'Case 5: DELETE, HAVING of the subquery with ROLLUP; expected 4 base';
delete from xt;
insert into xt values (1, 'base'), (2, 'base'), (3, 'base'), (4, 'base');
delete from xt where id in (select id from xids group by id with rollup having id = 1);
delete from xt where id in (select id from xids group by id with rollup having id = 2);
delete from xt where id in (select id from xids group by id with rollup having id = 3);
select * from xt order by 1;


evaluate 'Case 6: PREPARE after a literal statement of the same text; expected 1 one / 2 two / 3 base / 4 base';
delete from xt;
insert into xt values (1, 'base'), (2, 'base'), (3, 'base'), (4, 'base');
update xt set s = 'one' where id in (select id from xids where id = 1);
prepare st from 'update xt set s = ? where id in (select id from xids where id = ?)';
execute st using 'two', 2;
deallocate prepare st;
select * from xt order by 1;


evaluate 'Case 7: MERGE USING a subquery; expected 1 one / 2 two / 3 three / 4 base';
delete from xt;
insert into xt values (1, 'base'), (2, 'base'), (3, 'base'), (4, 'base');
merge into xt using (select id from xids where id = 1) u on (xt.id = u.id) when matched then update set s = 'one';
merge into xt using (select id from xids where id = 2) u on (xt.id = u.id) when matched then update set s = 'two';
merge into xt using (select id from xids where id = 3) u on (xt.id = u.id) when matched then update set s = 'three';
select * from xt order by 1;


evaluate 'Case 8: UPDATE, const = attr in WHERE of the subquery; expected 1 one / 2 two / 3 three / 4 base';
delete from xt;
insert into xt values (1, 'base'), (2, 'base'), (3, 'base'), (4, 'base');
update xt set s = 'one' where id in (select id from xids_rev where 1 = id);
update xt set s = 'two' where id in (select id from xids_rev where 2 = id);
update xt set s = 'three' where id in (select id from xids_rev where 3 = id);
select * from xt order by 1;


evaluate 'Case 9: UPDATE, = ANY subquery; expected 1 one / 2 two / 3 three / 4 base';
delete from xt;
insert into xt values (1, 'base'), (2, 'base'), (3, 'base'), (4, 'base');
update xt set s = 'one' where id = any (select id from xids where id = 1);
update xt set s = 'two' where id = any (select id from xids where id = 2);
update xt set s = 'three' where id = any (select id from xids where id = 3);
select * from xt order by 1;


evaluate 'Case 10: UPDATE, derived table nested in the subquery; expected 1 one / 2 two / 3 three / 4 base';
delete from xt;
insert into xt values (1, 'base'), (2, 'base'), (3, 'base'), (4, 'base');
update xt set s = 'one' where id in (select id from (select id from xids where id = 1) d);
update xt set s = 'two' where id in (select id from (select id from xids where id = 2) d);
update xt set s = 'three' where id in (select id from (select id from xids where id = 3) d);
select * from xt order by 1;


drop table xt, xids, xids_idx, xids_rev;
