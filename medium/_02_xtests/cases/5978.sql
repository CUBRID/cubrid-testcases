autocommit off;
create class Z (zs string);
create class W (wz Z)
	method class set_opt(string, string) function qo_set_cost;
insert into W values (NULL);
insert into W values (NULL);

call set_opt('temp', '0') on class W;
call set_opt('m-join', '0') on class W;
call set_opt('nl-join', 'd') on class W;
call set_opt('follow', 'd') on class W;
select W from all W where wz is null;
select W from all W where wz.zs is null;

call set_opt('temp', 'd') on class W;
call set_opt('m-join', 'd') on class W;
call set_opt('nl-join', '0') on class W;
call set_opt('follow', 'd') on class W;
select W from all W where wz is null;
select W from all W where wz.zs is null;
call set_opt('temp', 'd') on class W;
call set_opt('m-join', 'd') on class W;
call set_opt('nl-join', 'd') on class W;
call set_opt('follow', '0') on class W;
select W from all W where wz is null;
select W from all W where wz.zs is null;
rollback;
