autocommit off;
select na from db_user where na <> na+1 and na seteq na;
rollback;
