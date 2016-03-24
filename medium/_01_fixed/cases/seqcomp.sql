autocommit off;
create class foo ( a sequence int );
insert into foo default;
insert into foo values ( {} );
insert into foo values ( {NULL} );
insert into foo values ( {1} );
insert into foo values ( {5} );
insert into foo values ( {1,5} );
insert into foo values ( {1,3} );
insert into foo values ( {1,2,3} );
select * from foo 
order by a;
select * from foo  where a < {1,5} 
order by a;
rollback;
