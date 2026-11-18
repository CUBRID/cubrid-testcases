/**
 *  This test case verifies CBRD-28027: an OR of conditions that hold an AND inside IS TRUE, IS NOT FALSE, CASE or IF
 *  keeps every branch, even when the branches share the first conjunct of that AND
 *
 *  The CNF conversion of a search condition walked under its atoms - IS [NOT] TRUE/FALSE, CASE, IF, a comparison -
 *  and turned an AND among their operands into a CNF list. Such an operand printed as its first conjunct only, and the
 *  common factor search of an OR compares printed forms: ((a > 0 and a = 1) is true) or ((a > 0 and a = 2) is true)
 *  took the two branches for one and lost the rows of the other. The conversion now goes into AND and OR only.
 *
 *  Coverage:
 *    Case 1: IS TRUE, IS NOT FALSE, a CASE WHEN condition and an IF condition whose AND share the first conjunct, and
 *            the IS TRUE form with another conjunct in each branch (the reported forms)
 *    Case 2: forms that were right - the first conjunct differs, an OR inside, a plain AND, the same expression in the
 *            SELECT list
 *    Case 3: the same OR in HAVING, in the ON of a LEFT OUTER JOIN, in START WITH, and in the WHERE of a DELETE
 *    Case 4: an AND of three conjuncts, and a real common factor outside the atoms, which is still taken out
 *    Case 5: a guard inside an atom keeps guarding - (a = 1 and 10 / b > 1) or (a = 3 and b = 0) under IS TRUE in
 *            HAVING and START WITH, which were distributed so that 10 / b ran on b = 0 (division by zero) - and the
 *            OR of atoms in XOR and in the WHERE of a MERGE
 */

drop table if exists t_28027, u_28027, d_28027, m_28027;

create table t_28027 (a int, b int);
insert into t_28027 values (1, 1), (2, 1), (3, 0);
create table u_28027 (a int);
insert into u_28027 values (1), (2);
create table d_28027 (a int);
insert into d_28027 values (1), (2), (3);
create table m_28027 (a int);
insert into m_28027 values (1), (2);

select 'Case 1: the reported forms; result = 2, 2, 2, 2, 2' as c from db_root;
select count (*) as is_true from t_28027 where ((a > 0 and a = 1) is true) or ((a > 0 and a = 2) is true);
select count (*) as is_not_false from t_28027 where ((a > 0 and a = 1) is not false) or ((a > 0 and a = 2) is not false);
select count (*) as case_when from t_28027
  where (case when a > 0 and a = 1 then 1 else 0 end) = 1 or (case when a > 0 and a = 2 then 1 else 0 end) = 1;
select count (*) as if_cond from t_28027 where if (a > 0 and a = 1, 1, 0) = 1 or if (a > 0 and a = 2, 1, 0) = 1;
select count (*) as with_conjunct from t_28027
  where (a = 1 and ((a > 0 and a = 1) is true)) or (a = 2 and ((a > 0 and a = 2) is true));

select 'Case 2: forms that were right; result = 2, 2, 2, 2' as c from db_root;
select count (*) as first_differs from t_28027 where ((a = 1 and a > 0) is true) or ((a = 2 and a > 0) is true);
select count (*) as or_inside from t_28027 where ((a > 5 or a = 1) is true) or ((a > 5 or a = 2) is true);
select count (*) as plain_and from t_28027 where (a > 0 and a = 1) or (a > 0 and a = 2);
select sum (case when ((a > 0 and a = 1) is true) or ((a > 0 and a = 2) is true) then 1 else 0 end) as select_list
  from t_28027;

select 'Case 3: other clauses; HAVING 1, 2 / ON (1, 1), (2, 2) / START WITH 1, 2 / DELETE leaves 3' as c from db_root;
select a from t_28027 group by a having ((a > 0 and a = 1) is true) or ((a > 0 and a = 2) is true) order by 1;
select u.a, t.a from u_28027 u left outer join t_28027 t
  on u.a = t.a and (((t.a > 0 and t.a = 1) is true) or ((t.a > 0 and t.a = 2) is true)) order by 1;
select a from t_28027 start with ((a > 0 and a = 1) is true) or ((a > 0 and a = 2) is true)
  connect by prior a = a - 10 order by 1;
delete from d_28027 where ((a > 0 and a = 1) is true) or ((a > 0 and a = 2) is true);
select a from d_28027 order by 1;

select 'Case 4: three conjuncts, and a common factor outside the atoms; result = 2, 2' as c from db_root;
select count (*) as three_conjuncts from t_28027
  where ((a > 0 and a < 9 and a = 1) is true) or ((a > 0 and a < 9 and a = 2) is true);
select count (*) as common_outside from t_28027
  where (((a > 0 and a = 1) is true) and b = 1) or (((a > 0 and a = 2) is true) and b = 1);

select 'Case 5: a guard inside an atom, XOR, MERGE; HAVING (1, 1), (3, 0) / START WITH 1, 3 / XOR 2 / MERGE 11, 12' as c from db_root;
select a, b from t_28027 group by a, b
  having (((a = 1 and 10 / b > 1) or (a = 3 and b = 0)) is true) order by 1;
select a from t_28027
  start with (((a = 1 and 10 / b > 1) or (a = 3 and b = 0)) is true) connect by prior a = a - 10 order by 1;
select count (*) as xor_atom from t_28027
  where ((a > 0 and a = 1) xor false) or ((a > 0 and a = 2) xor false);
merge into m_28027 m using t_28027 t on (m.a = t.a)
  when matched then update set m.a = m.a + 10
  where ((t.a > 0 and t.a = 1) is true) or ((t.a > 0 and t.a = 2) is true);
select a from m_28027 order by 1;

drop table t_28027, u_28027, d_28027, m_28027;
