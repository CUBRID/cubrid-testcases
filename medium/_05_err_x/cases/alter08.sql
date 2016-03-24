autocommit off;

alter vclass inventory_v modify attribute new_attr string default '10';
rollback work;
rollback;
