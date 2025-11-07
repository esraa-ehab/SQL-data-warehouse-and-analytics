PRINT '==================================================================';
PRINT ' Intiating data transformation - loading data in the silver layer';
PRINT '==================================================================';
PRINT 'Transforming and lading CRM customer data' ;
:r ./scripts/silver_layer/crm_explore_transform/customer_info_transformation.sql
PRINT 'Transforming and lading CRM product data';
:r ./scripts/silver_layer/crm_explore_transform/product_info_transformation.sql
PRINT 'Transforming and lading CRM sales data';
:r ./scripts/silver_layer/crm_explore_transform/sales_info_transformation.sql
PRINT 'Transforming and lading ERP customer data';
:r ./scripts/silver_layer/erp_explore_transform/customer_az_transform.sql
PRINT 'Transforming and lading ERP location data';
:r ./scripts/silver_layer/erp_explore_transform/erp_location_cat_transform.sql
PRINT 'Transforming and lading ERP product-category data';
:r ./scripts/silver_layer/erp_explore_transform/erp_cat_transform.sql
