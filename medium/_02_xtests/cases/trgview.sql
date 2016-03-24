autocommit off;
create class c1 (x integer, y integer default 10, z integer default 20);
create vclass v1 (a integer default 42, b, c) as 
  select x + 10, y, z + 20 from c1;
create trigger t1 
  after update on c1
  if obj.x = 100
  execute print 'x is 100';
insert into v1 default values;
update v1 set a = 110;
rollback work;
rollback;
