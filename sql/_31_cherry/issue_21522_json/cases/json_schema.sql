drop table if exists t1,t2;
create table t1 (a int, b json('{
  "type": "object",
  "properties": {
    "title": { "type": "string" }
  }
}'));

create table t2 as select * from t1;

drop table if exists t1,t2;
create table t1 (a int, b json('{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "User",
  "description": "demo schema",
  "type": "object",
  "properties": {
    "firstName": {
      "type": "string"
    },
    "LastName": {
      "type": "string"
    },
    "age": {
      "description": "Age in years",
      "type": "integer",
      "minimum": 0
    }
  },
  "required": [
    "firstName",
    "LastName"
  ]
}'));
insert into t1 values (1, '{"age":20}'); 
insert into t1 values (1, '{"firstName":"J","LastName":"Jane","age":20}'); 
insert into t1 values (2, '{"firstName":"J","LastName":"Jane"}');
insert into t1 values (2, '{"firstName":"J"}');
select * from t1 order by b;
create table t2 as select * from t1;
alter table t2 modify a json('{
  "checked": false,
  "dimensions": {
    "width": 5,
    "height": 10
  },
  "id": 1,
  "name": "A green door",
  "price": 12.5,
  "tags": [
    "home",
    "green"
  ]
}');
show create table t2;
select *, typeof(b),json_type(b) from t2 order by b;
drop table if exists t1,t2;
