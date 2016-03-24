autocommit off;

create index idx on shipment_v (quantity);
rollback work;
rollback;
