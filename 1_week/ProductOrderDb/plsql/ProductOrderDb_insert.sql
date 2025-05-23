-- ProductOrderDb, A database for Physical Database Design
-- Oracle Version
--
-- Michal Kratky, Radim Baca
-- dbedu@cs.vsb.cz, 2023-2024
-- last update: 2025-02-14

begin
generate_customers();
generate_products();
generate_stores();
generate_staff();
end;



create index staff_idStore_idx on Staff(idStore);
begin
    generate_orders();
end;
drop index staff_idStore_idx;
