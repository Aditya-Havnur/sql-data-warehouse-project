CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME ; 
	BEGIN TRY
		SET @batch_start_time= GETDATE();
		PRINT '==========================';
		PRINT'Loading the bronze layer';
		PRINT '==========================';

		PRINT '---------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '---------------------------';

		SET @start_time= GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info

		PRINT '>> Inserting Table: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info  -- Bulk Insert (Table name)
		FROM 'C:\Users\Aditya\Downloads\sql-data-warehouse-project-main(Baraa)\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		WITH (
		FIRSTROW =2,
		FIELDTERMINATOR=',',
		TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + 'seconds';
		PRINT '------------------'



		/*
		Truncate empties the contents of the table,
		Bulk insert commands the server to insert into the table
		From points to the data source
		With specifies additional settings or options that control how SQL Server imports the CSV data.
		Fieldterminator tells SQL Server that a comma (,) separates the different columns in the CSV file.
		(If the values were separated by a backslash the delimiter would have been "/"
		Tablock tells the server to lock the table while migrating the data
		*/



		SET @start_time= GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info

		PRINT '>> Inserting Table: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Aditya\Downloads\sql-data-warehouse-project-main(Baraa)\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR =',',
		TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + 'seconds';
		PRINT '------------------'

		SET @start_time= GETDATE()
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details

		PRINT '>> Inserting Table: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Aditya\Downloads\sql-data-warehouse-project-main(Baraa)\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR=',',
		TABLOCK
		);
		SET @end_time=GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + 'seconds';
		PRINT '------------------'

		PRINT '---------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '---------------------------';


		SET @start_time= GETDATE()
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12

		PRINT '>> Inserting Table: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Aditya\Downloads\sql-data-warehouse-project-main(Baraa)\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
		WITH(
		FIRSTROW=2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time= GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + 'seconds';
		PRINT '------------------'

		SET @start_time= GETDATE()
		PRINT '>> Truncating Table: bronze.erp_loc_a1o1';
		TRUNCATE TABLE bronze.erp_loc_a1o1

		PRINT '>> Inserting Table: bronze.erp_loc_a1o1'
		BULK INSERT bronze.erp_loc_a1o1
		FROM 'C:\Users\Aditya\Downloads\sql-data-warehouse-project-main(Baraa)\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
		WITH(
		FIRSTROW =2,
		FIELDTERMINATOR =',',
		TABLOCK
		);
		SET @end_time= GETDATE()
		PRINT 'Loading Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';
		PRINT '------------------'

		SET @start_time= GETDATE()
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2

		PRINT '>> Inserting Table: bronze.erp_px_cat_g1v2'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Aditya\Downloads\sql-data-warehouse-project-main(Baraa)\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
		FIRSTROW =2,
		FIELDTERMINATOR =',',
		TABLOCK
		);
		SET @end_time= GETDATE()
		PRINT 'Loading Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';
		PRINT '------------------'

		SET @batch_end_time= GETDATE();
		PRINT '=========================================='
		PRINT 'Loading of Bronze Layer is completed'
		PRINT '- Total Duration: ' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR) + 'seconds';

	END TRY
	BEGIN CATCH
		PRINT '======================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'ERROR Message' + ERROR_MESSAGE();
		PRINT 'ERROR Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR Message' + CAST(ERROR_STATE() AS NVARCHAR); 
 		PRINT '======================================='
	END CATCH
END

/*

This code is an example of a normal ETL Process, where we create a stored procedure(Re-usable  block of code 
that can be used anytime)
Alter keyword is used always because if the CRM(Source File) is updated with new records, each time the table empties its 
contents in the table and loads again with new Information
Had we used Only Create instead of coupling it with ALter, we could've gotten "The table already exists error"
With Begin and End statements that have the code defined in between them

Then we encapsulate the code with Try & catch statements
We first prompt the Server to try the code within the TRY block, and if it fails for some reason the code with the CATCH block 
starts executing as fallback
Variables are data types that store value and we initialize them by using  the  DECLARE keyword
Declare xyz datatype( In the above example datetime)
 Then start_time represents the loading of one of the table and end_time reprsents the last minute/hour the table took to load
 To Find the difference Datediff is used
 The same is done for the whole batch using @start_batch_time & @end_batch_time
*/
