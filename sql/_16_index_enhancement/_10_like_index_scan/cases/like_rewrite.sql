--+ holdcas on;

create table tbl (c varchar (22) not null);
create index i_tbl_c on tbl (c);

insert into tbl values ('a');
insert into tbl values ('aa');
insert into tbl values ('aaa');
insert into tbl values ('aaz');
insert into tbl values ('aaabb');
insert into tbl values ('abbb');
insert into tbl values ('bc');
insert into tbl values ('cb');
insert into tbl values ('cc');
insert into tbl values ('b');
insert into tbl values ('c');
insert into tbl values ('%%');
insert into tbl values ('%');
insert into tbl values ('_');
insert into tbl values ('__');
insert into tbl values ('_%');
insert into tbl values (' b');
insert into tbl values ('zzz');


prepare stmt from 'select * from tbl where c like ? order by 1'; execute stmt using '%';
$varchar, $%
select * from tbl where c like ? order by 1;
deallocate prepare stmt;

prepare stmt from 'select * from tbl where c like ? order by 1'; execute stmt using '_';
$varchar, $_
select * from tbl where c like ? order by 1;
deallocate prepare stmt;

prepare stmt from 'select * from tbl where c like ''%'' + ? order by 1'; execute stmt using 'c';
$varchar, $c
select * from tbl where c like '%' + ? order by 1;
deallocate prepare stmt;

prepare stmt from 'select * from tbl where c like ? + ''%'' order by 1'; execute stmt using 'c';
$varchar, $c
select * from tbl where c like ? + '%' order by 1;
deallocate prepare stmt;

prepare stmt from 'select * from tbl where c like ''%'' + ? + ''%'' order by 1'; execute stmt using 'z';
$varchar, $z
select * from tbl where c like '%' + ? + '%' order by 1;
deallocate prepare stmt;

prepare stmt from 'select * from tbl where c like ''a'' + ? order by 1'; execute stmt using 'a';
$varchar, $a
select * from tbl where c like 'a' + ? order by 1;
deallocate prepare stmt;

prepare stmt from 'select * from tbl where c like ''a'' + ? order by 1'; execute stmt using '%';
$varchar, $%
select * from tbl where c like 'a' + ? order by 1;
deallocate prepare stmt;

prepare stmt from 'select * from tbl where c like ''a'' + ? escape ? order by 1'; execute stmt using '%', NULL;
$varchar, $%, $varchar, $NULL
select * from tbl where c like 'a' + ? escape ? order by 1;
deallocate prepare stmt;

prepare stmt from 'select * from tbl where c like ''2'' + ? escape ? order by 1'; execute stmt using '%', 2;
$varchar, $%, $int, $2
select * from tbl where c like '2' + ? escape ? order by 1;
deallocate prepare stmt;

set system parameters 'no_backslash_escapes = false';
set system parameters 'require_like_escape_character = true';

prepare stmt from 'select * from tbl where c like ? + ''%'' order by 1'; execute stmt using '\\';
$varchar, $\
select * from tbl where c like ? + '%' order by 1;
deallocate prepare stmt;

prepare stmt from 'select * from tbl where c like ? + ''_'' order by 1'; execute stmt using '\\';
$varchar, $\
select * from tbl where c like ? + '_' order by 1;
deallocate prepare stmt;

set system parameters 'require_like_escape_character = false';

set system parameters 'no_backslash_escapes = true';

drop table tbl;



create table tbl_nv (c nchar varying (22));
create index  i_tbl_nv_c on tbl_nv (c);
insert into tbl_nv values (N'aa');
insert into tbl_nv values (N'aaa');
insert into tbl_nv values (N'aaz');
insert into tbl_nv values (N'aaabb');
insert into tbl_nv values (N'abbb');
insert into tbl_nv values (N'b');
insert into tbl_nv values (N' b');
insert into tbl_nv values (N'zzz');

prepare stmt from 'select * from tbl_nv where c like ? order by 1'; execute stmt using n'a%b';
deallocate prepare stmt;

drop table tbl_nv;



create table tbl_pat (patv varchar(10), patc char(10));
insert into tbl_pat (patv) values ('');
insert into tbl_pat (patv) values (' ');
insert into tbl_pat (patv) values ('  ');
insert into tbl_pat (patv) values ('%');
insert into tbl_pat (patv) values ('% ');
insert into tbl_pat (patv) values ('_%');
insert into tbl_pat (patv) values ('a %');
insert into tbl_pat (patv) values ('_a%');
insert into tbl_pat (patv) values ('a_a%');
insert into tbl_pat (patv) values ('a_a%a_a');
insert into tbl_pat (patv) values ('A%');
insert into tbl_pat (patv) values ('A%A');
insert into tbl_pat (patv) values ('A%%%%A');
update tbl_pat set patc = patv;

-- printing max char value will display different result in QATool, with different char sets (UTF-8 vs EUC-KR)
-- avoid printing "like_match_upper_bound (patv)"
-- instead specific queries are used to isolate and check the results in this cases

select patv, like_match_lower_bound (patv) as low, length(like_match_upper_bound (patv)) as len_up, length(patv) as lenpatv from tbl_pat order by 1,2,3,4;
select patc, like_match_lower_bound (patc) as low, length(like_match_upper_bound (patc)) as len_up, length(patv) as lenpatv from tbl_pat order by 1,2,3,4;
select patv, like_match_lower_bound (patv) as low, length(like_match_upper_bound (patv)) as len_up, length(patv) as lenpatv from tbl_pat where like_match_upper_bound (patv) > '~~' order by 1,2,3,4;
select patc, like_match_lower_bound (patc) as low, length(like_match_upper_bound (patc)) as len_up, length(patv) as lenpatv from tbl_pat where like_match_upper_bound (patc) > '~~' order by 1,2,3,4;

