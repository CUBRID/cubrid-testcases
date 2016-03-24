--+ holdcas on;
--error of index skip order
set  system parameters 'dont_reuse_heap_file=yes';

create class xoo ( a int, b int, c int);
create index idx1 on xoo(a asc, b desc, c asc);
create index idx2 on xoo(a desc, b desc, c desc);

insert into xoo values(1,100, 30);
insert into xoo values(1, 200, 20);
insert into xoo values(30, 300, 10);
insert into xoo values(100, 0, 10);
insert into xoo values(1, 200, 30);
insert into xoo values(1, 200, 20);
insert into xoo values(1, 0, 1);



update statistics on xoo;

select /*+ USE_IDX */ a,b,c from xoo 
where a = 1 and b =200 and c > 1 order by b desc, c desc for orderby_num() between 1 and 10;
select /*+ USE_IDX */ a,b,c from xoo 
where a = 1 and b =200 and c > 1 order by b desc, c desc ;

select /*+ USE_IDX */ a,b,c from xoo 
where a = 1 and b =200 and c > 1  order by a asc, b desc, c desc  for orderby_num() between 1 and 10;
select /*+ USE_IDX */ a,b,c from xoo 
where a = 1 and b =200 and c > 1  order by a asc, b desc, c desc ;

select /*+ USE_IDX */ a,b,c from xoo 
where a = 1 and b >100 and c > 1  order by a asc, b desc, c desc  for orderby_num() between 1 and 10;
select /*+ USE_IDX */ a,b,c from xoo 
where a = 1 and b >100 and c > 1  order by a asc, b desc, c desc ;

select  a,b,c from xoo 
where a = 1 and b >100 and c > 1  order by a asc, b desc, c desc  for orderby_num() between 1 and 10;
select  a,b,c from xoo 
where a = 1 and b >100 and c > 1  order by a asc, b desc, c desc ;

drop xoo;
set  system parameters 'dont_reuse_heap_file=no';

commit;
--+ holdcas off;
