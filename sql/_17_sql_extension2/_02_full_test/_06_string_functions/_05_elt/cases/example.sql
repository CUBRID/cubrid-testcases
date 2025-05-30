--cases from dev


select elt(3,'string1','string2','string3');
select elt('3','1/1/1','23:00:00','2001-03-04');
select elt(-1, 'string1','string2','string3');
select elt(4,'string1','string2','string3');
select elt(3.2,'string1','string2','string3');
select elt('a','string1','string2','string3');


SELECT ELT(1, 'ej', 'Heja', 'hej', 'foo');
SELECT ELT(4, 'ej', 'Heja', 'hej', 'foo');


--1. Test string types
select if(elt(1, 'abc', 'd', 'ef') = 'abc', 'ok', 'nok');
select if(elt(2, 'abc', 'd', 'ef') = 'd', 'ok', 'nok');
select if(elt(3, 'abc', 'd', 'ef') = 'ef', 'ok', 'nok');
select if(elt(1, n'abc', n'd', n'ef') = n'abc', 'ok', 'nok');
select if(elt(2, n'abc', n'd', n'ef') = n'd', 'ok', 'nok');
select if(elt(3, n'abc', n'd', n'ef') = n'ef', 'ok', 'nok');

-- out of range
select if(elt(0, 'abc', 'd', 'ef') is null, 'ok', 'nok');
select if(elt(-1, 'abc', 'd', 'ef') is null, 'ok', 'nok');
select if(elt(4, 'abc', 'd', 'ef') is null, 'ok', 'nok');

-- rounding 
select if(elt(1.5, 'abc', 'd', 'ef') = elt(2.4, 'abc', 'd', 'ef'), 'ok', 'nok');

-- error
select elt(1, 'abc', 'd', n'ef');
select elt(1, n'abc', 'd', n'ef');

-- server side
create table t (c1 char(32), c2 char(32), vc1 varchar(32), vc2 varchar(32), nc1 nchar(32), nc2 nchar(32), vnc1 nchar varying(32), vnc2 nchar varying(32));
insert into t values('a', 'bb', 'ccc', 'dddd', n'e', n'ff', n'ggg', n'hhhh');
select if(elt(1, c1, c2, vc1, vc2) = 'a', 'ok', 'nok') from t;
select if(elt(2, c1, c2, vc1, vc2) = 'bb', 'ok', 'nok') from t;
select if(elt(3, c1, c2, vc1, vc2) = 'ccc', 'ok', 'nok') from t;
select if(elt(4, c1, c2, vc1, vc2) = 'dddd', 'ok', 'nok') from t;
select if(elt(5, c1, c2, vc1, vc2) is null, 'ok', 'nok') from t;
select if(elt(0, c1, c2, vc1, vc2) is null, 'ok', 'nok') from t;
select if(elt(-100, c1, c2, vc1, vc2) is null, 'ok', 'nok') from t;
select if(elt(1, nc1, nc2, vnc1, vnc2) = n'e', 'ok', 'nok') from t;
select if(elt(2, nc1, nc2, vnc1, vnc2) = n'ff', 'ok', 'nok') from t;
select if(elt(3, nc1, nc2, vnc1, vnc2) = n'ggg', 'ok', 'nok') from t;
select if(elt(4, nc1, nc2, vnc1, vnc2) = n'hhhh', 'ok', 'nok') from t;
select if(elt(5, nc1, nc2, vnc1, vnc2) is null, 'ok', 'nok') from t;
select if(elt(0, nc1, nc2, vnc1, vnc2) is null, 'ok', 'nok') from t;
select if(elt(-100, nc1, nc2, vnc1, vnc2) is null, 'ok', 'nok') from t;
drop table t;

