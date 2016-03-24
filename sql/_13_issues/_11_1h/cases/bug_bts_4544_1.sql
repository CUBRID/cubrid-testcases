CREATE TABLE t1 (
   a  INT NOT NULL,
   b  VARCHAR(40) NOT NULL,
   c  CHAR(3)
  );
CREATE INDEX "idx_t1_ac" ON t1(a,c);

insert into t1 values (1, 'Adalius', '086');
insert into t1 values (2, 'Agassi', '086');
insert into t1 values (3, 'Ahman', '086');
insert into t1 values (4, 'Alcott', '086');
insert into t1 values (5, 'Ali', '086');
insert into t1 values (6, 'Bdalius', '011');
insert into t1 values (7, 'Bgassi', '011');
insert into t1 values (8, 'Bhman', '011');
insert into t1 values (9, 'Blcott', '011');
insert into t1 values (10, 'Bli', '011');

-- keep the lower limit to 2, max count should get no more than 4
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num()<1;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num()<2;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num()<3;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num()<4;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num()<5;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num()<6;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num()<7;

select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 1 and 2;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 1 and 3;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 1 and 4;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 1 and 5;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 1 and 6;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 1 and 7;

select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 2 and 2;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 2 and 3;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 2 and 4;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 2 and 5;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 2 and 6;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 2 and 7;

select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 3 and 4;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 3 and 5;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 3 and 6;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 3 and 7;

select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 4 and 5;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 4 and 6;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 4 and 7;


select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 5 and 5;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 5 and 6;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 5 and 7;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 5 and 8;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 5 and 9;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 5 and 10;


select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc limit 1;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc limit 0,1;

select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num()<3;
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,4 order by a asc for orderby_num() between 1 and 2;


-- should ignore the greater (5) limit: 
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,3 order by a asc limit 5;
-- should only keep the smaller cnt (2) specified in limit:
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 2,3 order by a asc limit 2;

-- should keep the higher offset (5) specified in limit:
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 3,2 order by a asc limit 5,2;

-- should keep the higher offset (3) specified in keylimit:
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 3,2 order by a asc limit 1,2;

-- should keep the higher offset (5) specified in limit and the lower cnt (2, from keylimit):
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 3,2 order by a asc limit 5,10;

-- should keep the higher offset (5) specified in limit and the lower cnt (2, from limit):
select a,c from t1 where a>0 using index idx_t1_ac(+) keylimit 3,99 order by a asc limit 5,2;


--  known issue, should output {7,8,9,10}
-- (keylimit clause produces {3,4,5,6,7,...}  and rownum>4 skips the first 4)
select a,c from t1 where a>0 and rownum > 4 using index idx_t1_ac(+) keylimit 3,10;




drop table t1;

