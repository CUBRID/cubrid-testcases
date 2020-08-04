drop table if exists tmp1;

CREATE TABLE tmp1(col1 INT, col2 INT, col3 int);
CREATE INDEX idx ON tmp1(col1,col2);

select 1
  from tmp1
 where col3 = 1
   and col3 <> 2
   and col2 in (?,?)
   and col1 in ('1','2');

select 1
  from tmp1
 where col2 in (?,?)
   and col1 in ('1','2')
   and col3 = 1
   and col3 <> 2;

drop table tmp1;
