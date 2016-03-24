--+ holdcas on;

set names utf8;
create table t1 (s1 string collate utf8_en_cs);
create index i_t1_f_s1 on t1(locate('İ',s1));
insert into t1 values ('İacb');
insert into t1 values ('aİbc');
insert into t1 values ('accİ');

-- index scan
select /* +recompile */ s1 from t1 where locate('İ',s1) > 1 order by 1;

set names iso88591;
-- no index scan
select /* +recompile */ s1 from t1 where locate('İ',s1) > 1 order by 1;
-- force index scan
select /* +recompile */ s1 from t1 where locate(_utf8'İ',s1) > 1  order by 1;

drop table t1;



-- other non-binary collation in SET NAMES does not change the constant printing (only charset introducer is printed)
set names utf8 collate utf8_en_cs;

create table t1 (s1 string collate utf8_en_cs);
create index i_t1_f_s1 on t1(locate('İ',s1));
insert into t1 values ('İacb');
insert into t1 values ('aİbc');
insert into t1 values ('accİ');

-- index scan
select /* +recompile */ s1 from t1 where locate('İ',s1) > 1 order by 1;

set names iso88591;
-- no index scan
select /* +recompile */ s1 from t1 where locate('İ',s1) > 1 order by 1;

-- force index scan
select /* +recompile */ s1 from t1 where locate(_utf8'İ',s1) > 1 order by 1;

drop table t1;

set names iso88591;

commit;
--+ holdcas off;

