--+ holdcas on;

set names utf8;

create table t1 (s1 string collate utf8_bin)
partition by range(char_length(concat(s1,'İ'))) (
partition len3 values less than (3),
partition len4 values less than (4),
partition len10 values less than (10)
);

insert into t1 values ('u');
insert into t1 values ('uu');
insert into t1 values ('uuu');

select s1 as all_s1 from t1 order by 1;
select s1 as s1_in_len3 from t1__p__len3 order by 1;
select s1 as s1_in_len4 from t1__p__len4 order by 1;
select s1 as s1_in_len10 from t1__p__len10 order by 1;

-- change names and check that results are the same (partition expression evalution is done using the charset used at creation)
set names iso88591;
insert into t1 values ('i');
insert into t1 values ('ii');
insert into t1 values ('iii');

select s1 as all_s1 from t1 order by 1;
select s1 as s1_in_len3 from t1__p__len3 order by 1;
select s1 as s1_in_len4 from t1__p__len4 order by 1;
select s1 as s1_in_len10 from t1__p__len10 order by 1;

drop table t1;



-- recreate so that charset of concat is ISO

set names iso88591;

create table t1 (s1 string collate iso88591_bin)
partition by range(char_length(concat(s1,'İ'))) (
partition len3 values less than (3),
partition len4 values less than (4),
partition len10 values less than (10)
);


insert into t1 values ('i');
insert into t1 values ('ii');
insert into t1 values ('iii');

select s1 as all_s1 from t1 order by 1;
select s1 as s1_in_len3 from t1__p__len3 order by 1;
select s1 as s1_in_len4 from t1__p__len4 order by 1;
select s1 as s1_in_len10 from t1__p__len10 order by 1;

-- change names and check that results are the same (partition expression evalution is done using the charset used at creation)
set names utf8;
insert into t1 values ('u');
insert into t1 values ('uu');
insert into t1 values ('uuu');
select s1 as all_s1 from t1 order by 1;
select s1 as s1_in_len3 from t1__p__len3 order by 1;
select s1 as s1_in_len4 from t1__p__len4 order by 1;
select s1 as s1_in_len10 from t1__p__len10 order by 1;


drop table t1;

set names iso88591; 

commit;
--+ holdcas off;
