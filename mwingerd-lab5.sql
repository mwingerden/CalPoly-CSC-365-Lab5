-- Lab 5
-- mwingerd
-- Nov 6, 2022

USE `AIRLINES`;
-- AIRLINES-1
-- Find all airports with exactly 17 outgoing flights. Report airport code and the full name of the airport sorted in alphabetical order by the code.
SELECT
    Code, Name
FROM
    airports
JOIN
    flights ON Code = Source
GROUP BY
    Code, Name
HAVING
    COUNT(Name) = 17
ORDER BY
    Code;


USE `AIRLINES`;
-- AIRLINES-2
-- Find the number of airports from which airport ANP can be reached with exactly one transfer. Make sure to exclude ANP itself from the count. Report just the number.
SELECT 
    COUNT(DISTINCT t2.Source)
FROM 
    flights AS t1
JOIN
    flights AS t2 ON (t1.Source = t2.Destination AND t2.Destination != 'ANP' AND t2.Source != 'ANP')
WHERE
    t1.Destination = 'ANP';


USE `AIRLINES`;
-- AIRLINES-3
-- Find the number of airports from which airport ATE can be reached with at most one transfer. Make sure to exclude ATE itself from the count. Report just the number.
SELECT 
    COUNT(DISTINCT t2.Source)
FROM 
    flights AS t1
JOIN
    flights AS t2 
        ON ((t1.Source = t2.Destination 
            OR 
            t2.Destination = 'ATE') 
            AND t1.Destination != t2.Source)
WHERE
    t1.Destination = 'ATE';


USE `AIRLINES`;
-- AIRLINES-4
-- For each airline, report the total number of airports from which it has at least one outgoing flight. Report the full name of the airline and the number of airports computed. Report the results sorted by the number of airports in descending order. In case of tie, sort by airline name A-Z.
SELECT
    Name, Count(*) 
FROM
    (SELECT 
        Name, Count(*) 
    FROM
        airlines
    JOIN
        flights ON Id = Airline
    GROUP BY
        Name, Source
    HAVING 
        Count(Source) > 0) t1
GROUP BY
    Name
ORDER BY
    Count(*) desc, Name;


USE `BAKERY`;
-- BAKERY-1
-- For each flavor which is found in more than three types of items offered at the bakery, report the flavor, the average price (rounded to the nearest penny) of an item of this flavor, and the total number of different items of this flavor on the menu. Sort the output in ascending order by the average price.
SELECT 
    Flavor, ROUND(AVG(PRICE), 2) AS AVGPrice, COUNT(Flavor) AS Amount
FROM
    goods
GROUP BY
    Flavor
HAVING
    COUNT(Flavor) > 3
ORDER BY
    AVGPrice;


USE `BAKERY`;
-- BAKERY-2
-- Find the total amount of money the bakery earned in October 2007 from selling eclairs. Report just the amount.
SELECT
    SUM(Price)
FROM
    goods
JOIN
    items ON Item = GId
JOIN
    receipts on RNumber = Receipt
WHERE
        Food = 'Eclair'
    AND
        SaleDate >= '2007-10-1'
    AND 
        SaleDate <= '2007-10-31';


USE `BAKERY`;
-- BAKERY-3
-- For each visit by NATACHA STENZ output the receipt number, sale date, total number of items purchased, and amount paid, rounded to the nearest penny. Sort by the amount paid, greatest to least.
SELECT
    RNumber, 
    SaleDate, 
    COUNT(Ordinal) As Amount, 
    ROUND(SUM(Price),2) AS AmountPaid
FROM
    customers
JOIN
    receipts ON CId = Customer
JOIN
    items ON RNumber = Receipt
JOIN
    goods ON GId = Item
WHERE
        FirstName = 'NATACHA'
    AND
        LastName = 'STENZ'
GROUP BY
    RNumber, SaleDate
ORDER BY
    AmountPaid DESC;


