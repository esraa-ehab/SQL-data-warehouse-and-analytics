PRINT '=============================================';
PRINT ' Creating business-ready views - gold layer';
PRINT '=============================================';
PRINT '>> Creating customer dimension view';
GO
:r ./scripts/gold_layer/customer_dimension.sql 
GO

PRINT '>> Creating new products dimension view'; 
GO
:r ./scripts/gold_layer/current_product_dimension.sql 
GO

PRINT '>> Creating old products dimension view';
GO
:r ./scripts/gold_layer/old_product_dimension.sql 
GO

PRINT '>> Creating sales fact view'; 
GO
:r ./scripts/gold_layer/sales_fact.sql
GO