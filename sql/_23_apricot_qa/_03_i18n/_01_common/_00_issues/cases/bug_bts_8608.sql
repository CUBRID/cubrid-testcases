drop table if exists tbl;
set names utf8;
create table tbl(s1 string collate utf8_bin,s2 string collate utf8_ko_cs_uca);
insert into tbl values('bb','aab');

select replace(s1,'b',s2) from tbl;
select replace(s2,'b',s1) from tbl;
select replace('abbaabaabb',s1,s2) from tbl;
select replace('abbaabaabb',s2,s1) from tbl;
select replace('ab baabaabb',s2,s1) from tbl;

alter table tbl partition by list(s1) (partition p0 values in('bb'),partition p1 values in ('aab'));
insert into tbl values('aab','bb');

select replace(s1,'b',s2) from tbl order by 1;
select replace(s2,'b',s1) from tbl order by 1 desc;
select replace('abbaabaabb',s1,s2) from tbl order by 1;
select replace('abbaabaabb',s2,s1) from tbl order by 1 desc;
select replace('ab baabaabb',s2,s1) from tbl order by 1 desc;

drop tbl;
set names iso88591;
