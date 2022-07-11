

-- "How many endangered languages are on the brink of extinction?" 
-- The United Nations Education, Scientific and Cultural Organisation (UNESCO) regularly updates and publishes a list of endangered languages, 
-- using a classification system that describes its danger of extinction. The classification - the most severe form of endangerment 
-- ranked first and so forth - is as follows:

 --  1) EXTINCT: There are no speakers left.
 --  2) CRITICALLY ENDANGERED: The youngest speakers are grandparents and older, and they speak the language partially and infrequently.
 --  3) SEVERELY ENDANGERED: Language is spoken by grandparents and older generations; while the parent generation may understand it, 
 --     they do not speak it to children or among themselves.
 --  4) DEFINITELY ENDANGERED: Children no longer learn the language as a 'mother tongue' in the home.
 --  5) VULNERABLE: Most children speak the language, but it may be restricted to certain domains (e.g., home)

USE LANGUAGES
  SELECT * FROM EXTLANGUAGES

SELECT TOP (1000) [ID]
      ,[Name_in_English]
      ,[Name_in_French]
      ,[Name_in_Spanish]
      ,[Countries]
      ,[Country_codes_alpha_3]
      ,[ISO639_3_codes]
      ,[Degree_of_endangerment]
      ,[Alternate_names]
      ,[Name_in_the_language]
      ,[Number_of_speakers]
      ,[Sources]
      ,[Latitude]
      ,[Longitude]
      ,[Description_of_the_location]
  FROM [LANGUAGES].[dbo].[EXTLANGUAGES]
  
 USE LANGUAGES
  SELECT * FROM EXTLANGUAGES
  ORDER BY 1

--ALTER TABLE

ALTER TABLE EXTLANGUAGES DROP COLUMN NAME_IN_FRENCH, NAME_IN_SPANISH, ISO639_3_CODES,
ALTERNATE_NAMES, NAME_IN_THE_LANGUAGE, SOURCES, LATITUDE, LONGITUDE 

ALTER TABLE EXTLANGUAGES ADD SEVERITY int;

UPDATE EXTLANGUAGES SET SEVERITY = 1 WHERE DEGREE_OF_ENDANGERMENT = 'EXTINCT';
UPDATE EXTLANGUAGES SET SEVERITY = 2 WHERE DEGREE_OF_ENDANGERMENT = 'CRITICALLY ENDANGERED';
UPDATE EXTLANGUAGES SET SEVERITY = 3 WHERE DEGREE_OF_ENDANGERMENT = 'SEVERELY ENDANGERED';
UPDATE EXTLANGUAGES SET SEVERITY = 4 WHERE DEGREE_OF_ENDANGERMENT = 'DEFINITELY ENDANGERED';
UPDATE EXTLANGUAGES SET SEVERITY = 5 WHERE DEGREE_OF_ENDANGERMENT = 'VULNERABLE'

ALTER TABLE EXTLANGUAGES ADD NUM_OF_COUNTRIES_LANG_SPOKEN INT;

-- The number of countries where the language is spoken is actually the number of commas + 1 of the string 
----in column Country_codes_alpha_3 because the country codes are separated by commas 
-- Number of comma(s) = LEN(Country_codes_alpha_3) - LEN(REPLACE(Country_codes_alpha_3,',',''))
----------
UPDATE EXTLANGUAGES SET NUM_OF_COUNTRIES_LANG_SPOKEN = LEN(Country_codes_alpha_3) - LEN(REPLACE(Country_codes_alpha_3,',','')) + 1 
FROM EXTLANGUAGES;
----------
Update EXTLANGUAGES set Name_in_English =upper(Name_in_English);

--There are 2722 rows of which 2715 have distinct language names - so 7 duplicate language names 
SELECT COUNT (*) FROM EXTLANGUAGES
SELECT COUNT(DISTINCT Name_in_English) FROM EXTLANGUAGES

-----------------------------------------------------------------------------------------------------------------------------------------------------
--Number of endangered languages for each classification 
SELECT SEVERITY, DEGREE_OF_ENDANGERMENT, COUNT(DEGREE_OF_ENDANGERMENT) AS TOTAL_NUMBER
FROM EXTLANGUAGES GROUP BY DEGREE_OF_ENDANGERMENT,SEVERITY
ORDER BY SEVERITY


--Percentage of endangered languages for each classification 
SELECT SEVERITY, DEGREE_OF_ENDANGERMENT, 
ROUND(CAST((COUNT(DISTINCT NAME_IN_ENGLISH)*100) AS FLOAT)/2715,1) AS PERCENTAGE_TOTAL
FROM EXTLANGUAGES GROUP BY DEGREE_OF_ENDANGERMENT,SEVERITY
ORDER BY SEVERITY
   

--Number of endangered languages of each country/region
SELECT COUNTRY_COUNTRIES, COUNT(DISTINCT NAME_IN_ENGLISH) AS NUMBER_OF_END_LANG FROM EXTLANGUAGES
WHERE COUNTRY_COUNTRIES IS NOT NULL
GROUP BY COUNTRY_COUNTRIES
ORDER BY NUMBER_OF_END_LANG DESC;


--Number of endangered languages that are extinct for each country/region
SELECT COUNTRY_COUNTRIES, COUNT(DISTINCT NAME_IN_ENGLISH) AS EXTINCT_LANG FROM EXTLANGUAGES
WHERE COUNTRY_COUNTRIES IS NOT NULL AND SEVERITY=1
GROUP BY COUNTRY_COUNTRIES
ORDER BY EXTINCT_LANG DESC;

--Percentage of endangered languages that are extinct for each country/Region
SELECT (COUNT(distinct NAME_IN_ENGLISH)) AS TOTAL_EXTINCT FROM EXTLANGUAGES
WHERE SEVERITY = 1

SELECT COUNTRY_COUNTRIES, ROUND(CAST((COUNT(NAME_IN_ENGLISH)*100) AS FLOAT)/253,1) AS PERCENTAGE_EXTINCT FROM EXTLANGUAGES
WHERE COUNTRY_COUNTRIES IS NOT NULL AND SEVERITY=1
GROUP BY COUNTRY_COUNTRIES
ORDER BY PERCENTAGE_EXTINCT DESC;

--Number of endangered languages in the UK
SELECT * FROM EXTLANGUAGES
WHERE COUNTRY_COUNTRIES = 'United Kingdom of Great Britain and Northern Ireland' 
AND Number_of_speakers IS NOT NULL;

--Query into the extinct languages of the United States of America
SELECT * FROM EXTLANGUAGES
WHERE COUNTRY_COUNTRIES = 'UNITED STATES OF AMERICA' AND SEVERITY=1 AND 
Number_of_speakers IS NOT NULL AND DESCRIPTION_OF_LOCATION IS NOT NULL
ORDER BY ID

--------------------------------------------------------------------------------------------------------------------------------
SELECT (CAST(AVG(NUM_OF_COUNTRIES_LANG_SPOKEN)), AS FLOAT) AS AVERAGE FROM EXTLANGUAGES


