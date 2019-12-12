drop class if exists Z, W;

create class Z (zs string);
create class W (wz Z);
insert into W values (NULL);
insert into W values (NULL);
select /*+ RECOMPILE */ *  from W where wz.zs is null;

drop class if exists Z, W;

create class Z (zs string);
create class W (wz Z);
insert into W values (NULL);
insert into W values (NULL);
insert into W values (insert into z values('aaa'));
select /*+ RECOMPILE */ * from W where wz.zs is null;  

drop class if exists Z, W;
