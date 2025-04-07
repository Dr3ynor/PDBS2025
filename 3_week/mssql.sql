select * from ORDERITEM where UNIT_PRICE < 300;


SET SHOWPLAN_TEXT ON;
select count(*) from ORDERITEM where UNIT_PRICE < 300;
SET SHOWPLAN_TEXT OFF;



SET STATISTICS TIME ON;
select count(*) from ORDERITEM where UNIT_PRICE < 300;
SET STATISTICS TIME OFF;


create or alter procedure PrintPagesIndex @indexName varchar(30)
as
  select
    i.name as IndexName,
    p.rows as ItemCounts,
    sum(a.total_pages) as TotalPages,
    round(cast(sum(a.total_pages) * 8 as float) / 1024, 1)
      as TotalPages_MB,
    sum(a.used_pages) as UsedPages,
    round(cast(sum(a.used_pages) * 8 as float) / 1024, 1)
      as UsedPages_MB
  from sys.indexes i
  inner join sys.partitions p on i.object_id = p.OBJECT_ID and i.index_id = p.index_id
  inner join sys.allocation_units a on p.partition_id = a.container_id
  where i.name = @indexName
  group by i.name, p.Rows
  order by i.name
go



exec PrintPagesHeap 'OrderItem'

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT COUNT(*) FROM ORDERITEM WHERE UNIT_PRICE < 300;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

-------------------- 3.2. ------------------------------------------------
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT * FROM ORDERITEM WHERE UNIT_PRICE < 300 OPTION (MAXDOP 1);

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


-------------------- 3.3. ------------------------------------------------
