SELECT FIELD('ej', 'Hej', 'ej ', 'Heja', 'hej', 'foo') from db_root;
SELECT FIELD('중국이', '''', '', '중국이 ', ' ', '중국이') from db_root;
SELECT FIELD('', '''', '', null, ' ', Null) from db_root;
SELECT FIELD('I''m', 'null', '', null, 'i''m', Null) from db_root;
SELECT FIELD('I''m', 'null', '', null, 'I''m', Null) from db_root;
SELECT FIELD(12, 'Hej', 'ej', 'Heja', 'hej', 'foo') from db_root;
SELECT FIELD(12, '12', 12, '12', 12, '12') from db_root;
SELECT FIELD(12, '121', 112, '112', 122, concat(1,2)) from db_root;
SELECT FIELD(121, '11', 112, '112', 122, concat_ws(2,1,1)) from db_root;
SELECT FIELD(3, 1|1, 1&1, 1, '3', 1^2) from db_root;
SELECT FIELD('3', 1|1, 1&1, 1, 1+2, 1^2) from db_root;
SELECT FIELD('3', 1|1, 1&1, 1, null, 1^2) from db_root;
SELECT FIELD('3', 1|1, 1&1, 1, null, 7 mod 4) from db_root;
SELECT FIELD(9223372036854775807, -9223372036854775807, 1&1, 1, 9223372036854775807*1, 7 mod 4) from db_root;
SELECT FIELD(2<<3, 1|1, 1&1, 1, 32 div 2, 7 mod 4) from db_root;
SELECT FIELD(null, 'Hej', 'ej', 'Heja', 'hej', 'foo') from db_root;
SELECT FIELD(SELECT 'ej' from db_root, 'Hej', 'ej', 'Heja', 'hej', 'foo') from db_root;
SELECT if(FIELD('I''m', 'null', '', null, 'I''m', Null) | FIELD('', '''', '', null, ' ', Null) = 6,'true','false')  from db_root;

select concat_ws(SELECT FIELD(null, 'Hej', 'ej', 'Heja', 'hej', 'foo') from db_root,
					SELECT FIELD(null, 'Hej', 'ej', 'Heja', 'hej', 'foo') +1 from db_root,
					SELECT FIELD(null, 'Hej', 'ej', 'Heja', 'hej', 'foo') +2 from db_root) from db_root;
select concat_ws(0,
					1,
					2) from db_root;