select patv, like_match_lower_bound (patv, '\') low, length(like_match_upper_bound (patv, '\')) len_up, length(patv) as lenpatv from tbl_pat order by 1,2,3,4;
select patc, like_match_lower_bound (patc, '\') low, length(like_match_upper_bound (patc, '\')) len_up, length(patv) as lenpatv from tbl_pat order by 1,2,3,4;
select patv, like_match_lower_bound (patv, '\') low, length(like_match_upper_bound (patv, '\')) len_up, length(patv) as lenpatv from tbl_pat where like_match_upper_bound (patv, '\') > '~~' order by 1,2,3,4;
select patc, like_match_lower_bound (patc, '\') low, length(like_match_upper_bound (patc, '\')) len_up, length(patv) as lenpatv from tbl_pat where like_match_upper_bound (patc, '\') > '~~' order by 1,2,3,4;


-- check results for upper bound for query 1 
select count(*) from tbl_pat where like_match_upper_bound (patv) > 'z' and length(like_match_upper_bound (patv)) = 1 and patv < 'z';
select count(*) from tbl_pat where like_match_upper_bound (patv) > 'z' and length(like_match_upper_bound (patv)) = 2;
select count(*) from tbl_pat where like_match_upper_bound (patv) > 'az' and length(like_match_upper_bound (patv)) = 3;

-- check results for upper bound for query 2
select count(*) from tbl_pat where like_match_upper_bound (patc) > 'z' and length(like_match_upper_bound (patc)) = 1 and patc < 'z';
select count(*) from tbl_pat where like_match_upper_bound (patc) > 'z' and length(like_match_upper_bound (patc)) = 2;
select count(*) from tbl_pat where like_match_upper_bound (patc) > 'az' and length(like_match_upper_bound (patc)) = 3;

-- check results for upper bound for query 3
select count(*) from tbl_pat where like_match_upper_bound (patv) > 'z' and length(like_match_upper_bound (patv)) = 1 and patv < 'z' and like_match_upper_bound (patv) > '~~';
select count(*) from tbl_pat where like_match_upper_bound (patv) > 'z' and length(like_match_upper_bound (patv)) = 2 and like_match_upper_bound (patv) > '~~';
select count(*) from tbl_pat where like_match_upper_bound (patv) > 'az' and length(like_match_upper_bound (patv)) = 3 and like_match_upper_bound (patv) > '~~';

-- check results for upper bound for query 4
select count(*) from tbl_pat where like_match_upper_bound (patc) > 'z' and length(like_match_upper_bound (patc)) = 1 and patc < 'z' and like_match_upper_bound (patc) > '~~';
select count(*) from tbl_pat where like_match_upper_bound (patc) > 'z' and length(like_match_upper_bound (patc)) = 2 and like_match_upper_bound (patc) > '~~';
select count(*) from tbl_pat where like_match_upper_bound (patc) > 'az' and length(like_match_upper_bound (patc)) = 3 and like_match_upper_bound (patc) > '~~';


-- check results for upper bound for query 5
select count(*) from tbl_pat where like_match_upper_bound (patv,'\') > 'z' and length(like_match_upper_bound (patv,'\')) = 1 and patv < 'z';
select count(*) from tbl_pat where like_match_upper_bound (patv,'\') > 'z' and length(like_match_upper_bound (patv,'\')) = 2;
select count(*) from tbl_pat where like_match_upper_bound (patv,'\') > 'az' and length(like_match_upper_bound (patv,'\')) = 3;

-- check results for upper bound for query 6
select count(*) from tbl_pat where like_match_upper_bound (patc,'\') > 'z' and length(like_match_upper_bound (patc,'\')) = 1 and patc < 'z';
select count(*) from tbl_pat where like_match_upper_bound (patc,'\') > 'z' and length(like_match_upper_bound (patc,'\')) = 2;
select count(*) from tbl_pat where like_match_upper_bound (patc,'\') > 'az' and length(like_match_upper_bound (patc,'\')) = 3;

-- check results for upper bound for query 7
select count(*) from tbl_pat where like_match_upper_bound (patv,'\') > 'z' and length(like_match_upper_bound (patv,'\')) = 1 and patv < 'z' and like_match_upper_bound (patv, '\') > '~~';
select count(*) from tbl_pat where like_match_upper_bound (patv,'\') > 'z' and length(like_match_upper_bound (patv,'\')) = 2 and like_match_upper_bound (patv, '\') > '~~';
select count(*) from tbl_pat where like_match_upper_bound (patv,'\') > 'az' and length(like_match_upper_bound (patv,'\')) = 3 and like_match_upper_bound (patv, '\') > '~~';

-- check results for upper bound for query 8
select count(*) from tbl_pat where like_match_upper_bound (patc,'\') > 'z' and length(like_match_upper_bound (patc,'\')) = 1 and patc < 'z' and like_match_upper_bound (patc, '\') > '~~';
select count(*) from tbl_pat where like_match_upper_bound (patc,'\') > 'z' and length(like_match_upper_bound (patc,'\')) = 2 and like_match_upper_bound (patc, '\') > '~~';
select count(*) from tbl_pat where like_match_upper_bound (patc,'\') > 'az' and length(like_match_upper_bound (patc,'\')) = 3 and like_match_upper_bound (patc, '\') > '~~';

select like_match_lower_bound ('g2%g', 2) from db_root;
select like_match_lower_bound (22, '\') from db_root;

drop table tbl_pat;
commit;
--+ holdcas off;
