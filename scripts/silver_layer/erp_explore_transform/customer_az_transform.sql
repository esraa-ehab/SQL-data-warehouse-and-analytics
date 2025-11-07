TRUNCATE TABLE silver.erp_customer
INSERT INTO silver.erp_customer(cid, bdate, gen)
SELECT  
    CASE 
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
        ELSE cid
    END AS cid
    , CASE 
        WHEN bdate > GETDATE() THEN NULL
        ELSE bdate
    END AS bdate
    , CASE 
        WHEN UPPER(TRIM(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''))) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''))) IN ('M', 'MALE') THEN 'Male'
        ELSE 'Unknown'
    END AS gen
FROM bronze.erp_customer