USE `BAKERY`;
-- BAKERY-4
-- For the week starting October 8, report the day of the week (Monday through Sunday), the date, total number of purchases (receipts), the total number of pastries purchased, and the overall daily revenue rounded to the nearest penny. Report results in chronological order.
SELECT
    DayName(SaleDate) AS Day, 
    SaleDate,
    COUNT(Distinct RNumber) as Receipts,
    COUNT(Ordinal) AS Amount,
    ROUND(SUM(Price), 2) AS Price
FROM
    receipts
JOIN
    items ON Receipt = RNumber
JOIN 
    goods ON GId = Item
WHERE
        Month(SaleDate) = 10
    AND
        DayOfMonth(SaleDate) >= 8
    AND
        DayOfMonth(SaleDate) <= 14
GROUP BY
    SaleDate
ORDER BY
    SaleDate;


USE `BAKERY`;
-- BAKERY-5
-- Report all dates on which more than ten tarts were purchased, sorted in chronological order.
SELECT
    SaleDate
FROM
    receipts
JOIN
    items ON Receipt = RNumber
JOIN
    goods ON item = GId
WHERE
    Food = 'tart'
GROUP BY
    SaleDate
HAVING
    COUNT('Tart') > 10
ORDER BY
    SaleDate;


USE `CSU`;
-- CSU-1
-- For each campus that averaged more than $2,500 in fees between the years 2000 and 2005 (inclusive), report the campus name and total of fees for this six year period. Sort in ascending order by fee.
SELECT
    Campus, SUM(Fee) AS Total
FROM
    campuses
JOIN
    fees ON CampusId = Id
WHERE
    fees.Year >= 2000 AND fees.Year <= 2005
GROUP BY
    Campus
HAVING
    SUM(Fee) / COUNT(*) > 2500
ORDER BY
    Total;


USE `CSU`;
-- CSU-2
-- For each campus for which data exists for more than 60 years, report the campus name along with the average, minimum and maximum enrollment (over all years). Sort your output by average enrollment.
SELECT
    Campus, AVG(Enrolled), MIN(Enrolled), MAX(Enrolled)
FROM
    campuses
JOIN
    enrollments ON CampusId = Id
GROUP BY
    Campus
HAVING
    COUNT(enrollments.Year) > 60
ORDER BY
    AVG(Enrolled);


USE `CSU`;
-- CSU-3
-- For each campus in LA and Orange counties report the campus name and total number of degrees granted between 1998 and 2002 (inclusive). Sort the output in descending order by the number of degrees.

SELECT 
    Campus, SUM(degrees) AS Total
FROM
    campuses
JOIN
    degrees ON CampusId = Id
WHERE
        (County = 'Orange' OR County = 'Los Angeles')
    AND
        degrees.Year >= 1998 AND degrees.Year <= 2002
GROUP BY
    Campus
ORDER BY
    Total DESC;


USE `CSU`;
-- CSU-4
-- For each campus that had more than 20,000 enrolled students in 2004, report the campus name and the number of disciplines for which the campus had non-zero graduate enrollment. Sort the output in alphabetical order by the name of the campus. (Exclude campuses that had no graduate enrollment at all.)
SELECT
    Campus, COUNT(Discipline)
FROM
    campuses
JOIN
    enrollments ON enrollments.CampusId = Id
JOIN
    discEnr ON discEnr.CampusId = Id
WHERE
    GR != 0 AND enrollments.Year = 2004 AND Enrolled > 20000
GROUP BY
    Campus
ORDER BY
    Campus;


USE `INN`;
-- INN-1
-- For each room, report the full room name, total revenue (number of nights times per-night rate), and the average revenue per stay. In this summary, include only those stays that began in the months of September, October and November of calendar year 2010. Sort output in descending order by total revenue. Output full room names.
SELECT 
    RoomName,
    Round(SUM(Rate * DateDiff(CheckOut,CheckIn)),2) as TotalRevenue,
    Round(AVG(Rate * DateDiff(CheckOut,CheckIn)),2) as AveragePerStay
