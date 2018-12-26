
select json_merge_patch('"string"');
select json_merge_patch('"string"', 123);
select json_merge_patch('"string"', '123');
select json_merge_patch('"string"', cast(123 as json) );
select json_merge_patch('[1, 2]', '[true, false]');
select json_merge_patch('{"1": 2}', '{"true": false}');
select json_merge_patch('{"1": 2}', '{"true": false}', '{"3": 4}');
select json_merge_patch(NULL,json_object('foo', 1));
select json_merge_patch('a','b');
select json_merge_patch('"a"','"b"');
select json_merge_patch('{"a":"b"}','{"c":"d"}');
SELECT json_merge_patch('[1, 2]', '{"id": 47}');
select json_merge_patch('{"a":"b"}', '{"a":"c"}') ;
select json_merge_patch('{"a":{"x":"b"}}', '{"a":"c"}') ;
select json_merge_patch('{"a":{"u":12, "x":"b"}}', '{"a":{"x":"c"}}') ;
select json_merge_patch('{"a":{"u":12, "x":"b", "r":1}}', '{"a":{"x":"c", "r":2}}') ;

drop table if exists tbl;
create table tbl (i int, a json, b json, c json);
insert into tbl values (1, 123,'"aaa"','{"a":[1,2,3]}');
insert into tbl values (2, 456,'"bbb"', json_array('t',1,2,3,4));

select * from tbl order by a,b,c;
select json_merge_patch(a,b,c),i from tbl order by 1,2;
select json_contains(json_merge_patch(a,b,c),a), i from tbl order by 1,2;
select json_contains(json_merge_patch(a,b,c),json_merge_patch(a,b)), i from tbl order by 1,2;
select json_contains(json_merge_patch(a,b,c),json_merge_patch(a,c)), i from tbl order by 1,2;
select json_contains(json_merge_patch(a,b,c),c,'/1'), i from tbl order by 1,2;
select json_contains(json_merge_patch(a,b,c),'"456"','/1'), i from tbl order by 1,2;
select json_contains(json_merge_patch(a,b,c),456,'/0'), i from tbl order by 1,2;
select json_contains('[123,"aaa",{"a":[1,2,3]}]', 123,'/0');
select json_contains(json_merge_patch(a,b,c,'789'), '789', '/3'), i from tbl order by 1,2;
select json_contains(json_merge_patch(a,b,c,'789'), '2', '/2/a'), i from tbl order by 1,2;
select json_contains(json_merge_patch(a,b,c,'789',json_type(222)), '2', '/2/a'), i from tbl order by 1,2;

drop table if exists tbl;
