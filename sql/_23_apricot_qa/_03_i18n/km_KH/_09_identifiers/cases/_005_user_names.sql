--+ holdcas on;
set names utf8;
create table t1 (i integer);

create user ហឡ៏ខ1;

create user ឯឡ៏ខ members ហឡ៏ខ1;

grant select on t1 to ហឡ៏ខ1;

grant delete on t1 to ឯឡ៏ខ;

show grants for ហឡ៏ខ1;

show grants for ឯឡ៏ខ;

drop user ឯឡ៏ខ;

drop user ហឡ៏ខ1;

drop table t1;
set names iso88591;
commit;
--+ holdcas off;