FROM
    rooms
JOIN
    reservations ON Room = RoomCode
WHERE
    Month(CheckIn) >= 9 and Month(CheckIn) <= 11
GROUP BY
    RoomName
ORDER BY
    TotalRevenue DESC;


USE `INN`;
-- INN-2
-- Report the total number of reservations that began on Fridays, and the total revenue they brought in.
SELECT
    COUNT(*) As Stays,
    Round(SUM(Rate * DateDiff(CheckOut,CheckIn)),2) as REVENUE
FROM
    reservations
JOIN
    rooms ON RoomCode = Room
WHERE
    DayName(CheckIn) = 'Friday'
GROUP BY
    DayName(CheckIn);


USE `INN`;
-- INN-3
-- List each day of the week. For each day, compute the total number of reservations that began on that day, and the total revenue for these reservations. Report days of week as Monday, Tuesday, etc. Order days from Sunday to Saturday.
SELECT
    DayName(CheckIn) AS DAY, 
    COUNT(*) as STAYS,
    SUM(Rate * DateDiff(CheckOut,CheckIn)) as REVENUE
FROM
    reservations
GROUP BY
    DayOfWeek(CheckIn),DayName(CheckIn)
ORDER BY
    DayOfWeek(CheckIn);


USE `INN`;
-- INN-4
-- For each room list full room name and report the highest markup against the base price and the largest markdown (discount). Report markups and markdowns as the signed difference between the base price and the rate. Sort output in descending order beginning with the largest markup. In case of identical markup/down sort by room name A-Z. Report full room names.
SELECT  
    roomname,
    MAX(Rate - BasePrice) as Markup,
    MIN(Rate - BasePrice) as Discount
FROM
    reservations
JOIN
    rooms on RoomCode = Room
GROUP BY
    RoomName
ORDER BY
    Markup DESC, roomname;


USE `INN`;
-- INN-5
-- For each room report how many nights in calendar year 2010 the room was occupied. Report the room code, the full name of the room, and the number of occupied nights. Sort in descending order by occupied nights. (Note: this should be number of nights during 2010. Some reservations extend beyond December 31, 2010. The ”extra” nights in 2011 must be deducted).
SELECT DISTINCT
    t1.RoomCode, t1.RoomName, t1.DaysOccupied + t2.DaysOccupied AS DaysOccupied
FROM
    (SELECT
        RoomCode, RoomName, SUM(DateDiff(CheckOut,CheckIn)) AS DaysOccupied
    FROM
        rooms
    JOIN
        reservations ON RoomCode = Room
    WHERE
        (YEAR(CheckIn) = '2010' AND YEAR(CheckOut) = '2010')
    GROUP BY
        RoomCode, RoomName) AS t1
JOIN
    (SELECT
        RoomCode, RoomName, SUM(DateDiff(CheckOut,CheckIn)) - SUM(DateDiff(CheckOut, '2011-01-01')) - 1 AS DaysOccupied
    FROM
        rooms
    JOIN
        reservations ON RoomCode = Room
    WHERE
        (YEAR(CheckIn) = '2010' AND YEAR(CheckOut) = '2011')
    GROUP BY
        RoomCode, RoomName) AS t2 ON t1.RoomCode = t2.RoomCode
UNION
SELECT
    RoomCode, 
    RoomName, 
    SUM(DateDiff(CheckOut,CheckIn)) - SUM(DateDiff('2010-01-01', CheckIn)) - SUM(DateDiff(CheckOut, '2011-01-01')) AS DaysOccupied
FROM
    rooms
JOIN
    reservations ON RoomCode = Room
WHERE
    (YEAR(CheckIn) = '2009' AND YEAR(CheckOut) = '2011')
GROUP BY
    RoomCode, RoomName
ORDER BY
    DaysOccupied DESC;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- For each performer, report first name and how many times she sang lead vocals on a song. Sort output in descending order by the number of leads. In case of tie, sort by performer first name (A-Z.)
