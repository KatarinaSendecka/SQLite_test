-task1
With C AS
	(SELECT *
     FROM company
     GROUP BY company_number)

SELECT 
	c.company_name, 
    b.company_code, 
    p.product_name, 
    b.product_code 
FROM 
	bridge b 
    JOIN C c ON b.COMPANY_CODE=c.COMPANY_NUMBER 
    JOIN products p ON b.PRODUCT_CODE=p.PRODUCT_CODE 
WHERE 
	b.end_date ISNULL AND p.END_DATE ISNULL;

--task2
With C AS
	(SELECT *
     FROM company
     GROUP BY company_number),
	T AS 
	(SELECT
     	p.PRODUCT_CODE,
     	volume,
     	company_name,
     	s.COMPANY_CODE
     FROM 
     	products p 
     	LEFT JOIN sales s ON p.PRODUCT_CODE=s.PRODUCT_CODE 
    	LEFT JOIN C c ON s.COMPANY_CODE=c.COMPANY_NUMBER)
        
SELECT 
	PRODUCT_CODE,
	COMPANY_CODE, 
    COMPANY_NAME, 
    
  CASE 
      WHEN VOLUME ISNULL THEN 'No sells'
      WHEN VOLUME <= 4000 THEN 'Low sells'
      WHEN 4001 <= VOLUME <= 200000 THEN 'Medium sells'
      WHEN VOLUME >= 200001 THEN 'High sells'
  END AS Sells
FROM T
GROUP BY
	product_code,
    company_code

--task3
WITH C AS
	(SELECT *
     FROM company
     GROUP BY company_number),
     T1 AS
	(SELECT 
     	CLIENT_NUMBER 
	 FROM 
     	sales
     WHERE 
     	PRODUCT_CODE = 1 
     GROUP BY 
     	client_number)
        
SELECT 
 	s.CLIENT_NUMBER,
    s.PRODUCT_CODE,
    s.COMPANY_CODE, 
    c.COMPANY_NAME 
FROM 
 	sales s
    LEFT JOIN C c ON s.COMPANY_CODE=c.COMPANY_NUMBER 
WHERE 
	s.CLIENT_NUMBER NOT IN T1 AND s.PRODUCT_CODE = 10 OR s.PRODUCT_CODE = 5 OR s.PRODUCT_CODE = 2  

--task4
SELECT
	p.PRODUCT_NAME, 
    s.product_code, 
    s.volume, 
    strftime('%Y',s.SALES_DATE) AS YearSales, 
    company_code 
FROM 
	sales s 
    JOIN products p ON s.PRODUCT_CODE=p.PRODUCT_CODE
WHERE NOT 
	s.VOLUME='0' 
GROUP BY 
	company_code,
    YearSales 
ORDER BY 
	s.product_code ASC, 
    YearSales DESC

--task5
SELECT 
	currency,
    SUM(volume) AS SumVolume, 
    (SUM(volume)*100)/(SELECT SUM(volume) FROM sales) AS PCT 
FROM 
	sales
GROUP BY 
	currency