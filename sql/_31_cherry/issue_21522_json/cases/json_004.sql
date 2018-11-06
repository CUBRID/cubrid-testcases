drop table if exists tbl;
create table tbl (i int, a json, b json, c json);
insert into tbl values (1, 123,'"aaa"','{"a":[1,2,3]}');
insert into tbl values (2, 456,'"bbb"', json_array('t',1,2,3,4));
select * from tbl order by a,b,c;
select json_merge(a,b,c),i from tbl order by 1,2;
select json_contains(json_merge(a,b,c),a), i from tbl order by 1,2; 
select json_contains(json_merge(a,b,c),json_merge(a,b)), i from tbl order by 1,2;
select json_contains(json_merge(a,b,c),json_merge(a,c)), i from tbl order by 1,2;
select json_contains(json_merge(a,b,c),c,'/1'), i from tbl order by 1,2;
select json_contains(json_merge(a,b,c),'"456"','/1'), i from tbl order by 1,2;
select json_contains(json_merge(a,b,c),456,'/0'), i from tbl order by 1,2; 
select json_contains('[123,"aaa",{"a":[1,2,3]}]', 123,'/0');
select json_contains(json_merge(a,b,c,'789'), '789', '/3'), i from tbl order by 1,2; 
select json_contains(json_merge(a,b,c,'789'), '2', '/2/a'), i from tbl order by 1,2;
select json_contains(json_merge(a,b,c,'789',json_type(222)), '2', '/2/a'), i from tbl order by 1,2;
select json_insert(json_insert(json_array('a', 'b'), '/3','a'),'/4','1');
select json_insert(json_insert(json_array('a', 'b'), '/3','"a"'),'/4','"1"');


drop table if exists tbl;
