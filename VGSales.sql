SELECT *
FROM video_game..vgsales


--SELECT THE TOP 100 OF THE GENRES I ENJOY THE MOST
SELECT TOP 100 
	rank, 
	name,
	genre,
	publisher,
	global_sales
FROM video_game..vgsales
WHERE genre = 'Sports'
ORDER BY global_sales DESC

SELECT TOP 100 
	rank, 
	name, 
	genre, 
	publisher, 
	global_sales
FROM video_game..vgsales
WHERE genre = 'Action'
ORDER BY global_sales DESC


SELECT TOP 100 
	rank, 
	name, 
	genre, 
	publisher, 
	global_sales
FROM video_game..vgsales
WHERE genre = 'Adventure'
ORDER BY global_sales DESC


--COUNT THE TOTAL NUMBER OF PUBLISHERS
SELECT TOP 100 
	publisher, 
	COUNT(*) AS num_games
FROM video_game..vgsales
GROUP BY publisher
ORDER BY num_games DESC;

--TOP 100 PUBLISHERS RANKED BY SALES
SELECT TOP 100 
	publisher, 
	SUM(NA_Sales) AS NA_Total_Sales
FROM video_game..vgsales
GROUP BY publisher
ORDER BY NA_Total_Sales DESC;


SELECT TOP 100 
	publisher, 
	SUM(EU_Sales) AS EU_Total_Sales
FROM video_game..vgsales
GROUP BY publisher
ORDER BY EU_Total_Sales DESC;


SELECT TOP 100 
	publisher, 
	SUM(JP_Sales) AS JP_Total_Sales
FROM video_game..vgsales
GROUP BY publisher
ORDER BY JP_Total_Sales DESC;


SELECT TOP 100 
	publisher, 
	SUM(global_sales) AS Total_Sales
FROM video_game..vgsales
GROUP BY publisher
ORDER BY Total_Sales DESC;


SELECT TOP 100
    publisher,
    SUM(NA_Sales) AS NA_Sales,
    SUM(EU_Sales) AS EU_Sales,
    SUM(JP_Sales) AS JP_Sales,
    SUM(global_sales) AS Global_Sales
FROM video_game..vgsales
GROUP BY publisher
ORDER BY Global_Sales DESC;

--TOTAL GENRES AND GAMES
SELECT genre, COUNT(*) AS num_games
FROM video_game..vgsales
GROUP BY genre
ORDER BY num_games DESC


--TOTAL NUMBER OF GENRES AND SALES
SELECT 
	genre,
	COUNT(genre) AS num_games,
	SUM(global_sales) AS Total_Sales
FROM video_game..vgsales
GROUP BY genre
ORDER BY Total_Sales DESC



