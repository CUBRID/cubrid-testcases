select * from json_table ('[1]', '$[0]' COLUMNS (id string path '')) as t;
select * from json_table ('[1]', '$[0]' COLUMNS (id string path ' ')) as t;
select * from json_table ('[1]', '$[0]' COLUMNS (id string path '$')) as t;
select * from json_table ('[1]', '$[0]' COLUMNS (id string path '/')) as t;
select * from json_table ('[1]', '' COLUMNS (id string path '')) as t;
select * from json_table ('[1]', '' COLUMNS (id string path '/0')) as t;
select * from json_table ('[1]', '' COLUMNS (id string path '$[0]')) as t;

select * from json_table ('[]', '$[0]' COLUMNS (id string path '')) as t;
select * from json_table ('[]', '$[0]' COLUMNS (id string path '$')) as t;
select * from json_table ('[]', '$[0]' COLUMNS (id string path '/')) as t;
select * from json_table ('[]', '' COLUMNS (id string path '')) as t;
select * from json_table ('[]', '' COLUMNS (id string path '/0')) as t;
select * from json_table ('[]', '' COLUMNS (id string path '$[0]')) as t;

select * from json_table ('[', '$[0]' COLUMNS (id string path '')) as t;
select * from json_table ('[', '$[0]' COLUMNS (id string path '$')) as t;
select * from json_table ('[', '$[0]' COLUMNS (id string path '/')) as t;
select * from json_table (']', '' COLUMNS (id string path '')) as t;
select * from json_table (']', '' COLUMNS (id string path '/0')) as t;
select * from json_table (']', '' COLUMNS (id string path '$0]')) as t;
select * from json_table (']', '' COLUMNS (id string path '$0')) as t;

select * from json_table ('{"]":"["}', '' COLUMNS (id string path '$.]')) as t;
select * from json_table ('{"]":"["}', '' COLUMNS (id string path '$."]"')) as t;

select * from json_table ('{"]":"["}', ' ' COLUMNS (id string path '')) as t;
select * from json_table ('{"[":"]"}', ' ' COLUMNS (id string path ' ')) as t;
select * from json_table ('{"{":"}"}', ' ' COLUMNS (id string path ' ')) as t;
select * from json_table ('{"}":"}"}', ' ' COLUMNS (id string path '$."}"')) as t;

--CBRD-22712
set @js='{"first{name": "Jone"}';
select json_valid(@js);
select json_extract(@js, '$."first{name"');
drop variable @js;
select * from json_table ('{"{":"}"}', ' ' COLUMNS (id string path '$."{"')) as t;
select * from json_table ('{"{ : }":"{ : }"}', '' COLUMNS (id string path '$."{ : }"')) as t;

