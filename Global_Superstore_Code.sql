/*Create an empty database*/
.open --new "c:/ucf_classes/eco_4443/sql/databases/Global_Superstore.db"

/*Create new tables called People*/

CREATE TABLE People
(
Person Text ,
Region Text ,
Primary Key (Region)
)
;

.tables

/*import the data into the People table*/

.separator ,
.import --csv c:/ucf_classes/eco_4443/sql/data/people_global.csv People

/*adjust how the output is displayed*/
.mode column

/*Query the database*/
SELECT Person, Region
FROM People ;


/*Create the Returned Table*/
CREATE TABLE Returned
(
Returned Text ,
`Order ID` Text ,
Primary Key (`Order ID`)
)
;

.import --csv c:/ucf_classes/eco_4443/sql/data/returns.csv Returned
SELECT `Order ID`
FROM Returned ;

/* Create an Orders Table*/

CREATE TABLE Orders
(
`Row ID`		Integer ,
`Order ID`		Text ,
`Order Date`	Text ,
`Ship Date`		Text ,
`Ship Mode`		Text ,
`Customer ID`	Text ,
`Customer Name` Text ,
Segment		    Text ,
City		    Text ,
`State`			Text ,
Country		    Text ,
`Postal Code`	Text ,
Market          Text ,
Region		    Text ,
`Product ID`	Text ,
`Category`		Text ,
`Sub-Category`	Text ,
`Product Name`	Text ,
`Sales`			Real ,
`Quantity`		Integer ,
`Discount`		Real ,
`Profit`        Real ,
Shipping Cost	Real ,
Order priority  Text ,
PRIMARY KEY (`Row ID`)
FOREIGN KEY (Region) REFERENCES People (Region)
FOREIGN KEY ('Order ID') REFERENCES Returned (`Order ID`)
)
;

.separator ;
.import --csv c:/ucf_classes/eco_4443/sql/data/orders_global.csv Orders

/*display all tables created*/
.tables
.schema

.mode column
.headers on

/* PART C: Identify the countries contained in the database and the numbers of sales originating from each country over the years*/

SELECT Country ,
COUNT(*) AS "Number of Sales"
FROM Orders
GROUP BY Country
ORDER BY "Number of Sales"
DESC
;

/* PART D:  Modify the query in Part C to identify the countries with X, Y, or Z in their names*/

SELECT Country ,
COUNT(*) AS "Number of Sales"
FROM Orders
WHERE Country LIKE '%X%'
OR Country LIKE '%Y%'
OR Country LIKE '%Z%'
GROUP BY Country
ORDER BY "Number of Sales"
DESC
;

/* PART E: Modify the query in Part D to find the total profit and profit per sale over the period. 
           Round to 2 decimals places and assign the aliases to 'Total Profit' and 'Profit Per Sale'.
           Place in descending order by 'Profit Per Sale'. */

SELECT Country , Profit , Sales ,
COUNT(*) AS "Number of Sales" ,
Round(SUM(Profit), 2) AS "Total Profit" ,
round(Profit/Sales, 2) AS "Profit Per Sale"
FROM Orders
WHERE Country LIKE '%X%'
OR Country LIKE '%Y%'
OR Country LIKE '%Z%'
GROUP BY Country
ORDER BY "Profit Per Sale"
DESC
;

/* PART F: Modify the query in part E to identify countries whose total profit or profit per unit is negative*/
SELECT Country, Profit, Sales
COUNT(*) AS "Number of Sales" ,
ROUND(SUM(Profit), 2) AS "Total Profit" ,
ROUND(Profit/Sales, 2) AS "Profit Per Sale" 
FROM Orders
WHERE Country LIKE '%X%'
OR Country LIKE '%Y%'
OR Country LIKE '%Z%'
GROUP BY Country
HAVING SUM('Profit') < 0
OR SUM((Profit/Sales)) < 0
ORDER BY "Profit Per Sale"
ASC
;

/*Show the first 3 rows of the Orders table to show which countries have the highest number of sales*/
SELECT Country ,
COUNT(*) AS "Number of Sales"
FROM Orders
GROUP BY Country
ORDER BY "Number of Sales"
DESC
LIMIT 3
;

