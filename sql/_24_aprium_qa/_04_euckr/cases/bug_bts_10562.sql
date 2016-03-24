drop if exists t1; 

set names utf8;

create table t1(a CHAR(3));
--test: below fail to execute.
show tables;
create index i_t1_a on t1(a desc);
show index in t1;

drop t1;

create table t1(a CHAR(3) primary key) partition by hash(a) partitions 2;;
--test: below fail to execute.
show tables;
create index i_t1_a on t1(a desc);
show index in t1;

drop t1;
create table t1(a varCHAR(300) primary key) partition by hash(a) partitions 2;;
--test: below fail to execute.
show tables;
create index i_t1_a on t1(a desc);
show index in t1;


set names euckr;

drop t1;
create table t1(a CHAR(3));
--test: below fail to execute.
show tables;
create index i_t1_a on t1(a desc);
show index in t1;


drop t1;
create table t1(a bigint);
--test: below fail to execute.
show tables;
create index i_t1_a on t1(a desc);
show index in t1;


drop t1;
create table t1(a CHAR(3) primary key) partition by hash(a) partitions 2;;
--test: below fail to execute.
show tables;
create index i_t1_a on t1(a desc);
show index in t1;

drop t1;

set names iso88591;


