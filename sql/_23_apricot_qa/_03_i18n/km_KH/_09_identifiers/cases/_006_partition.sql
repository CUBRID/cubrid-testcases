--+ holdcas on;
set names utf8;
create table កខណតថ( i_បី1 int) partition by range (i_បី1) (partition p0 VALUES LESS THAN (2),partition p1 VALUES LESS THAN (20));

insert into កខណតថ values (1), (3), (5);

select * from កខណតថ__P__P0;
select * from កខណតថ__p__p1;

desc កខណតថ;

drop table កខណតថ;
set names iso88591;
commit;
--+ holdcas off;