--2. Test numeric types
select if(elt(1, cast(123 as short), cast(1234 as integer), cast(12345 as bigint), cast(1.1 as float), cast(11.11 as double), cast(111.11 as monetary), cast(1111.111 as numeric(10,3))) = '123', 'ok', 'nok');
select if(elt(2, cast(123 as short), cast(1234 as integer), cast(12345 as bigint), cast(1.1 as float), cast(11.11 as double), cast(111.11 as monetary), cast(1111.111 as numeric(10,3))) = '1234', 'ok', 'nok');
select if(elt(3, cast(123 as short), cast(1234 as integer), cast(12345 as bigint), cast(1.1 as float), cast(11.11 as double), cast(111.11 as monetary), cast(1111.111 as numeric(10,3))) = '12345', 'ok', 'nok');
select if(elt(4, cast(123 as short), cast(1234 as integer), cast(12345 as bigint), cast(1.1 as float), cast(11.11 as double), cast(111.11 as monetary), cast(1111.111 as numeric(10,3))) = '1.1', 'ok', 'nok');
select if(elt(5, cast(123 as short), cast(1234 as integer), cast(12345 as bigint), cast(1.1 as float), cast(11.11 as double), cast(111.11 as monetary), cast(1111.111 as numeric(10,3))) = '11.11', 'ok', 'nok');
select if(elt(6, cast(123 as short), cast(1234 as integer), cast(12345 as bigint), cast(1.1 as float), cast(11.11 as double), cast(111.11 as monetary), cast(1111.111 as numeric(10,3))) = '$111.11', 'ok', 'nok');
select if(elt(7, cast(123 as short), cast(1234 as integer), cast(12345 as bigint), cast(1.1 as float), cast(11.11 as double), cast(111.11 as monetary), cast(1111.111 as numeric(10,3))) = '1111.111', 'ok', 'nok');
select if(elt(8, cast(123 as short), cast(1234 as integer), cast(12345 as bigint), cast(1.1 as float), cast(11.11 as double), cast(111.11 as monetary), cast(1111.111 as numeric(10,3))) is null, 'ok', 'nok');

-- server side
create table t (s short, i integer, bi bigint, f float, d double, m monetary, n numeric(10,1));
insert into t values(1, 2, 3, 1.1, 2.2, 3.3, 4.4);
select if(elt(1, s, i, bi, f, d, m, n) = '1', 'ok', 'nok') from t;
select if(elt(2, s, i, bi, f, d, m, n) = '2', 'ok', 'nok') from t;
select if(elt(3, s, i, bi, f, d, m, n) = '3', 'ok', 'nok') from t;
select if(elt(4, s, i, bi, f, d, m, n) = '1.1', 'ok', 'nok') from t;
select if(elt(5, s, i, bi, f, d, m, n) = '2.2', 'ok', 'nok') from t;
select if(elt(6, s, i, bi, f, d, m, n) = '$3.3', 'ok', 'nok') from t;
select if(elt(7, s, i, bi, f, d, m, n) = '4.4', 'ok', 'nok') from t;
select if(elt(8, s, i, bi, f, d, m, n) is null, 'ok', 'nok') from t;
select if(elt(0, s, i, bi, f, d, m, n) is null, 'ok', 'nok') from t;
select if(elt(-100, s, i, bi, f, d, m, n) is null, 'ok', 'nok') from t;
drop table t;

--3. Exceptions
select if(elt(1, '1', null, null) = '1', 'ok', 'nok');
select if(elt(2, '1', null, null) is null, 'ok', 'nok');
select if(elt(3, '1', null, null) is null, 'ok', 'nok');
select if(elt(3, '1', null, '') = '', 'ok', 'nok');

--4. Test host variable
-- success
prepare s from 'select if(elt(?, ?, ?) = ?, ''ok'', ''nok'')';
execute s using 1, 'a', 'b', 'a';
execute s using 2, 'a', 'b', 'b';
execute s using 1.4, 'a', 'b', 'a';
execute s using 1.5, 'a', 'b', 'b';
execute s using 1.4f, 'a', 'b', 'a';
execute s using 1.5f, 'a', 'b', 'b';
execute s using 1.4e0, 'a', 'b', 'a';
execute s using 1.5e0, 'a', 'b', 'b';
execute s using 1, date'2010-09-02', time'17:30:30', date'2010-09-02';
execute s using 2, datetime'2010-09-02 17:30:30', timestamp'2010-09-02 18:30:30', timestamp'2010-09-02 18:30:30';
execute s using 1, 1.1, 2.2, '1.1';
execute s using 2, 1.1f, 2.2e0, '2.2';
execute s using 1, $1.1, $2.2, '$1.1';
deallocate prepare s;

-- failure
prepare s from 'select elt(?, ?, ?)';
execute s using 'a', 1, 2;
execute s using n'a', 1, 2;
execute s using 0b1100, 1, 2;
execute s using date'2010-09-02', 1, 2;
execute s using time'17:30:30', 1, 2;
execute s using datetime'2010-09-02 17:30:30', 1, 2;
execute s using timestamp'2010-09-02 17:30:30', 1, 2;
execute s using 1, n'a', n'b';
deallocate prepare s;

