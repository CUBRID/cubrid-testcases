drop table if exists tbl;
CREATE TABLE tbl (str STRING , j int ,primary key(str,j)) COLLATE utf8_en_ci
PARTITION BY LIST (str) (
    PARTITION p0 VALUES IN (_utf8'test'),
    PARTITION p1 VALUES IN (_utf8'TdST')
);
alter table tbl add partition (partition  p2 values in (_utf8'gggg'));
create unique index udex on tbl (str);
alter index udex on tbl rebuild;
drop table if exists tbl;
CREATE TABLE tbl (str STRING) 
PARTITION BY LIST (str) (
    PARTITION p0 VALUES IN ('test'),
    PARTITION p1 VALUES IN ('TdST')
);
alter table tbl add partition (partition  p2 values in  ('gggg'));

create unique index udex on tbl (str);
alter index udex on tbl rebuild;
set  names utf8;
drop table if exists tbl;
CREATE TABLE tbl (str STRING primary key) COLLATE utf8_en_cs
PARTITION BY LIST (str) (
    PARTITION p0 VALUES IN ('test'),
    PARTITION p1 VALUES IN ('TEST')
);
alter table tbl add partition (partition  p2 values in  ('gggg'));
insert into tbl values('test');
insert into tbl values('TEST');
create unique index udex on tbl (str);
alter index udex on tbl rebuild;


set names utf8;
drop table if exists tbl;
CREATE TABLE tbl (str STRING primary key) COLLATE utf8_en_ci
PARTITION BY LIST (str) (
    PARTITION p0 VALUES IN ('test'),
    PARTITION p1 VALUES IN ('TdST')
);
alter table tbl add partition (partition  p2 values in ('gggg'));


drop table if exists tbl;
CREATE TABLE tbl (str STRING unique,str2 varchar(50)) COLLATE utf8_en_ci
PARTITION BY LIST (str) (
    PARTITION p0 VALUES IN ( _utf8'test'),
    PARTITION p1 VALUES IN (_utf8'zhongshu')
);
insert into tbl values('test',1);
insert into tbl values('zhongshu',2);
select * from tbl partition(p0);
alter table tbl add  primary key(str);
alter table tbl add  primary key(str2);
select a.*,b.* from tbl__p__p0 a,tbl__P__p1 b where a.str='test' and b.str2='2';

drop table if exists tbl;
CREATE TABLE tbl (str STRING unique,str2 varchar(50)) COLLATE utf8_en_ci
PARTITION BY LIST (str) (
    PARTITION p0 VALUES IN ( _utf8'test'),
    PARTITION p1 VALUES IN (_utf8'zhongshu')
);
insert into tbl values('test',1);
insert into tbl values('test',2);
insert into tbl values('zhongshu',2);
insert into tbl values('Zhongshu',1);
select * from tbl partition(p0);
alter table tbl add  primary key(str);
alter table tbl add  unique key(str2);
create index idx on tbl(str2);
select  a.*,b.* from tbl__p__p0 a,tbl__P__p0 b where a.str='test' and b.str2='1';
select  a.*,b.* from tbl__p__p0 a,tbl__P__p1 b where a.str='test' and b.str2='2';

drop table if exists tbl;
CREATE TABLE tbl (str STRING unique,str2 varchar(50)) COLLATE utf8_en_cs
PARTITION BY LIST (str) (
    PARTITION p0 VALUES IN ( _utf8'test'),
    PARTITION p1 VALUES IN (_utf8'zhongshu')
);
insert into tbl values('test',2);
insert into tbl values('Test',1);
insert into tbl values('zhongshu',2);
insert into tbl values('Zhongshu',1);
select * from tbl partition(p0);
alter table tbl add  primary key(str,str2);
alter table tbl add  unique key(str2);
create index idx on tbl(str2);
select  a.*,b.* from tbl__p__p0 a,tbl__P__p0 b where a.str='test' and b.str2='1';
select  a.*,b.* from tbl__p__p0 a ,tbl__P__p1 b where a.str2=b.str2 and a.str='test' and b.str2='2';
drop tbl;
set names iso88591;
