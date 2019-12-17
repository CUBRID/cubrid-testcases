--+ holdcas on;
drop table if exists t;
create table t(a int, b json, c json);
insert into t values(1, json_object('a','b'), '["c", "d"]');
with cte as (select b, c, json_merge(b, c) as d from t join (select json_object('key','c')) as dd on 1=1) select json_extract(d, '/1')||json_extract(d,'2') from cte;
drop table if exists t3;
create table t3(a char);
insert into t3 values('a');
with cte as (select json_array(a), json_array(json_object('{"a","c"}', a)) as b from t3) select json_valid(json_extract(b, '/0')) from cte;

drop table if exists t;
create table t(j json);
set @js=
N'[  
       { "id" : 2,"info": { "name": "John", "surname": "Smith" }, "age": 25 },  
       { "id" : 5,"info": { "name": "Jane", "surname": "Smith" }, "dob": "2005-11-04T12:00:00" }  
 ]' ;
select json_extract(@js,'/0/info') union select json_array('["a", "b"]') union select json_extract(j,'/0/info') from t;
with cte as (select json_extract(@js,'/0/info') union select json_array('["a", "b"]') union select json_extract(j,'/0/info') from t) select * from cte;
with cte(a) as (select json_extract(@js,'/0/info') union select json_array('["a", "b"]') union select json_extract(j,'/0/info') from t) select json_extract(a, '/surname') from cte where json_extract(a, '/surname') is not null;
with cte1(a) as (select json_extract(@js,'/0/info')), 
     cte2(b) as (select json_extract(a, '/surname') from cte1),
     cte3(c) as (select a from cte1 union all select b from cte2 join cte3 on cte3.c=cte2.b ) select * from cte3;

drop table if exitst customer_area_node;
CREATE TABLE customer_area_node
(
  id int NOT NULL,
  customer_id integer NOT NULL,
  parent_id int,
  name varchar,
  description json,

  CONSTRAINT customer_area_node_pkey PRIMARY KEY (id)
);

insert into customer_area_node values(1, 1, 1, 'John', '
{
    "id": "https://docs.atlassian.com/jira/REST/schema/error-collection#",
    "title": "Error Collection",
    "type": "object",
    "properties": {
        "errorMessages": {
            "type": "array",
            "items": {
                "type": "string"
            }
        },
        "errors": {
            "type": "object",
            "patternProperties": {
                ".+": {
                    "type": "string"
                }
            },
            "additionalProperties": false
        },
        "status": {
            "type": "integer"
        }
    },
    "additionalProperties": false
}');

insert into customer_area_node values(2, 3, 5, 'John', '
{
    "id": "https://docs.atlassian.com/jira/REST/schema/error-collection#",
    "title": "Error Collection",
    "type": "object",
    "properties": {
        "errorMessages": {
            "type": "array",
            "items": {
                "type": "string"
            }
        },
        "errors": {
            "type": "object",
            "patternProperties": {
                ".+": {
                    "type": "string"
                }
            },
            "additionalProperties": false
        },
        "status": {
            "type": "integer"
        }
    },
    "additionalProperties": false
}');

insert into customer_area_node values(3, 2, 1, 'John', '
{
    "id": "https://docs.atlassian.com/jira/REST/schema/error-collection#",
    "title": "Error Collection",
    "type": "object",
    "properties": {
        "errorMessages": {
            "type": "array",
            "items": {
                "type": "string"
            }
        },
        "errors": {
            "type": "object",
            "patternProperties": {
                ".+": {
                    "type": "string"
                }
            },
            "additionalProperties": false
        },
        "status": {
            "type": "integer"
        }
    },
    "additionalProperties": false
}');

insert into customer_area_node values(4, 3, NULL, 'John', '
{
    "id": "https://docs.atlassian.com/jira/REST/schema/error-collection#",
    "title": "Error Collection",
    "type": "object",
    "properties": {
        "errorMessages": {
            "type": "array",
            "items": {
                "type": "string"
            }
        },
        "errors": {
            "type": "object",
            "patternProperties": {
                ".+": {
                    "type": "string"
                }
            },
            "additionalProperties": false
        },
        "status": {
            "type": "integer"
        }
    },
    "additionalProperties": false
}');

insert into customer_area_node values(5, 2, NULL, 'John', '
{
    "id": "https://docs.atlassian.com/jira/REST/schema/error-collection#",
    "title": "Error Collection",
    "type": "object",
    "properties": {
        "errorMessages": {
            "type": "array",
            "items": {
                "type": "string"
            }
        },
        "errors": {
            "type": "object",
            "patternProperties": {
                ".+": {
                    "type": "string"
                }
            },
            "additionalProperties": false
        },
        "status": {
            "type": "integer"
        }
    },
    "additionalProperties": false
}');

WITH RECURSIVE c AS ( 
	SELECT *, 0 as lv, name as path FROM customer_area_node WHERE customer_id = 2 and parent_id is null  
	UNION ALL  SELECT customer_area_node.*, c.lv + 1 as lv, c.path || '/' || customer_area_node.name as path FROM customer_area_node 
        join c ON customer_area_node.parent_id = c.id 
	) SELECT * FROM c ORDER BY path;

WITH RECURSIVE c AS (SELECT *, 0 as lv, name as path FROM customer_area_node WHERE customer_id = 2 and parent_id is null  
	UNION ALL  SELECT customer_area_node.*, c.lv + 1 as lv, c.path || '/' || customer_area_node.name as path FROM customer_area_node  
        join c ON customer_area_node.parent_id = c.id) 
	SELECT json_extract(description, '/properties/status') FROM c ORDER BY path;

WITH RECURSIVE c AS (SELECT *, 0 as lv, name as path, json_extract(description, '/properties/error/type') as descr FROM customer_area_node WHERE customer_id = 2 and parent_id is null UNION ALL  SELECT customer_area_node.*, c.lv + 1 as lv, c.path || '/' || customer_area_node.name as path, json_extract(c.description, '/additionalProperties') as descr FROM customer_area_node  
        join c ON customer_area_node.parent_id = c.id) 
	SELECT json_extract(description, '/properties/status') FROM c ORDER BY path;

drop table if exists customer_area_node;

drop table if exists t;
drop table if exists t3;
drop VARIABLE @js;



--+ holdcas off;
