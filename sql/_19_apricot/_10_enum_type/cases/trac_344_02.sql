--
--+ holdcas on;

create table t1(i int, e1 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', '01/01/2012'));
insert into t1 values (1, 1), (3, 3), (2, 'Monday'), (6, 'Friday'), (7, 7), (4, 4), (5, 5), (8, 8);
create index idx1 on t1(e1);
update statistics on t1;

select /*+ recompile */ e1 from t1 where e1 <> 50  order by i;
select /*+ recompile */ e1 from t1 where e1 > 50  order by i;
select /*+ recompile */ e1 from t1 where e1 < 50  order by i;
select /*+ recompile */ e1 from t1 where e1 >= 50  order by i;
select /*+ recompile */ e1 from t1 where e1 <= 50  order by i;
select /*+ recompile */ e1 from t1 where e1 <> 2  order by i;
select /*+ recompile */ e1 from t1 where e1 > 2  order by i;
select /*+ recompile */ e1 from t1 where e1 < 2  order by i;
select /*+ recompile */ e1 from t1 where e1 >= 2  order by i;
select /*+ recompile */ e1 from t1 where e1 <= 2  order by i;
select /*+ recompile */ e1 from t1 where 50 <> e1  order by i;
select /*+ recompile */ e1 from t1 where 2 <> e1  order by i;
select /*+ recompile */ e1 from t1 where e1 > 'S'  order by i;
select /*+ recompile */ e1 from t1 where e1 < 'S'  order by i;
select /*+ recompile */ e1 from t1 where e1 >= 'S'  order by i;
select /*+ recompile */ e1 from t1 where e1 <= 'S'  order by i;
select /*+ recompile */ e1 from t1 where e1 > 'Tuesday'  order by i;
select /*+ recompile */ e1 from t1 where e1 < 'Tuesday'  order by i;
select /*+ recompile */ e1 from t1 where e1 >= 'Tuesday'  order by i;
select /*+ recompile */ e1 from t1 where e1 <= 'Tuesday'  order by i;
select /*+ recompile */ e1 from t1 where e1 < any {5, 1, -1}  order by i;
select /*+ recompile */ e1 from t1 where e1 > any {5, 1, -1}  order by i;
select /*+ recompile */ e1 from t1 where e1 <= any {5, 1, -1}  order by i;
select /*+ recompile */ e1 from t1 where e1 >= any {5, 1, -1}  order by i;
select /*+ recompile */ e1 from t1 where e1 < all {9, 5, 1}  order by i;
select /*+ recompile */ e1 from t1 where e1 > all {9, 5, 1}  order by i;
select /*+ recompile */ e1 from t1 where e1 <= all {9, 5, 1}  order by i;
select /*+ recompile */ e1 from t1 where e1 >= all {9, 5, 1}  order by i;
select /*+ recompile */ e1 from t1 where e1 < any {'M', 'Thursday', 'Sunday', 'J'}  order by i;
select /*+ recompile */ e1 from t1 where e1 > any {'M', 'Thursday', 'Sunday', 'J'}  order by i;
select /*+ recompile */ e1 from t1 where e1 <= any {'M', 'Thursday', 'Sunday', 'J'}  order by i;
select /*+ recompile */ e1 from t1 where e1 >= any {'M', 'Thursday', 'Sunday', 'J'}  order by i;
select /*+ recompile */ e1 from t1 where e1 < all {'M', 'Thursday', 'Sunday', 'J'}  order by i;
select /*+ recompile */ e1 from t1 where e1 > all {'M', 'Thursday', 'Sunday', 'J'}  order by i;
select /*+ recompile */ e1 from t1 where e1 <= all {'M', 'Thursday', 'Sunday', 'J'}  order by i;
select /*+ recompile */ e1 from t1 where e1 >= all {'M', 'Thursday', 'Sunday', 'J'}  order by i;

prepare x from 'select /*+ recompile */ * from t1 where e1 <> ?  order by i';
execute x using 50;
execute x using 3;
execute x using 'M';
execute x using 'Wednesday';
execute x using date'01/01/2012';
drop prepare x;

prepare x from 'select /*+ recompile */ * from t1 where ? <> e1  order by i';
execute x using 50;
execute x using 3;
execute x using 'M';
execute x using 'Wednesday';
execute x using date'01/01/2012';
drop prepare x;

prepare x from 'select /*+ recompile */ * from t1 where e1 < ?  order by i';
execute x using 50;
execute x using 3;
execute x using 'M';
execute x using 'Wednesday';
execute x using date'01/01/2012';
drop prepare x;

prepare x from 'select /*+ recompile */ * from t1 where ? < e1  order by i';
execute x using 50;
execute x using 3;
execute x using 'M';
execute x using 'Wednesday';
execute x using date'01/01/2012';
drop prepare x;

prepare x from 'select /*+ recompile */ * from t1 where e1 <= ?  order by i';
execute x using 50;
execute x using 3;
execute x using 'M';
execute x using 'Wednesday';
execute x using date'01/01/2012';
drop prepare x;

prepare x from 'select /*+ recompile */ * from t1 where ? <= e1  order by i';
execute x using 50;
execute x using 3;
execute x using 'M';
execute x using 'Wednesday';
execute x using date'01/01/2012';
drop prepare x;

prepare x from 'select /*+ recompile */ * from t1 where e1 >= ?  order by i';
execute x using 50;
execute x using 3;
execute x using 'M';
execute x using 'Wednesday';
execute x using date'01/01/2012';
drop prepare x;

prepare x from 'select /*+ recompile */ * from t1 where ? >= e1  order by i';
execute x using 50;
execute x using 3;
execute x using 'M';
execute x using 'Wednesday';
execute x using date'01/01/2012';
drop prepare x;

prepare x from 'select /*+ recompile */ * from t1 where e1 > ?  order by i';
execute x using 50;
execute x using 3;
execute x using 'M';
execute x using 'Wednesday';
execute x using date'01/01/2012';
drop prepare x;

prepare x from 'select /*+ recompile */ * from t1 where ? > e1  order by i';
execute x using 50;
execute x using 3;
execute x using 'M';
execute x using 'Wednesday';
execute x using date'01/01/2012';
drop prepare x;

prepare x from 'select /*+ recompile */ * from t1 where e1 < all {''T'', ?, ''Sunday'', ?}  order by i';
execute x using 50, 3;
execute x using 'M', 'Wednesday';
execute x using 'M', date'01/01/2012';
drop prepare x;

prepare x from 'select /*+ recompile */ * from t1 where e1 <= all {''T'', ?, ''Sunday'', ?}  order by i';
execute x using 50, 3;
execute x using 'M', 'Wednesday';
execute x using 'M', date'01/01/2012';
drop prepare x;

prepare x from 'select /*+ recompile */ * from t1 where e1 > all {''T'', ?, ''Sunday'', ?}  order by i';
execute x using 50, 3;
execute x using 'M', 'Wednesday';
execute x using 'M', date'01/01/2012';
drop prepare x;

prepare x from 'select /*+ recompile */ * from t1 where e1 >= all {''T'', ?, ''Sunday'', ?}  order by i';
execute x using 50, 3;
execute x using 'M', 'Wednesday';
execute x using 'M', date'01/01/2012';
drop prepare x;

prepare x from 'select /*+ recompile */ * from t1 where e1 < any {''T'', ?, ''Sunday'', ?}  order by i';
execute x using 50, 3;
execute x using 'M', 'Wednesday';
execute x using 'M', date'01/01/2012';
drop prepare x;

prepare x from 'select /*+ recompile */ * from t1 where e1 <= any {''T'', ?, ''Sunday'', ?}  order by i';
execute x using 50, 3;
execute x using 'M', 'Wednesday';
execute x using 'M', date'01/01/2012';
drop prepare x;

prepare x from 'select /*+ recompile */ * from t1 where e1 > any {''T'', ?, ''Sunday'', ?}  order by i';
execute x using 50, 3;
execute x using 'M', 'Wednesday';
execute x using 'M', date'01/01/2012';
drop prepare x;

prepare x from 'select /*+ recompile */ * from t1 where e1 >= any {''T'', ?, ''Sunday'', ?}  order by i';
execute x using 50, 3;
execute x using 'M', 'Wednesday';
execute x using 'M', date'01/01/2012';
drop prepare x;

drop table t1;
commit;
--+ holdcas off;
