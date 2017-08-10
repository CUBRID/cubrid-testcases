--+ holdcas on;
set names utf8;
create table テストテーブル( i_の行1 int) partition by range (i_の行1) (partition 亜0 VALUES LESS THAN (2),partition p1 VALUES LESS THAN (20));

insert into テストテーブル values (1), (3), (5);

select * from テストテーブル__P__亜0;
select * from テストテーブル__p__p1;

desc テストテーブル;

drop table テストテーブル;
set names iso88591;
commit;
--+ holdcas off;