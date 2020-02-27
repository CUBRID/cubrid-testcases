autocommit off;
set system parameters 'dont_reuse_heap_file=yes';
drop table if exists x;
create table x (a int primary key, b int);
insert into x values (1, 1);
insert into x values (2, 1);
insert into x values (3, 1);
insert into x values (4, 1);
insert into x values (5, 1);
insert into x values (6, 1);
insert into x values (7, 1);
insert into x values (8, 1);
insert into x values (9, 1);
insert into x values (10, 1);

drop table if exists y;
create table y (a int primary key, b int);
insert into y values (1, 1);
insert into y values (2, 1);
insert into y values (3, 1);
insert into y values (4, 1);
insert into y values (5, 1);
insert into y values (6, 1);
insert into y values (7, 1);
insert into y values (8, 1);
insert into y values (11, 1);

select /*+ recompile */ * from x where a > 5 order by a desc;
select /*+ recompile NO_DESC_IDX */ * from x where a > 5 order by a desc;
select /*+ recompile */ * from x, y where x.a = y.a and x.a > 5 order by x.a desc;
select /*+ recompile NO_DESC_IDX */ * from x, y where x.a = y.a and x.a > 5 order by x.a desc;

select /*+ recompile no_desc_idx */ x.* from x, (select /*+ recompile desc_idx */ * from x where a<3 order by a desc) y where x.a > 5 order by x.a desc;

select /*+ recompile NO_DESC_IDX  */ * from x force index (pk_x_a) where a > 5 order by a desc;

select /*+ recompile NO_DESC_IDX DESC_IDX */ * from x where a>0 using index pk_x_a keylimit 0,5 order by a asc for orderby_num() between 1 and 3;
select /*+ recompile DESC_IDX NO_DESC_IDX */ * from x where a>0 using index pk_x_a keylimit 0,5 order by a asc for orderby_num() between 1 and 3;

select /*+ recompile NO_DESC_IDX DESC_IDX */ * from x where a>0 using index pk_x_a keylimit 0,5 order by a desc for orderby_num() between 1 and 3;
select /*+ recompile DESC_IDX NO_DESC_IDX */ * from x where a>0 using index pk_x_a keylimit 0,5 order by a desc for orderby_num() between 1 and 3;


select /*+ recompile DESC_IDX */ * from (select /*+ recompile DESC_IDX NO_DESC_IDX */ * from x where a>0 using index pk_x_a keylimit 0,5 order by a asc for orderby_num() between 1 and 3) t, y where y.a>0 order by y.a desc;
select /*+ recompile DESC_IDX */ * from y where y.a>0 order by y.a desc;


select /*+ recompile DESC_IDX */ * from (
(select /*+ recompile DESC_IDX */ * from y where y.a>1 order by y.a desc)
union all 
(select /*+ recompile NO_DESC_IDX */ * from x where a>0 using index pk_x_a keylimit 0,5 order by a asc for orderby_num() between 1 and 3)) t;

select /*+ recompile DESC_IDX */ ((select /*+ recompile NO_DESC_IDX */ a,b from y where y.a>1 order by y.a desc limit 1) = (select /*+ recompile NO_DESC_IDX */ a,b from y where y.a>1 order by y.a desc limit 1)) as co from db_root limit 1;

select /*+ recompile ordered NO_DESC_IDX */ * from x left join y  on x.a=y.a where y.a>1 order by y.a desc;

select /*+ recompile ordered NO_DESC_IDX USE_MERGE */ * from x right join y  on x.a=y.a where y.a>1 order by y.a desc;


--test: view
create view v1 as select /*+ recompile NO_DESC_IDX */ * from x where a > 5 order by a desc;
select /*+ recompile */ * from v1;
select /*+ recompile DESC_IDX */ * from v1;
drop view v1;

drop table x;
drop table y;


--test: partition
CREATE TABLE athlete2( name VARCHAR(40), event VARCHAR(30) )
   PARTITION BY LIST (event) (
   PARTITION event1 VALUES IN ('Swimming', 'Athletics' ),
   PARTITION event2 VALUES IN ('Judo', 'Taekwondo','Boxing'),
   PARTITION event3 VALUES IN ('Football', 'Basketball', 'Baseball')
);
INSERT INTO athlete2 VALUES ('Hwang Young-Cho', 'Athletics');
INSERT INTO athlete2 VALUES ('Lee Seung-Yuop', 'Baseball');
INSERT INTO athlete2 VALUES ('Moon Dae-Sung','Taekwondo');
INSERT INTO athlete2 VALUES ('Cho In-Chul', 'Judo');

create index i_athlete2_name on athlete2(name);

select /*+ recompile */ * from athlete2 where name > 'H' order by name desc;
select /*+ recompile DESC_IDX */ * from athlete2 where name > 'H' order by name desc;
select /*+ recompile NO_DESC_IDX */ * from athlete2 where name > 'H' order by name desc;
select /*+ recompile NO_DESC_IDX */ * from athlete2 where name > 'H' using index i_athlete2_name keylimit 0,1 order by name desc;
select /*+ recompile NO_DESC_IDX */ * from athlete2 where name > 'H' using index i_athlete2_name keylimit 0,1 order by name asc;

drop table athlete2;


--test: prefix index
create table t3 (a varchar(10));
insert into t3 values ('111'), ('2222'),('2223'), ('3');
create index i_t3_a on t3(a(3));

select /*+ recompile no_desc_idx */ * from t3 where a>'a' order by a desc;
select /*+ recompile */ * from t3 where a>'2' order by a desc;
drop table t3;

set system parameters 'dont_reuse_heap_file=no';
commit;
autocommit on;

