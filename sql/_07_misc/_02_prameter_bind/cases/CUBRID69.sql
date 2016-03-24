--test for binding in where clause
--+ holdcas on;
create class xoo ( a int, b int);

insert into xoo values(1,1);
insert into xoo values(2,2);
insert into xoo values(3,3);
insert into xoo values(4,4);
insert into xoo values(5,5);

select a from xoo where a > 0 order by 1 desc for orderby_num() between (1*(2-1)) + 1 and 1 * 4;
$int,$1,$int,$2,$int,$1,$int,$4;
select a from xoo where a > 0 order by 1 desc for orderby_num() between (?*(?-1)) + 1 and ? * ?;
$int,$1,$int,$2,$int,$1,$int,$4;
select a from xoo where a > 0 order by 1 desc for orderby_num() between (?*(?))  and ? * ?;

select a from xoo where a > 0 and a between (1*(2-1)) + 1 and 1 * 4;
$int,$1,$int,$2,$int,$1,$int,$4;
select a from xoo where a > 0 and a between (?*(?-1)) + 1 and ? * ?;
$int,$1,$int,$2,$int,$1,$int,$4;
select a from xoo where a > 0 and a between (?*(?))  and ? * ?;

$varchar,$1,$varchar,$2,$varchar,$1,$varchar,$4;
select a from xoo where a > 0 order by 1 desc for orderby_num() between (?*(?-1)) + 1 and ? * ?;
$int,$1,$varchar,$2,$int,$1,$varchar,$4;
select /*+ RECOMPILE */ a from xoo where a > 0 order by 1 desc for orderby_num() between (?*(?))  and ? * ?;
select /*+ RECOMPILE */ a from xoo where a > 0 order by 1 desc for orderby_num() between (1*(2))  and 1 * 4;
$int,$1,$int,$2,$int,$1,$int,$4;
select a from xoo where a > 0 order by 1 desc for orderby_num() between (?*(?))  and ? * ?;
drop xoo;

commit;

--+ holdcas off;

