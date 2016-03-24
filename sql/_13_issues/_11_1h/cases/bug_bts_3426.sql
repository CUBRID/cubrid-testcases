create table foo ( a integer, b numeric (3,0));
insert into foo values ( 1, ROUND(CAST(to_datetime('20100716210000', 'YYYYMMDDHH24MISS')- to_datetime('20100716193000', 'YYYYMMDDHH24MISS') AS integer )/ 60 / 60.0/1000));
select * from foo;
update foo set b = ROUND(CAST(to_datetime('20100716210000', 'YYYYMMDDHH24MISS')- to_datetime('20100716193000', 'YYYYMMDDHH24MISS') AS integer )/ 60 / 60.0/1000) where a = 1;
select * from foo;

drop table foo;