/* PART G: Query the database to determine the following over all periods for United States, Australia, and France:
            Quantity of Sales, 
            Total Sales Revenue,
            Sales Revenue Per Unit, 
            Total Profit,
            Profit Per Unit
*/

SELECT Country ,
COUNT(*) AS "Quantity of Sales" , 
ROUND(SUM(Sales), 2) AS "total Sales Revenue" ,
SUM(Quantity) AS "Total Units Sold" ,
ROUND(SUM(Sales) / SUM(Quantity) , 2) AS "Sales Revenue Per Unit" ,
ROUND(SUM(Profit), 2) AS "Total Profit" ,
ROUND(SUM(Profit) / SUM(Quantity) , 2) AS "Profit Per Unit"

FROM Orders
WHERE Country LIKE '%United States%'
OR Country LIKE '%Australia%'
OR Country LIKE '%France%'
GROUP BY Country
ORDER BY "Quantity of Sales"
DESC
;

/* PART F ----> Modify Part G: Find the following on an Annual Basis
                Quantity of Sales
                Total Sales Revenue
                Sales Revenue Per Unit
                Total Profit
                Profit Per Unit

*/

SELECT Country ,
SUBSTR(`Order Date`, -4, 4) AS Year ,
COUNT(*) AS "Quantity of Sales" ,
ROUND(SUM(Sales) , 2) AS "Total Sales Revenue" , 
SUM(Quantity) AS "Total Quantity" , 
ROUND(SUM(Sales) / SUM(Quantity) , 2) AS "Sales Revenue Per Unit" , 
ROUND(SUM(Profit) , 2) AS "Total Profit" , 
ROUND(SUM(Profit) / SUM(Quantity) , 2) AS "Profit Per Unit"

FROM Orders
WHERE Country LIKE '%United States%'
OR Country LIKE '%Australia%'
OR Country LIKE '%France%'
GROUP BY Country , Year
;

/* PART I ----> Modify Part H: Monthly basis within each year in ascending order*/

SELECT Country ,
SUBSTR(`Order Date`, -4, 4) AS Year ,
CAST(RTRIM(SUBSTR(`Order Date`, 1, 2), '/') AS Integer) AS Month ,
COUNT(*) AS "Quantity of Sales" ,
ROUND(SUM(Sales) , 2) AS "Total Sales Revenue" , 
SUM(Quantity) AS "Total Quantity" , 
ROUND(SUM(Sales) / SUM(Quantity) , 2) AS "Sales Revenue Per Unit" , 
ROUND(SUM(Profit) , 2) AS "Total Profit" , 
ROUND(SUM(Profit) / SUM(Quantity) , 2) AS "Profit Per Unit"

FROM Orders
WHERE Country LIKE '%United States%'
OR Country LIKE '%Australia%'
OR Country LIKE '%France%'
GROUP BY Country , Year, Month
ORDER BY "Quantity of Sales"
ASC
;

/* PART J ----> Modify Query in Part I: Show results in ascending order by region over all periods*/

SELECT Region ,
COUNT(*) AS "Quantity of Sales" ,
ROUND(SUM(Sales) , 2) AS "Total Sales Revenue" , 
SUM(Quantity) AS "Total Quantity" , 
ROUND(SUM(Sales) / SUM(Quantity) , 2) AS "Sales Revenue Per Unit" , 
ROUND(SUM(Profit) , 2) AS "Total Profit" , 
ROUND(SUM(Profit) / SUM(Quantity) , 2) AS "Profit Per Unit"

FROM Orders
GROUP BY Region
ORDER BY "Quantity of Sales"
ASC
;

/* PART K ----> Modify PART J: Report results by region on an annual basis*/

SELECT Region ,
SUBSTR(`Order Date`, -4, 4) AS Year ,
COUNT(*) AS "Quantity of Sales" ,
ROUND(SUM(Sales) , 2) AS "Total Sales Revenue" , 
SUM(Quantity) AS "Total Quantity" , 
ROUND(SUM(Sales) / SUM(Quantity) , 2) AS "Sales Revenue Per Unit" , 
ROUND(SUM(Profit) , 2) AS "Total Profit" , 
ROUND(SUM(Profit) / SUM(Quantity) , 2) AS "Profit Per Unit"

