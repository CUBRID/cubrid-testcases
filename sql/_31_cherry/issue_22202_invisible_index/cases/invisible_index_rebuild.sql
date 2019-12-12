drop table if exists foo;
create table foo (i int);
create index i_foo_i on foo (i) invisible;
alter index i_foo_i on foo rebuild;
alter index i_foo_i on foo invisible;
alter index i_foo_i on foo visible;
alter index i_foo_i on foo invisible rebuild;
alter index i_foo_i on foo rebuild invisible;
alter index i_foo_i on foo rebuild visible;
alter index i_foo_i on foo visible rebuild;
alter index idx_not_exist on t1 invisible;
drop table foo;

create table foo (i int);
create index i_foo_i on foo (i) with online invisible invisible;
create index i_foo_i on foo (i) with online invisible;
alter index i_foo_i on foo invisible;
drop table foo;

drop table if exists t;
create table t(i int comment 'auto_increment');
create unique index idx1 on t(i) comment 'uuuu';
show index from t;
alter index idx1 on t(i) invisible;
alter index idx1 on t invisible;
show index from t;
alter index idx1 on t isible;
show index from t;
alter index idx1 on t(i) comment 'aaa' invisible;
alter index idx1 on t comment 'aaa' invisible;
alter index idx1 on t invisible comment 'aaa';
show index from t;
drop table if exists t;

drop table if exists tb;
create table tb (a int not null , b int);
create index i_tb_all on tb(a,b) where b IS NULL invisible;
insert into tb values (1,1);
insert into tb values (2,null);

--@queryplan
select /*+ recompile */ * from tb where  a>0 and b is not null;
--@queryplan
select /*+ recompile */ * from tb where  a>0 and b is not null using index i_tb_all(+);

alter index i_tb_all on tb invisible;
--@queryplan
select /*+ recompile */ * from tb where  a>0 and b is not null;
--@queryplan
select /*+ recompile */ * from tb where  a>0 and b is not null using index i_tb_all(+);

alter index i_tb_all on tb(a,b) where b is not null rebuild;
--@queryplan
select /*+ recompile */ * from tb where  a>0 and b is not null;
--@queryplan
select /*+ recompile */ * from tb where  a>0 and b is not null using index i_tb_all(+);

alter index i_tb_all on tb visible;
--@queryplan
select /*+ recompile */ * from tb where  a>0 and b is not null;
--@queryplan
select /*+ recompile */ * from tb where  a>0 and b is not null using index i_tb_all(+);

drop table tb;


drop table if exists t1 ;
create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
insert into t1 value('ye', 'jin yi',31,'M');
CREATE INDEX first_name_lower ON t1 (LOWER(FirstName)) invisible;
show indexes from t1;
ALTER  INDEX first_name_lower on t1 REBUILD;
show indexes from t1;
ALTER  INDEX first_name_lower on t1(firstname) WHERE LOWER(FirstName)='yin' REBUILD;
show indexes from t1;
--@queryplan
SELECT /*+ recompile */ * FROM t1 WHERE LOWER(FirstName)='yin' using index first_name_lower(+);
SELECT /*+ recompile */ * FROM t1 WHERE LOWER(FirstName)='yin';
drop  table t1 ;

