autocommit off;
alter surplus_stock add class attribute
category string default 'perishables';
rollback;