SELECT
    Firstname,Count(*) 
FROM
    Vocals
JOIN
    Band ON Bandmate = Id
WHERE
    VocalType = 'lead'
GROUP BY
    Bandmate
ORDER BY
    Count(*) desc;


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report how many different instruments each performer plays on songs from the album 'Le Pop'. Include performer's first name and the count of different instruments. Sort the output by the first name of the performers.
SELECT
    FirstName, COUNT(Distinct Instrument)
FROM
    Albums
JOIN
    Tracklists ON Album = AId
JOIN 
    Songs ON SongId = Tracklists.Song
JOIN
    Instruments ON SongId = Instruments.Song
JOIN
    Band ON Bandmate = Band.Id
WHERE
    Albums.Title = 'Le Pop'
GROUP BY
    FirstName
ORDER BY
    FirstName;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- List each stage position along with the number of times Turid stood at each stage position when performing live. Sort output in ascending order of the number of times she performed in each position.

SELECT
    StagePosition AS TuridPosition, COUNT(*)
FROM
    Band
JOIN
    Performance ON Bandmate = Id
WHERE
    FirstName = "Turid"
GROUP BY
    StagePosition
ORDER BY
    COUNT(*);


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Report how many times each performer (other than Anne-Marit) played bass balalaika on the songs where Anne-Marit was positioned on the left side of the stage. List performer first name and a number for each performer. Sort output alphabetically by the name of the performer.

SELECT
    Firstname,Count(*) 
FROM
    (SELECT
        distinct Performance.Song AS Song,Firstname,Instrument 
    FROM
        Performance
    JOIN
        Instruments ON Performance.Song = Instruments.Song
    JOIN
        Band ON Instruments.Bandmate = Band.Id
    WHERE 
            Firstname != 'Anne-Marit' 
        AND 
            Instrument = 'bass balalaika') t1
JOIN
    (SELECT 
        Performance.Song AS Song 
    FROM
        Performance 
    JOIN
        Band ON Bandmate = Id
    WHERE
            StagePosition = 'left'
        AND
            Firstname = 'Anne-Marit') t2 ON t1.Song = t2.Song
GROUP BY
    Firstname
ORDER BY
    Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Report all instruments (in alphabetical order) that were played by three or more people.
SELECT
    Instrument
FROM
    Band
JOIN
    Instruments ON Bandmate = Id
GROUP BY
    Instrument
HAVING
    COUNT(Distinct FirstName) >= 3
ORDER BY
    Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- For each performer, list first name and report the number of songs on which they played more than one instrument. Sort output in alphabetical order by first name of the performer
SELECT
    FirstName,Count(*) 
FROM
    Band
JOIN
    (SELECT
        Bandmate
    FROM
        Instruments
    GROUP BY
        Bandmate,Song
    HAVING
        Count(Instrument) > 1) t1 ON Id = Bandmate
GROUP BY
    Id
ORDER BY
    FirstName;


USE `MARATHON`;
-- MARATHON-1
-- List each age group and gender. For each combination, report total number of runners, the overall place of the best runner and the overall place of the slowest runner. Output result sorted by age group and sorted by gender (F followed by M) within each age group.
SELECT
    AgeGroup, Sex, COUNT(FirstName), MIN(Place), MAX(Place)
FROM
    marathon
GROUP BY
    AgeGroup, Sex
ORDER BY
    AgeGroup, Sex;


USE `MARATHON`;
-- MARATHON-2
-- Report the total number of gender/age groups for which both the first and the second place runners (within the group) are from the same state.
SELECT
    count(*) 
FROM
    (SELECT
        AgeGroup,Sex,State 
    FROM
        marathon
    WHERE
        GroupPlace = 1 OR GroupPlace = 2
    GROUP BY
        AgeGroup,Sex,State
    HAVING
        COUNT(State) = 2) t1;


