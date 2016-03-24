--run static and dynamic binding query at the same time
--Test update statistics with keyword only on one partition of range partition
--+ holdcas on;
create class test_range(
transyear date,name string,amount double)
partition by range ( EXTRACT(YEAR from transyear)) (
partition p0 values less than (1990),
partition p1 values less than (2000),
partition p2 values less than MAXVALUE );


update statistics on only test_range__p__p0;


drop class test_range;
create class foo ( a varchar(10), b varchar(10));
insert into foo values('a', 'b');
select a fir from foo where a = 'a'  and b = 'b';
$varchar,$a;
select a fir from foo where a = ?  and b = 'b';
drop foo;

create class foo ( a int, b varchar(10));
insert into foo values(1, 'b');
select a fir from foo where a = 1  and b = 'b';
$integer,$1;
select a fir from foo where a = ?  and b = 'b';
drop foo;

create class foo ( a int, b varchar(10));
insert into foo values(1, 'b');
select a fir from foo where a = 1  and b = 'b';
$integer,$1,$varchar,$b
select a fir from foo where a = ?  and b = ?;
drop foo;

create class foo ( a int, b varchar(10));
insert into foo values(1, 'b');
select a fir from foo where a = 1  and b = 'b';
$integer,$1,$varchar,$b
select a fir from foo where a = ?  and b = ?;
select a fir from foo where a = 1  and b = 'b';
$integer,$1,$varchar,$b
select a fir from foo where a = ?  and b = ?;
$integer,$1,$varchar,$b
select a fir from foo where a = ?  and b = ?;
select a fir from foo where a = 1  and b = 'b';
drop foo;
--+ holdcas off;