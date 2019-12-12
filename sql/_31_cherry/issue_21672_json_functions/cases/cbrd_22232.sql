drop table if exists tj;
create table tj (s1 char(100), s2 char(100), s3 char(100));
insert into tj values ('xxxxx', '{"a": 1, "b": {"c": 30}}', 'xxxxx');
select json_keys(s2) from tj;
drop table if exists tj;