USE `MARATHON`;
-- MARATHON-3
-- For each full minute, report the total number of runners whose pace was between that number of minutes and the next. In other words: how many runners ran the marathon at a pace between 5 and 6 mins, how many at a pace between 6 and 7 mins, and so on.
SELECT
    Minute(Pace) AS PaceMinutes, COUNT(*)
FROM
    marathon
GROUP BY
    PaceMinutes;


USE `MARATHON`;
-- MARATHON-4
-- For each state with runners in the marathon, report the number of runners from the state who finished in top 10 in their gender-age group. If a state did not have runners in top 10, do not output information for that state. Report state code and the number of top 10 runners. Sort in descending order by the number of top 10 runners, then by state A-Z.
SELECT
    State, COUNT(*) AS 	NumberOfTop10
FROM
    marathon
WHERE
    GroupPlace <= 10
GROUP BY
    State
ORDER BY
    NumberOfTop10 DESC;


USE `MARATHON`;
-- MARATHON-5
-- For each Connecticut town with 3 or more participants in the race, report the town name and average time of its runners in the race computed in seconds. Output the results sorted by the average time (lowest average time first).
SELECT
    Town, Round(AVG(TIME_TO_SEC(RunTime)),1) AS AverageTimeInSeconds
FROM
    marathon
WHERE
    State = 'CT'
GROUP BY
    Town
HAVING
    COUNT(*) >= 3
ORDER BY
    AverageTimeInSeconds;


USE `STUDENTS`;
-- STUDENTS-1
-- Report the last and first names of teachers who have between seven and eight (inclusive) students in their classrooms. Sort output in alphabetical order by the teacher's last name.
SELECT
    Last, First
FROM
    list
NATURAL JOIN 
    teachers
GROUP BY
    Last, First
HAVING
    COUNT(*) >= 7 AND COUNT(*) <= 8
ORDER BY
    Last;


USE `STUDENTS`;
-- STUDENTS-2
-- For each grade, report the grade, the number of classrooms in which it is taught, and the total number of students in the grade. Sort the output by the number of classrooms in descending order, then by grade in ascending order.

SELECT
    grade, COUNT(DISTINCT classroom) AS Classrooms, COUNT(*) AS Students
FROM
    list
WHERE
    grade = 0
UNION
SELECT
    grade, COUNT(DISTINCT classroom) AS Classrooms, COUNT(*) AS Students
FROM
    list
WHERE
    grade = 1
UNION
SELECT
    grade, COUNT(DISTINCT classroom) AS Classrooms, COUNT(*) AS Students
FROM
    list
WHERE
    grade = 2
UNION
SELECT
    grade, COUNT(DISTINCT classroom) AS Classrooms, COUNT(*) AS Students
FROM
    list
WHERE
    grade = 3
UNION
SELECT
    grade, COUNT(DISTINCT classroom) AS Classrooms, COUNT(*) AS Students
FROM
    list
WHERE
    grade = 4
UNION
SELECT
    grade, COUNT(DISTINCT classroom) AS Classrooms, COUNT(*) AS Students
FROM
    list
WHERE
    grade = 5
UNION
SELECT
    grade, COUNT(DISTINCT classroom) AS Classrooms, COUNT(*) AS Students
FROM
    list
WHERE
    grade = 6
ORDER BY
    Classrooms DESC, grade;


USE `STUDENTS`;
-- STUDENTS-3
-- For each Kindergarten (grade 0) classroom, report classroom number along with the total number of students in the classroom. Sort output in the descending order by the number of students.
SELECT
    classroom, COUNT(*)
FROM 
    list
WHERE
    grade = 0
GROUP BY
    classroom
ORDER BY
    COUNT(*) DESC;


USE `STUDENTS`;
-- STUDENTS-4
-- For each fourth grade classroom, report the classroom number and the last name of the student who appears last (alphabetically) on the class roster. Sort output by classroom.
SELECT 
    classroom, Max(LastName)
FROM
    list
WHERE 
    grade = 4
GROUP BY
    classroom
ORDER BY
    classroom;


