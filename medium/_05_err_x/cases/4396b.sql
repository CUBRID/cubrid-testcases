autocommit off;
create class parent2 ( attr double );
create class child as subclass of parent1, parent2
inherit attr of parent1 as aliased_attr;
rollback;
