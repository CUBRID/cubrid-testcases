/**
 *  This test case verifies CBRD-27583: a query that reads several classes in one spec, as in
 *  FROM (a, b, c), rejects an attribute whose domain differs between the classes.
 *
 *  Before the change the attribute took the last class's type at compile time and each row
 *  converted the value of its own class, so the answer depended on the class order, and a
 *  string next to a JSON attribute either returned rows or failed with an invalid json error.
 *  Now any difference of the domain, the type, its precision or its collation, is a compile
 *  error (specification change 23), as SELECT star already leaves such an attribute out.
 *  A subclass that narrows an object attribute to its own class keeps the same domain.
 *
 *  Judged by the literal results: the error blocks of Cases 1 to 3, the rows of Cases 4 and 5.
 *
 *  Coverage:
 *    Case 1:  a string attribute next to a JSON one, in both class orders
 *    Case 2:  string attributes of different precisions
 *    Case 3:  string attributes of different collations
 *    Case 4:  attributes of the same domain read as before
 *    Case 5:  an inherited object attribute narrowed by the subclass read through ALL
 */

drop table if exists t_one, t_two, t_json, t_short, t_coll;
drop class if exists c_child;
drop class if exists c_parent;

-- one row per class so that each class order would answer differently before the change
create table t_one (a varchar(100), b int);
create table t_two (a varchar(100), b int);
create table t_json (a json, b int);
create table t_short (a varchar(10), b int);
create table t_coll (a varchar(100) collate utf8_en_ci, b int);
insert into t_one values ('one', 1);
insert into t_two values ('two', 2);
insert into t_json values ('{"k": 3}', 3);
insert into t_short values ('short', 4);
insert into t_coll values ('coll', 5);
-- a parent whose attribute f refers to the parent class, a child that narrows f to itself
create class c_parent (f c_parent, k int) dont_reuse_oid;
create class c_child under c_parent (f c_child, g int) dont_reuse_oid;
insert into c_child (k, g) values (2, 7);
insert into c_parent (f, k) select x, 1 from c_child x;


evaluate 'Case 1: a string attribute next to a JSON one, in both class orders';
select a from (t_one, t_two, t_json) order by 1;
select a from (t_json, t_one, t_two) order by 1;


evaluate 'Case 2: string attributes of different precisions';
select a from (t_one, t_short) order by 1;


evaluate 'Case 3: string attributes of different collations';
select a from (t_one, t_coll) order by 1;


evaluate 'Case 4: attributes of the same domain read as before';
select a, b from (t_one, t_two) order by 1, 2;
select b from (t_one, t_json, t_short, t_coll) order by 1;


evaluate 'Case 5: an inherited object attribute narrowed by the subclass read through ALL';
select x.k, x.f.k from all c_parent x order by 1;
select x.k, x.f.g from all c_parent x order by 1;
select x.k from all c_parent x where x.f.k = 2 order by 1;

drop class c_child;
drop class c_parent;
drop table t_one, t_two, t_json, t_short, t_coll;
