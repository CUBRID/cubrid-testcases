--+ holdcas on;
set names utf8;
create table 测试表( i_列1 int) partition by range (i_列1) (partition p0 VALUES LESS THAN (2),partition p1 VALUES LESS THAN (20));

insert into 测试表 values (1), (3), (5);

select * from 测试表__P__P0;
select * from 测试表__p__p1;

desc 测试表;

drop table 测试表;
set names iso88591;
commit;
--+ holdcas off;