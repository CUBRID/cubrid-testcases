autocommit off;
create class cls_srt (id int, five int, ten int, dummy char(256));
insert into cls_srt (id) values (1);
insert into cls_srt (id) select id+  1 from cls_srt; --   2
insert into cls_srt (id) select id+  2 from cls_srt; --   4
insert into cls_srt (id) select id+  4 from cls_srt; --   8
insert into cls_srt (id) select id+  8 from cls_srt; --  16
insert into cls_srt (id) select id+ 16 from cls_srt; --  32
insert into cls_srt (id) select id+ 32 from cls_srt; --  64
insert into cls_srt (id) select id+ 64 from cls_srt; -- 128
insert into cls_srt (id) select id+128 from cls_srt; -- 256
insert into cls_srt (id) select id+256 from cls_srt; -- 512
insert into cls_srt (id) select id+512 from cls_srt; --1024
update cls_srt set five = mod(id, 5);    --#distinct:  5(0-4)
update cls_srt set ten = mod(id, 10);    --#distinct: 10(0-9)
update cls_srt set dummy = 'sort_test';  --#distinct:  1
select i
from (select id from cls_srt x order by id) as t(i)
where rownum = 1;
select i
from (select id from cls_srt x order by id desc) as t(i)
where rownum = 1;
select count(*)
from (select dummy, ten, five, id from cls_srt x) as t(i, j, k, l);
select count(*)
from (select dummy, dummy, dummy, id from cls_srt x) as t(i, j, k, l);
select count(*)
from (select five from cls_srt x) as t(i);
select count(*)
from (select ten from cls_srt x) as t(i);
select count(*)
from (select dummy from cls_srt x) as t(i);
select count(*) 
from (select distinct id from cls_srt x) as t(i);
select count(*)
from (select distinct dummy, ten, five, id from cls_srt x) as t(i, j, k, l);
select count(*)
from (select distinct dummy, dummy, dummy, id from cls_srt x) as t(i, j, k, l);
select count(*)
from (select distinct five from cls_srt x) as t(i);
select count(*)
from (select distinct ten from cls_srt x) as t(i);
select count(*)
from (select distinct dummy from cls_srt x) as t(i);
rollback work;
rollback;
