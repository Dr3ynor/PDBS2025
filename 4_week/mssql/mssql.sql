SELECT lname, fname, residence, COUNT(*) AS pocet_zaznamu
FROM Customer
GROUP BY lname, fname, residence;

SELECT lname, fname, COUNT(*) AS pocet_zaznamu
FROM Customer
GROUP BY lname, fname;

SELECT lname, residence, COUNT(*) AS pocet_zaznamu
FROM Customer
GROUP BY lname, residence;



set statistics time on;
set statistics time off;
set statistics io on;
set statistics io off;
set showplan_text on; --   |--Table Scan(OBJECT:([RUZ0096].[dbo].[Customer]), WHERE:([RUZ0096].[dbo].[Customer].[lName] like 'Kučerová' AND [RUZ0096].[dbo].[Customer].[fName] like 'Věra' AND [RUZ0096].[dbo].[Customer].[residence] like 'Bohumín'))
set showplan_text off;

-- showplan pro index
--"  |--Nested Loops(Inner Join, OUTER REFERENCES:([Bmk1000], [Expr1003]) WITH UNORDERED PREFETCH)"
--"       |--Index Seek(OBJECT:([RUZ0096].[dbo].[Customer].[CUSTOMER_NAME_RES]), SEEK:([RUZ0096].[dbo].[Customer].[lName] >= 'Kučerová' AND [RUZ0096].[dbo].[Customer].[lName] <= 'Kučerová'),  WHERE:([RUZ0096].[dbo].[Customer].[lName] like 'Kučerová' AND [RUZ0096].[dbo].[Customer].[fName] like 'Věra' AND [RUZ0096].[dbo].[Customer].[residence] like 'Bohumín') ORDERED FORWARD)"
--"       |--RID Lookup(OBJECT:([RUZ0096].[dbo].[Customer]), SEEK:([Bmk1000]=[Bmk1000]) LOOKUP ORDERED FORWARD)"



select *
from CUSTOMER
where lname like 'Kučerová' and fname like 'Věra' and residence like 'Bohumín'
option (maxdop 1);

CREATE INDEX CUSTOMER_NAME_RES ON CUSTOMER(LNAME, FNAME, RESIDENCE);

select name, s.index_depth - 1 as height, s.index_level as level, s.page_count as page_count, s.record_count as record_count,
  s.avg_record_size_in_bytes as avg_record_size,
  round(s.avg_page_space_used_in_percent,1) as page_utilization,
  round(s.avg_fragmentation_in_percent,2) as avg_frag
from sys.dm_db_index_physical_stats(DB_ID(N'RUZ0096'), OBJECT_ID(N'Customer'), NULL, NULL , 'DETAILED') s
join sys.indexes i on s.object_id=i.object_id and s.index_id=i.index_id
where name='CUSTOMER_NAME_RES'

SELECT MIN(record_count) AS min_count, MAX(record_count) AS max_count
FROM (
    SELECT LNAME, FNAME, COUNT(*) AS record_count
    FROM CUSTOMER
    GROUP BY LNAME, FNAME
) subquery
option (maxdop 1);


exec PrintPagesHeap 'Customer';
exec PrintPagesIndex 'CUSTOMER_NAME_RES';
