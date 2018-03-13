drop table if exists t1;
create table t1 ( 
  col0 int auto_increment, 
  col1 int, 
  col2 numeric(10,0) default 0, 
  col3 char varying(30), col4 datetime
);
create trigger trigger_t1_update after update  on t1 execute print 'Executing After UPDATE TRIGGER';
insert into t1 (col1, col2, col3, col4) values (1, 201, 'aaa', '04:12:47.101 AM 02/09/2018');
--@queryplan
update t1 set col1='201', col3='AAA', col4='05:12:47.108 AM 02/09/2018' where col2=201;
--@queryplan
update t1 set col1='201', col2='201', col3='22', col4=NULL where col2=201; 

drop table if exists t1;
create table t1 (
  col0 int auto_increment,
  col1 int,
  col2 numeric(10,0) default 0,
  col3 char varying(30), col4 datetime
);
insert into t1 (col1, col2, col3, col4) values (1, 201, 'aaa', '04:12:47.101 AM 02/09/2018');
--@queryplan
update t1 set col1='201', col3='AAA', col4='05:12:47.108 AM 02/09/2018' where col2=201;
--@queryplan
update t1 set col1='201', col2='201', col3='22', col4=NULL where col2=201; 

drop table if exists t1;
create table t1 (
  col0 int auto_increment,
  col1 int,
  col2 numeric(10,0) default 0,
  col3 char varying(30), col4 datetime
);
create trigger trigger_t1_update after update  on t1 execute print 'Executing After UPDATE TRIGGER';
insert into t1 (col1, col2, col3, col4) values (1, 201, 'aaa', '04:12:47.101 AM 02/09/2018');
--@queryplan
update t1 set col1='201', col3='AAA', col4='05:12:47.108 AM 02/09/2018' where col2=201;
--@queryplan
update /*+ RECOMPILE */ t1 set col1='201', col2='201', col3='22', col4=NULL where col2=201; 

drop table if exists t1;


