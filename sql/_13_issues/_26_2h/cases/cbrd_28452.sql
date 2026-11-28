/**
 *  This test case verifies CBRD-28452: a self join solved by a hash join binds the function-index expressions of both
 *  tables to one list column
 *
 *  A function-index expression in a condition is bound to the list column that carries its value, found by the printed
 *  form of the expression. The printed form qualifies a column by its table name, not by its alias, so in a self join
 *  the expressions of both tables printed the same and both were bound to one column. A condition such as
 *  abs(y.cb) > abs(x.cb) then compared a value with itself. The output list of GROUP BY is bound the same way, so
 *  Case 9 failed under any join method.
 *
 *  Each case runs one query as a hash join, with its plan, and the same query as a nested loop join. The two results
 *  must match.
 *
 *  Coverage:
 *    Case 1:  greater-than condition over both expressions, the query of the issue
 *    Case 2:  not-equal condition over both expressions
 *    Case 3:  arithmetic over both expressions
 *    Case 4:  another function, lower() over a string column
 *    Case 5:  EXISTS subquery solved by a hash join
 *    Case 6:  IN subquery solved by a hash join
 *    Case 7:  LEFT OUTER self join with the condition in the ON clause
 *    Case 8:  three-table self join, the second join compares with the second of two expressions in its outer input
 *    Case 9:  GROUP BY and HAVING over both expressions
 */

drop table if exists ta, tb;

-- ta has the data and the index of the issue, tb the same with a string column for lower(). cd < 100 reads 99 rows
-- through the index, which carries abs(cb) or lower(cb)
create table ta (ca int primary key, cb int, cc int, cd int);
insert into ta select rownum, mod(rownum, 11) - 5, mod(rownum * 13, 50), rownum from db_class a, db_class b limit 3000;
create index i_ta on ta (cd, abs(cb), cc);

create table tb (ca int primary key, cb varchar(10), cc int, cd int);
insert into tb select rownum, 'k' || mod(rownum, 7), mod(rownum * 13, 50), rownum from db_class a, db_class b limit 3000;
create index i_tb on tb (cd, lower(cb), cc);

evaluate 'Case 1: greater-than condition over both expressions, the query of the issue';

--@queryplan
select /*+ use_hash ordered */ x.ca, y.ca, abs(x.cb), abs(y.cb) from ta x, ta y where x.cc = y.cc and x.cd < 100 and y.cd < 100 and abs(y.cb) > abs(x.cb) order by 1, 2;
select /*+ use_nl ordered */ x.ca, y.ca, abs(x.cb), abs(y.cb) from ta x, ta y where x.cc = y.cc and x.cd < 100 and y.cd < 100 and abs(y.cb) > abs(x.cb) order by 1, 2;

evaluate 'Case 2: not-equal condition over both expressions';

--@queryplan
select /*+ use_hash ordered */ count(*), sum(x.ca * 1000 + y.ca) from ta x, ta y where x.cc = y.cc and x.cd < 100 and y.cd < 100 and abs(y.cb) <> abs(x.cb);
select /*+ use_nl ordered */ count(*), sum(x.ca * 1000 + y.ca) from ta x, ta y where x.cc = y.cc and x.cd < 100 and y.cd < 100 and abs(y.cb) <> abs(x.cb);

evaluate 'Case 3: arithmetic over both expressions';

--@queryplan
select /*+ use_hash ordered */ count(*), sum(x.ca * 1000 + y.ca) from ta x, ta y where x.cc = y.cc and x.cd < 100 and y.cd < 100 and abs(y.cb) + abs(x.cb) = 5;
select /*+ use_nl ordered */ count(*), sum(x.ca * 1000 + y.ca) from ta x, ta y where x.cc = y.cc and x.cd < 100 and y.cd < 100 and abs(y.cb) + abs(x.cb) = 5;

evaluate 'Case 4: another function, lower() over a string column';

--@queryplan
select /*+ use_hash ordered */ count(*), sum(x.ca * 1000 + y.ca) from tb x, tb y where x.cc = y.cc and x.cd < 100 and y.cd < 100 and lower(y.cb) < lower(x.cb);
select /*+ use_nl ordered */ count(*), sum(x.ca * 1000 + y.ca) from tb x, tb y where x.cc = y.cc and x.cd < 100 and y.cd < 100 and lower(y.cb) < lower(x.cb);

evaluate 'Case 5: EXISTS subquery solved by a hash join';

--@queryplan
select /*+ use_hash */ count(*), sum(x.ca) from ta x where x.cd < 100 and exists (select 1 from ta y where y.cc = x.cc and y.cd < 100 and abs(y.cb) > abs(x.cb));
select /*+ use_nl */ count(*), sum(x.ca) from ta x where x.cd < 100 and exists (select 1 from ta y where y.cc = x.cc and y.cd < 100 and abs(y.cb) > abs(x.cb));

evaluate 'Case 6: IN subquery solved by a hash join';

--@queryplan
select /*+ use_hash */ count(*), sum(x.ca) from ta x where x.cd < 100 and x.cc in (select y.cc from ta y where y.cd < 100 and abs(y.cb) > abs(x.cb));
select /*+ use_nl */ count(*), sum(x.ca) from ta x where x.cd < 100 and x.cc in (select y.cc from ta y where y.cd < 100 and abs(y.cb) > abs(x.cb));

evaluate 'Case 7: LEFT OUTER self join with the condition in the ON clause';

--@queryplan
select /*+ use_hash ordered */ count(*), count(y.ca), sum(y.ca) from ta x left outer join ta y on x.cc = y.cc and y.cd < 100 and abs(y.cb) > abs(x.cb) where x.cd < 100;
select /*+ use_nl ordered */ count(*), count(y.ca), sum(y.ca) from ta x left outer join ta y on x.cc = y.cc and y.cd < 100 and abs(y.cb) > abs(x.cb) where x.cd < 100;

evaluate 'Case 8: three-table self join, the second join compares with the second of two expressions in its outer input';

--@queryplan
select /*+ use_hash ordered */ count(*), sum(abs(x.cb) * 100 + abs(y.cb) * 10 + abs(z.cb)) from ta x, ta y, ta z where x.cc = y.cc and y.cc = z.cc and x.cd < 100 and y.cd < 100 and z.cd < 100 and abs(z.cb) > abs(y.cb);
select /*+ use_nl ordered */ count(*), sum(abs(x.cb) * 100 + abs(y.cb) * 10 + abs(z.cb)) from ta x, ta y, ta z where x.cc = y.cc and y.cc = z.cc and x.cd < 100 and y.cd < 100 and z.cd < 100 and abs(z.cb) > abs(y.cb);

evaluate 'Case 9: GROUP BY and HAVING over both expressions';

--@queryplan
select /*+ use_hash ordered */ abs(x.cb), abs(y.cb), count(*) from ta x, ta y where x.cc = y.cc and x.cd < 100 and y.cd < 100 group by abs(x.cb), abs(y.cb) having abs(y.cb) > abs(x.cb) order by 1, 2;
select /*+ use_nl ordered */ abs(x.cb), abs(y.cb), count(*) from ta x, ta y where x.cc = y.cc and x.cd < 100 and y.cd < 100 group by abs(x.cb), abs(y.cb) having abs(y.cb) > abs(x.cb) order by 1, 2;

drop table ta, tb;
