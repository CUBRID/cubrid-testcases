--+ holdcas on;
CREATE TABLE tree(ID INT, MgrID INT, Name VARCHAR(32), BirthYear INT);
 
INSERT INTO tree VALUES (1,NULL,'Kim', 1963);
INSERT INTO tree VALUES (2,NULL,'Moy', 1958);
INSERT INTO tree VALUES (3,1,'Jonas', 1976);
INSERT INTO tree VALUES (4,1,'Smith', 1974);
INSERT INTO tree VALUES (5,2,'Verma', 1973);
INSERT INTO tree VALUES (6,2,'Foster', 1972);
INSERT INTO tree VALUES (7,6,'Brown', 1981);

create index i_tree_name_mgrid_id  on tree(name,mgrid,id);
select /*+ recompile */ * from tree where name='Kim' order by mgrid;
select /*+ recompile */ * from  tree  where id>0 and mgrid=1 order by id,name,birthyear;
update /*+ recompile */ tree set id=2  where id>0 and mgrid=1 order by id,name,birthyear;
drop table tree;




create table t(a int auto_increment);
insert into t values (1);
select incr(a),incr(a) from t where a>0 order by a;
create index i_t_a  on t(a);
select /*+ recompile */ a from t where a>0 order by a;
select /*+ recompile */ incr(a) from t where a>0 order by a;
delete from tree where id>0 and mgrid=1 order by id,name,birthyear;
drop table t;

create table t (a int, b int,c int, d int,e int);
insert into t values (1,1,1,1,1);
insert into t values (2,1,1,1,1);
insert into t values (3,2,2,2,2);
insert into t values (4,3,3,3,3);

create index i_t_bdc on t(b,d,c);
create index i_t_bcd on t(b,c,d);
update statistics on all classes;

--should use i_t_bdc
select /*+ recompile */ b,c,d from t where b>0 and c>0 and d>0 order by b,d;

--should use i_t_bcd
select /*+ recompile */ b,c,d from t where b>0 and c>0 and d>0 order by b,c,d;

--should use i_t_bdc
select /*+ recompile */ b,c,d from t where b>0 and c=1 and d>0 using index i_t_bdc order by b,d;

--should use i_t_bcd
select /*+ recompile */ b,c,d from t where b>0 and c=1 and d>0 using index i_t_bcd order by b,d;

--should use i_t_bdc
select /*+ recompile */ b,c,d from t where b=1 and c=1 and d>0 using index i_t_bcd order by d;

--should use i_t_bcd
select /*+ recompile */ b,c,d from t where b=1 and c>1 and d>0 order by c;

--should use i_t_bdc
select /*+ recompile */ b,c,d from t where b=1 and c>1 and d>0 order by d;

commit;
--+ holdcas off;
