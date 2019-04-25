set @js='{
   "students":
      {
         "name":"Mike",
         "role_list":[1, 2, 3]
      }
}';


--note: normally try one query. it's quick to return result (0.004814 sec).
SELECT * FROM JSON_TABLE(@js,  '$.students'
    columns(
          c1 json PATH '$.name',
          c2 json PATH '$."role_list"'
     )
  ) as t;


--test: query is a little slow (0.863836 sec)
SELECT * FROM JSON_TABLE(@js,  '$.students.*'
    columns(
          c1 json PATH '$'
     )
  ) as t;


select if(benchmark(1000,(
  SELECT * FROM JSON_TABLE(@js,  '$.students'     
    columns(      
          c1 json PATH '$'    
    )    
  ) as t limit 1)
)>0, 'ok','nok');

select if(benchmark(1000,(
  SELECT * FROM JSON_TABLE(@js,  '$.students.*'
    columns(
          c1 json PATH '$'
    )
  ) as t limit 1)
)>0, 'ok','nok');

drop variable @js;
