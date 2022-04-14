autocommit off;
select name, set(select room.size_in_sq_ft
		 from table(rooms) as t(room))
from public.resort;
/*
Yields
  name                  set((select room.size_in_sq_ft from table(rooms)  t (room)))
============================================
  'Couples'             {}                  
  'Carlyle on the Bay'  {}                  
  'Boscobel Beach'      {}                  
  'Nassau Beach Club Resort'  {}                  
  'Divi Bahamas beach resort & Country Club'  {}                  
  'Carnival's Crystal Palace Resort & Casino'  {}                  
  'British Colonial Beach Resort'  {}                  
  'Francois Plantation Inn'  {}                  
  'Nisbet Plantation Beach Club'  {}                  
  'Holiday Inn Aruba Beach Resort'  {}                  
  'Richard Bransson's Necker Island'  {}                  
  'Club Med Caravelle'  {}                  
  'Hyatt Regency Aruba Resort And Casino'  {}                  
  'Hedonism II'         {}                  
  'Tryall Golf, Tennis, and Beach Club'  {}                  
  'Seawind Beach Resort'  {}                  
but ought to have numbers in at least some of the sets.
 */
rollback;
