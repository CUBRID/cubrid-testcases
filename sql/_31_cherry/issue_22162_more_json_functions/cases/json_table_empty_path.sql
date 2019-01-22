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
--select * from json_table ('{"{":"}"}', ' ' COLUMNS (id string path '$."{"')) as t;
--select * from json_table ('{"{ : }":"{ : }"}', '' COLUMNS (id string path '$."{ : }"')) as t;

