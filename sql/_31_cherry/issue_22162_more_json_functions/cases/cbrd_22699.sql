--+ holdcas on;
set @js='{
   "students":[
      {
         "name":"Mike",
         "role_list":[
            1,
            2,
            3
         ]
      },
      {
         "name":"Jone",
         "role_list":[
            1,
            3,
            5
         ]
      }
   ]
}';

SELECT * FROM JSON_TABLE(@js,  '$.students[*]'
    columns(
          id for ORDINALITY,
          name varchar(50) path '$.name',
    	  nested path '$."role_list"[*]' columns (
            sub_id for ORDINALITY,
            role_id int path '$'
          )
     )
  ) t order by 1,2,3,4;


drop view if exists v1;
create view v1 as SELECT * FROM JSON_TABLE(@js,  '$.students[*]'
    columns(
          id for ORDINALITY,
          name varchar(50) path '$.name',
          nested path '$."role_list"[*]' columns (
            sub_id for ORDINALITY,
            role_id int path '$'
          )
     )
  ) t;

create view v1 as 
SELECT * FROM JSON_TABLE('{
   "students":[
      {
         "name":"Mike",
         "role_list":[
            1,
            2,
            3
         ]
      },
      {
         "name":"Jone",
         "role_list":[
            1,
            3,
            5
         ]
      }
   ]
}',  '$.students[*]'
    columns(
          id for ORDINALITY,
          name varchar(50) path '$.name',
          nested path '$."role_list"[*]' columns (
            sub_id for ORDINALITY,
            role_id int path '$'
          )
     )
  ) t order by 1,2,3,4;

select * from v1 order by 1,2,3,4;
drop view if exists v1;

prepare st from 'SELECT * FROM JSON_TABLE(?,   ''$.students[*]''
    columns(
          id for ORDINALITY,
          name varchar(50) path ''$.name'',
          nested path ''$."role_list"[*]'' columns (
            sub_id for ORDINALITY,
            role_id int path ''$''
          )
     )
  ) t order by 1,2,3,4;';

set @js='{
   "students":[
      {
         "name":"Mike",
         "role_list":[
            1,
            2,
            3
         ]
      },
      {
         "name":"Jone",
         "role_list":[
            1,
            3,
            5
         ]
      },
      {
         "name":"Jone",
         "role_list":[
            1,
            5
         ]
      }
   ]
}';

execute st using @js;

set @js='{
   "students":[
      {
         "name":"Jone",
         "role_list":[
            1,
            5
         ]
      }
   ]
}';

execute st using @js;
deallocate prepare st;

drop variable @js;


--+ holdcas off;
