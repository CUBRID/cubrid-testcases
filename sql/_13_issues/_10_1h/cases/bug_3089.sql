-- 'left' have result
select left('abcde', cast(1 as short)) order by 1;
select left('abcde', cast(1 as integer)) order by 1;
select left('abcde', cast(1 as bigint)) order by 1;
-- 'left' have no result
select left('abcde', cast(1 as char(10))) order by 1;
select left('abcde', cast(1 as char varying(10))) order by 1;
select left('abcde', cast(1 as nchar(10))) order by 1;
select left('abcde', cast(1 as nchar varying(10))) order by 1;
select left('abcde', cast(1 as float)) order by 1;
select left('abcde', cast(1 as double)) order by 1;
select left('abcde', cast(1 as numeric(10,5))) order by 1;
select left('abcde', cast(B'1' as bit(32))) order by 1;
select left('abcde', cast(B'1' as bit varying(32))) order by 1;

-- 'left' have same result
select substring('abcde' from 1 for -1) order by 1;
select left('abcde', -1) order by 1;

-- 'left' have result
select left('abcde', 100) order by 1;

-- 'right' have result
select right('abcde', cast(1 as short)) order by 1;
select right('abcde', cast(1 as integer)) order by 1;
select right('abcde', cast(1 as bigint)) order by 1;

-- 'right' have no result
select right('abcde', cast(1 as char(10))) order by 1;
select right('abcde', cast(1 as char varying(10))) order by 1;
select right('abcde', cast(1 as nchar(10))) order by 1;
select right('abcde', cast(1 as nchar varying(10))) order by 1;
select right('abcde', cast(1 as float)) order by 1;
select right('abcde', cast(1 as double)) order by 1;
select right('abcde', cast(1 as numeric(10,5))) order by 1;
select right('abcde', cast(B'1' as bit(32))) order by 1;
select right('abcde', cast(B'1' as bit varying(32))) order by 1;

-- 'right' have the same result
select substring('abcde' from 1 for -1) ;
select right('abcde', -1) ;

-- 'right' have result
select right('abcde', 100) ;

-- Server-side
create table x (vc varchar(32),
                s smallint,
                i int,
                bi bigint,
                f float,
                d double,
                n numeric(10,5),
                b bit(32),
                vb bit varying(32)
                ) ;

insert into x values(NULL, 1, 1, 1, 1, 1, 1, B'1', B'1') order by 1;
insert into x values('', 1, 1, 1, 1, 1, 1, B'1', B'1') order by 1;
insert into x values('a', 1, 1, 1, 1, 1, 1, B'1', B'1') order by 1;
insert into x values('ab', 1, 1, 1, 1, 1, 1, B'1', B'1') order by 1;
insert into x values('abc', 1, 1, 1, 1, 1, 1, B'1', B'1') order by 1;
insert into x values('abcd', 1, 1, 1, 1, 1, 1, B'1', B'1') order by 1;

insert into x values(NULL, -1, -1, -1, -1, -1, -1, B'1', B'1') order by 1;
insert into x values('', -1, -1, -1, -1, -1, -1, B'1', B'1') order by 1;
insert into x values('a', -1, -1, -1, -1, -1, -1, B'1', B'1') order by 1;
insert into x values('ab', -1, -1, -1, -1, -1, -1, B'1', B'1') order by 1;
insert into x values('abc', -1, -1, -1, -1, -1, -1, B'1', B'1') order by 1;
insert into x values('abcd', -1, -1, -1, -1, -1, -1, B'1', B'1') order by 1;

insert into x values(NULL, 100, 100, 100, 100, 100, 100, B'1', B'1') order by 1;
insert into x values('', 100, 100, 100, 100, 100, 100, B'1', B'1') order by 1;
insert into x values('a', 100, 100, 100, 100, 100, 100, B'1', B'1') order by 1;
insert into x values('ab', 100, 100, 100, 100, 100, 100, B'1', B'1') order by 1;
insert into x values('abc', 100, 100, 100, 100, 100, 100, B'1', B'1') order by 1;
insert into x values('abcd', 100, 100, 100, 100, 100, 100, B'1', B'1') order by 1;

select left(vc, s) from x order by 1;
select left(vc, i) from x order by 1;
select left(vc, bi) from x order by 1;
select left(vc, f) from x order by 1;
select left(vc, d) from x order by 1;
select left(vc, n) from x order by 1;
select left(vc, b) from x order by 1;
select left(vc, vb) from x order by 1;

select right(vc, s) from x order by 1;
select right(vc, i) from x order by 1;
select right(vc, bi) from x order by 1;
select right(vc, f) from x order by 1;
select right(vc, d) from x order by 1;
select right(vc, n) from x order by 1;
select right(vc, b) from x order by 1;
select right(vc, vb) from x order by 1;

drop table x; 






