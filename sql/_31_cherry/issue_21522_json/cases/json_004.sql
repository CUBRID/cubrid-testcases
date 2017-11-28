drop table if exists tbl;
create table tbl ( a json, b json, c json);
insert into tbl values (123,'"aaa"','{"a":[1,2,3]}');
insert into tbl values (456,'"bbb"', json_array('t',1,2,3,4));
select * from tbl order by a;
select json_merge(a,b,c) from tbl order by 1;
select json_contains(json_merge(a,b,c),a) from tbl; 
select json_contains(json_merge(a,b,c),json_merge(a,b)) from tbl;
select json_contains(json_merge(a,b,c),json_merge(a,c)) from tbl;
select json_contains(json_merge(a,b,c),c,'/1') from tbl;
select json_contains(json_merge(a,b,c),'"456"','/1') from tbl;
select json_contains(json_merge(a,b,c),456,'/0') from tbl; 
select json_contains('[123,"aaa",{"a":[1,2,3]}]', 123,'/0');
select json_contains(json_merge(a,b,c,'789'), '789', '/3') from tbl; 
select json_contains(json_merge(a,b,c,'789'), '2', '/2/a') from tbl;
select json_contains(json_merge(a,b,c,'789',json_type(222)), '2', '/2/a') from tbl;
select json_insert(json_insert(json_array('a', 'b'), '/3','"a"'),'/4','"1"');


drop table if exists tbl;