FROM Orders
WHERE Country LIKE '%United States%'
OR Country LIKE '%Australia%'
OR Country LIKE '%France%'
GROUP BY  Region
;

/* PART L ----> Modify PART K: Report results by region and by person on an annual basis; Join Orders and People Table */

SELECT 
O.Region , P.Person ,
SUBSTR(`Order Date`, -4, 4) AS Year ,
P.Region ,

COUNT(*) AS "Quantity of Sales" ,
ROUND(SUM(Sales) , 2) AS "Total Sales Revenue" , 
SUM(Quantity) AS "Total Quantity" , 
ROUND(SUM(Sales) / SUM(Quantity) , 2) AS "Sales Revenue Per Unit" , 
ROUND(SUM(Profit) , 2) AS "Total Profit" , 
ROUND(SUM(Profit) / SUM(Quantity) , 2) AS "Profit Per Unit"

FROM Orders AS O
JOIN People AS P
ON O.Region = P.Region

GROUP BY 
P.Region , P.Person
ORDER BY "Quantity of Sales"
ASC
;

/* PART M: Join all three tables (People, Orders, and Returned) and determine lost profit from
            Returned Items ,
            Per Item Returned
            Order by Region and Person over all years
*/
.tables

SELECT 
O.Region ,
P.Person ,

COUNT(O.`Order ID`) AS "Number of Sales" , 
ROUND(SUM(O.Sales), 2) AS "Total Sales" ,
SUM(CASE WHEN R.Returned = 'Yes' THEN  1.0 ELSE 0 END) AS "Number of Items Returned" ,
ROUND(SUM(CASE WHEN R.Returned  = 'Yes' THEN  1.0 ELSE 0 END), 2) AS "Number of Items Returned" 

FROM Orders AS O
JOIN People AS P
ON O.Region = P.Region

JOIN Returned AS R
ON O.`Order ID` = R.`Order ID`

GROUP BY O.Region , P.Person
;

/* Export Query from PART M into a csv and save it to the intermediate folder*/

.headers on
.mode csv
.output c:/ucf_classes/intermediate/lost_profits_by_region.csv 

SELECT 
O.Region ,
P.Person ,

COUNT(O.`Order ID`) AS "Number of Sales" , 
ROUND(SUM(O.Sales), 2) AS "Total Sales" ,
SUM(CASE WHEN R.Returned = 'Yes' THEN  1.0 ELSE 0 END) AS "Number of Items Returned" ,
ROUND(SUM(CASE WHEN R.Returned  = 'Yes' THEN  1.0 ELSE 0 END), 2) AS "Number of Items Returned" 

FROM Orders AS O
JOIN People AS P
ON O.Region = P.Region

JOIN Returned AS R
ON O.`Order ID` = R.`Order ID`

GROUP BY O.Region , P.Person
;

.output stdout

/* PART N: Demonstrate at least additional SQL commands from personal research using the Global_Superstore.db */

/* First Command: Place the countries in alphabetical order with the number of orders using */

.mode column
.headers on

SELECT
ROW_NUMBER() OVER (ORDER BY Country) AS No, Country AS "Exporting Country" ,
COUNT(*) AS "Order Count"

FROM Orders
WHERE Country IS NOT NULL
GROUP BY Country
ORDER BY Country
LIMIT 10
;

/*Second Command: Report the number of different countries included in the orders table without including duplicates */

SELECT 
COUNT(DISTINCT Country) AS "Different Countries"
FROM Orders
;

/*Third Command: Report the first and last day the United States made an order in the most recent year using the MIN and MAX command */

.width 20 20

SELECT Country, `Order ID`, 
MIN(`Order Date`) AS "First Order Date",
MAX(`Order Date`) AS "Last Order Date"
FROM Orders
WHERE Country = 'United States'
;
























