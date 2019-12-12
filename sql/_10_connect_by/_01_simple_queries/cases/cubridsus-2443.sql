--this cases was added for cubridsus-2443
Create table hxoo ( a int, b int);
Insert into hxoo values(1, null);
Insert into hxoo values(2, 3);
Insert into hxoo values(3, 4);
Insert into hxoo values(4, 5);
Insert into hxoo values(1, null);
select a, sys_connect_by_path(b,'/') from hxoo start with a= 1 connect by a = b;
drop hxoo;

