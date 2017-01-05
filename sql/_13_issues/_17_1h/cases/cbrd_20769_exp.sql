-- RHS
drop table if exists foo;
create table foo (i int primary key, s string);
insert into foo values (1, 'aaa');
prepare s from 'select * from foo where ? in nvl(s, ?);'
execute s using 'a', '';
drop prepare s;

prepare s from 'select * from foo where ? not in nvl(s, ?) order by i;';
execute s using 'a', '';
drop prepare s;

drop table if exists t1;
create table t1 (a varchar(10));
insert into t1 values ('1'), ('2'), ('3'), (null);

set @a=cast ('b' as string);
set @b=cast (1 as int);
select * from t1 where  @a in NVL2( a, a, a) and @b in NVL2( a, a, a);
drop table if exists t1;


prepare s from 'select * from foo where ? = ANY{s, ?}';
execute s using 'a', 'aaa';
execute s using 's', 'aaa'; 
drop prepare s;

prepare s from 'select * from foo where s = ANY{s, ?} order by i';
execute s using  'aaa';
drop prepare s;

prepare s from 'select * from foo where s in nvl(s, ?)'; 
insert into foo values(2,NULL);
execute s using '';
execute s using NULL;
execute s using 'aaa';
drop prepare s;

prepare ss from 'select * from foo where ? in (? , ?, NULL, nvl(s, ?)) order by 1;';
execute ss using 'a', 'dd', 'ccc', 'a';
drop prepare ss;

prepare mm from 'select * from foo where ? REGEXP nvl(s, ?) order by 1;';
execute mm using 'a', '%a';
execute mm using 'a', '^[a-z]';
insert into foo values(4,'^[a]');
execute mm using 'dd', 'dd';
drop prepare mm;

prepare xx from 'select * from foo where ? < position(nvl(s, ?) in ?) order by 1;';
execute xx using '2', 'aaa', 'ddaaa'; 
drop prepare xx;

--LHS
prepare ss from 'select * from foo where nvl(s, ?) in (? , ?) order by 1;';
execute ss using 'd','aaa', 'd';
execute ss using 'a', '%a';
drop prepare ss;

prepare ss from 'select * from foo where nvl(s, ?) not in (? , ?) order by 1;';
execute ss using 'd','aaa', 'd';
drop prepare ss;

prepare ss from 'select * from foo where nvl(i, ?) between nvl2(s, ?, ?) and nvl(s, ?) order by 1;';
execute ss using '2', '2','3','4';
execute ss using 'a', 'b','c','d';
drop prepare ss;

prepare ss from 'select * from foo where nvl(?, i) in (select i from foo where s is not null) order by 1;';
execute ss using 1;
execute ss using NULL;
execute ss '';
drop prepare ss;

drop table if exists tbl;
CREATE TABLE tbl ( color ENUM ('red', 'yellow', 'blue', 'green'));
INSERT INTO tbl (color) VALUES ('yellow');
INSERT INTO tbl (color) VALUES (1);

prepare yy from 'select concat(color, ?) from tbl where nvl(?, color) in (?,?) order by 1;'; 
execute yy using ' - aaa', NULL,'red','2';
drop prepare yy;

drop table if exists t2;
create table t2 (a char(10));
create index i_t2_a on t2(a);
insert into t2 values ('1234567890');
prepare stmt from 'select a from t2 where ? like cast ((?+''%'') as char(11))'
execute stmt using '', '1234';
drop prepare stmt;

prepare stmt from 'select a from t2 where ifnull(a, ?) like cast ((?+''%'') as char(11))' 
execute stmt using '', '1234';
drop prepare stmt;

prepare stmt from 'select (not ? regexp nvl(a, ?)) from t2;'; 
execute stmt using '4@Y', '^[XuyY1@]$';
drop prepare stmt;

prepare stmt from 'select * from t2 where ? > (not ? regexp nvl(a, ?)) order by 1;';
execute stmt using '2', '', '%a%';
execute stmt using '', '', '%a%';
drop prepare stmt;

drop table if exists t2;
drop table if exists tbl;
drop table if exists foo;

