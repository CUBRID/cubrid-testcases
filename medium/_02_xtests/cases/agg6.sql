autocommit off;
select 2.5 * avg(quantity)
from joe.shipment_c
where original_loc like '%ris' or
      original_loc like '%les';
      
rollback;
