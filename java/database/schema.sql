BEGIN TRANSACTION;

DROP TABLE IF EXISTS user_card_status;
DROP TABLE IF EXISTS user_deck;
DROP TABLE IF EXISTS card_deck;

DROP TABLE IF EXISTS decks;
DROP SEQUENCE IF EXISTS seq_deck_id;

DROP TABLE IF EXISTS cards;
DROP SEQUENCE IF EXISTS seq_card_id;

DROP TABLE IF EXISTS answer_status_desc;
DROP SEQUENCE IF EXISTS seq_status_id;


DROP TABLE IF EXISTS users;
DROP SEQUENCE IF EXISTS seq_user_id;

CREATE SEQUENCE seq_user_id
  INCREMENT BY 1
  NO MAXVALUE
  NO MINVALUE
  CACHE 1;
  
 CREATE SEQUENCE seq_deck_id
  INCREMENT BY 1
  NO MAXVALUE
  NO MINVALUE
  CACHE 1;
  
 CREATE SEQUENCE seq_card_id
  INCREMENT BY 1
  NO MAXVALUE
  NO MINVALUE
  CACHE 1;
  
 CREATE SEQUENCE seq_status_id
  INCREMENT BY 1
  NO MAXVALUE
  NO MINVALUE
  CACHE 1;


CREATE TABLE users (
	user_id int DEFAULT nextval('seq_user_id'::regclass) NOT NULL,
	username varchar(50) NOT NULL,
	password_hash varchar(200) NOT NULL,
	role varchar(50) NOT NULL,
	CONSTRAINT PK_user PRIMARY KEY (user_id)
);

INSERT INTO users (username,password_hash,role) VALUES ('user','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','ROLE_USER');
INSERT INTO users (username,password_hash,role) VALUES ('admin','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','ROLE_ADMIN');


CREATE TABLE decks (
	deck_id int DEFAULT nextval('seq_deck_id'::regclass) NOT NULL,
	deck_name varchar(30) NOT NULL,
	author_user_id int NOT NULL,
	tag_1 varchar(30) NOT NULL,
	tag_2 varchar(30),
	tag_3 varchar(30),
	tag_4 varchar(30),
	is_public boolean NOT NULL,
	CONSTRAINT PK_deck PRIMARY KEY (deck_id)
);


CREATE TABLE cards (
	card_id int DEFAULT nextval('seq_card_id'::regclass) NOT NULL,
	question varchar(500),
	answer varchar(500),
	CONSTRAINT PK_card PRIMARY KEY (card_id)
);

CREATE TABLE card_deck (
	card_id int NOT NULL,
	deck_id int NOT NULL
);

CREATE TABLE user_deck (
        user_deck_id int DEFAULT nextval('seq_deck_id'::regclass) NOT NULL,
	user_id int NOT NULL,
	deck_id int NOT NULL,
	CONSTRAINT PK_user_deck PRIMARY KEY (user_deck_id)
);

CREATE TABLE answer_status_desc (
	status_id int DEFAULT nextval('seq_status_id'::regclass) NOT NULL,
	status_desc varchar(30) NOT NULL,
	CONSTRAINT PK_answer_status_desc PRIMARY KEY (status_id)
);

INSERT INTO answer_status_desc (status_desc) VALUES ('Undefined');
INSERT INTO answer_status_desc (status_desc) VALUES ('Incorrect');
INSERT INTO answer_status_desc (status_desc) VALUES ('Needs to be reviewed');
INSERT INTO answer_status_desc (status_desc) VALUES ('Correct');


CREATE TABLE user_card_status (
	user_id int NOT NULL,
	card_id int NOT NULL,
	status_id int NOT NULL
);

-- card_deck FK constraints
ALTER TABLE card_deck ADD FOREIGN KEY (card_id) REFERENCES cards(card_id);
ALTER TABLE card_deck ADD FOREIGN KEY (deck_id) REFERENCES decks(deck_id);

-- user_deck FK constraints
ALTER TABLE user_deck ADD FOREIGN KEY (user_id) REFERENCES users(user_id);
ALTER TABLE user_deck ADD FOREIGN KEY (deck_id) REFERENCES decks(deck_id);

-- user_card_status FK constraints
ALTER TABLE user_card_status ADD FOREIGN KEY (user_id) REFERENCES users(user_id);
ALTER TABLE user_card_status ADD FOREIGN KEY (card_id) REFERENCES cards(card_id);
ALTER TABLE user_card_status ADD FOREIGN KEY (status_id) REFERENCES answer_status_desc(status_id);

ALTER TABLE decks ADD FOREIGN KEY (author_user_id) REFERENCES users(user_id);

--create deck
INSERT INTO decks (deck_name, author_user_id, tag_1, is_public) VALUES ('Multiplication', 1, 'math', true);
INSERT INTO decks (deck_name, author_user_id, tag_1, is_public) VALUES ('Pre-Algebra Vocabulary', 1, 'algebra', true);
INSERT INTO decks (deck_name, author_user_id, tag_1, is_public) VALUES ('SQL', 1, 'coding', true);
INSERT INTO decks (deck_name, author_user_id, tag_1, is_public) VALUES ('Java', 1, 'java', true);

--assign deck to user
INSERT INTO user_deck(user_id, deck_id) VALUES (1, 1);
INSERT INTO user_deck(user_id, deck_id) VALUES (1, 2);
INSERT INTO user_deck(user_id, deck_id) VALUES (1, 3);
INSERT INTO user_deck(user_id, deck_id) VALUES (1, 4);

--create cards
--DECK 1
INSERT INTO cards (question, answer) VALUES ('3 X 2', '6');
INSERT INTO cards (question, answer) VALUES ('3 X 5', '15');
INSERT INTO cards (question, answer) VALUES ('3 X 7', '21');
INSERT INTO cards (question, answer) VALUES ('3 X 9', '27');
INSERT INTO cards (question, answer) VALUES ('3 X 12', '36');
INSERT INTO cards (question, answer) VALUES ('4 X 1', '4');
INSERT INTO cards (question, answer) VALUES ('4 X 3', '12');
INSERT INTO cards (question, answer) VALUES ('4 X 4', '16');
INSERT INTO cards (question, answer) VALUES ('4 X 6', '24');
INSERT INTO cards (question, answer) VALUES ('4 X 8', '32');
INSERT INTO cards (question, answer) VALUES ('5 X 3', '15');
INSERT INTO cards (question, answer) VALUES ('5 X 6', '30');
INSERT INTO cards (question, answer) VALUES ('5 X 7', '35');
INSERT INTO cards (question, answer) VALUES ('5 X 9', '45');
INSERT INTO cards (question, answer) VALUES ('5 X 11', '55');
INSERT INTO cards (question, answer) VALUES ('6 X 1', '6');
INSERT INTO cards (question, answer) VALUES ('6 X 3', '18');
INSERT INTO cards (question, answer) VALUES ('6 X 6', '36');
INSERT INTO cards (question, answer) VALUES ('6 X 8', '48');
INSERT INTO cards (question, answer) VALUES ('6 X 12', '72');
INSERT INTO cards (question, answer) VALUES ('8 X 7', '56');
INSERT INTO cards (question, answer) VALUES ('8 X 9', '72');
INSERT INTO cards (question, answer) VALUES ('8 X 12', '96');
INSERT INTO cards (question, answer) VALUES ('9 X 12', '108');
INSERT INTO cards (question, answer) VALUES ('10 X 11', '110');

--DECK 2
INSERT INTO cards (question, answer) VALUES ('A term that does not change', 'Constant');
INSERT INTO cards (question, answer) VALUES ('A number multiplied by a variable in an algebraic expression.', 'Coefficient');
INSERT INTO cards (question, answer) VALUES ('A quantity that may change within the context of a mathematical problem; represented by a single letter (commonly "x")', 'Variable');
INSERT INTO cards (question, answer) VALUES ('A mathematical phrase that contains operations, numbers, and/or variables.', 'Expression');
INSERT INTO cards (question, answer) VALUES ('All whole numbers (both positive and negative) and zero.', 'Integer');
INSERT INTO cards (question, answer) VALUES ('Any number that can be expressed as a fraction', 'Rational Numbers');
INSERT INTO cards (question, answer) VALUES ('Any real number which cant be expressed as a fraction of two integers', 'Irrational Numbers');
INSERT INTO cards (question, answer) VALUES ('The set of all rational and irrational numbers. They type of numbers we normally use.', 'Real Numbers');
INSERT INTO cards (question, answer) VALUES ('The number you divide by', 'Divisor');
INSERT INTO cards (question, answer) VALUES ('The answer to a division problem', 'Quotient');
INSERT INTO cards (question, answer) VALUES ('The answer to a multiplication problem', 'Product');
INSERT INTO cards (question, answer) VALUES ('the answer to a subtraction problem', 'Difference');
INSERT INTO cards (question, answer) VALUES ('the answer to an addition problem', 'Sum');
INSERT INTO cards (question, answer) VALUES ('the top number in a fraction', 'Numerator');
INSERT INTO cards (question, answer) VALUES ('The bottom number in a fraction', 'Denominator');
INSERT INTO cards (question, answer) VALUES ('less than 90 degrees', 'Acute');
INSERT INTO cards (question, answer) VALUES ('the distance across a circle through its center', 'Diameter');
INSERT INTO cards (question, answer) VALUES ('The distance from the center of a circle to any point on the circle', 'Radius');
INSERT INTO cards (question, answer) VALUES ('Coordinate (0, 0). The point where the x-axis and y-axis meet', 'Origin');
INSERT INTO cards (question, answer) VALUES ('a number that has no factor but ITSELF and 1', 'Prime');
INSERT INTO cards (question, answer) VALUES ('Numbers that are multiplied together to get a product', 'Factors');
INSERT INTO cards (question, answer) VALUES ('The value that occurs most frequently', 'Mode');
INSERT INTO cards (question, answer) VALUES ('Middle number in a set of numbers', 'Median');
INSERT INTO cards (question, answer) VALUES ('Average', 'Mean');
INSERT INTO cards (question, answer) VALUES ('A CORNER or point where lines meet', 'Vertex');

--DECK 3
INSERT INTO cards (question, answer) VALUES ('What is SQL?', 'SQL stands for Structured Query Language. SQL lets you access and manipulate databases.');
INSERT INTO cards (question, answer) VALUES ('What can SQL do?', 'SQL can execute queries against a database
SQL can retrieve data from a database
SQL can insert records in a database
SQL can update records in a database
SQL can delete records from a database
SQL can create new databases
SQL can create new tables in a database
SQL can create stored procedures in a database
SQL can create views in a database
SQL can set permissions on tables, procedures, and views');
INSERT INTO cards (question, answer) VALUES ('What is RDBMS and what are some examples?', 'RDBMS stands for Relational Database Management System. RDBMS is the basis for SQL, and for all modern database systems such as MS SQL Server, IBM DB2, Oracle, MySQL, and Microsoft Access. The data in RDBMS is stored in database objects called tables. A table is a collection of related data entries and it consists of columns and rows.');
INSERT INTO cards (question, answer) VALUES ('Are SQL queries case sensitive?', 'SQL keywords are NOT case sensitive: select is the same as SELECT');
INSERT INTO cards (question, answer) VALUES ('What goes at the end of each SQL statement?', 'Some database systems require a semicolon at the end of each SQL statement. Semicolon is the standard way to separate each SQL statement in database systems that allow more than one SQL statement to be executed in the same call to the server.');
INSERT INTO cards (question, answer) VALUES ('SELECT Statement', 'The SELECT statement is used to select data from a database. Syntax:
SELECT column_name, column_name
FROM table_name;
SELECT * FROM table_name;');
INSERT INTO cards (question, answer) VALUES ('DISTINCT Statement', 'In a table, a column may contain many duplicate values; and sometimes you only want to list the different (distinct) values. Syntax:
SELECT DISTINCT column_name,column_name
FROM table_name;');
INSERT INTO cards (question, answer) VALUES ('WHERE Clause', 'The WHERE clause is used to extract only those records that fulfill a specified criterion. Syntax:
SELECT column_name,column_name
FROM table_name
WHERE column_name operator value;');
INSERT INTO cards (question, answer) VALUES ('AND/OR Operators', 'The AND & OR operators are used to filter records based on more than one condition.');
INSERT INTO cards (question, answer) VALUES ('ORDER BY Keyword', 'The ORDER BY keyword is used to sort the result-set by one or more columns. The ORDER BY keyword sorts the records in ascending order by default. To sort the records in a descending order, you can use the DESC keyword.
SELECT column_name, column_name
FROM table_name
ORDER BY column_name ASC|DESC, column_name ASC|DESC;');
INSERT INTO cards (question, answer) VALUES ('INSERT INTO Statement', 'The INSERT INTO statement is used to insert new records in a table.
INSERT INTO table_name
VALUES (value1,value2,value3,...);
INSERT INTO table_name (column1,column2,column3,...)
VALUES (value1,value2,value3,...);');
INSERT INTO cards (question, answer) VALUES ('UPDATE Statement', 'The UPDATE statement is used to update existing records in a table.
UPDATE table_name
SET column1=value1,column2=value2,...
WHERE some_column=some_value;
Notice the WHERE clause in the SQL UPDATE statement!
The WHERE clause specifies which record or records that should be updated. If you omit the WHERE clause, all records will be updated!');
INSERT INTO cards (question, answer) VALUES ('DELETE Statement', 'The DELETE statement is used to delete rows in a table.
DELETE FROM table_name
WHERE some_column=some_value;
Notice the WHERE clause in the SQL DELETE statement!
The WHERE clause specifies which record or records that should be deleted. If you omit the WHERE clause, all records will be deleted!');
INSERT INTO cards (question, answer) VALUES ('SELECT TOP Clause', 'The SELECT TOP clause is used to specify the number of records to return. The SELECT TOP clause can be very useful on large tables with thousands of records. Returning a large number of records can impact on performance. Note: Not all database systems support the SELECT TOP clause.
SELECT TOP number|percent column_name(s)
FROM table_name;');
INSERT INTO cards (question, answer) VALUES ('LIKE Operator', 'The LIKE operator is used to search for a specified pattern in a column.
SELECT column_name(s)
FROM table_name
WHERE column_name LIKE pattern;
SELECT * FROM Customers
WHERE City LIKE s%;');
INSERT INTO cards (question, answer) VALUES ('IN Clause', '
The IN operator allows you to specify multiple values in a WHERE clause.
SELECT column_name(s)
FROM table_name
WHERE column_name IN (value1,value2,...);
SELECT * FROM Customers
WHERE City IN (Paris,London);');
INSERT INTO cards (question, answer) VALUES ('BETWEEN operator', 'The BETWEEN operator selects values within a range. The values can be numbers, text, or dates.
SELECT column_name(s)
FROM table_name
WHERE column_name BETWEEN value1 AND value2;');
INSERT INTO cards (question, answer) VALUES ('Aliases (AS)', 'SQL aliases are used to give a database table, or a column in a table, a temporary name. Basically, aliases are created to make column names more readable.
SELECT column_name AS alias_name
FROM table_name;
SELECT column_name(s)
FROM table_name AS alias_name;');
INSERT INTO cards (question, answer) VALUES ('JOIN', '
An SQL JOIN clause is used to combine rows from two or more tables, based on a common field between them.');
INSERT INTO cards (question, answer) VALUES ('INNER JOIN', 'The INNER JOIN keyword selects all rows from both tables as long as there is a match between the columns in both tables.
SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name=table2.column_name;
SELECT column_name(s)
FROM table1
JOIN table2
ON table1.column_name=table2.column_name;');
INSERT INTO cards (question, answer) VALUES ('LEFT JOIN', 'The LEFT JOIN keyword returns all rows from the left table (table1), with the matching rows in the right table (table2). The result is NULL in the right side when there is no match.
SELECT column_name(s)
FROM table1
LEFT JOIN table2
ON table1.column_name=table2.column_name;');
INSERT INTO cards (question, answer) VALUES ('RIGHT JOIN', 'The RIGHT JOIN keyword returns all rows from the right table (table2), with the matching rows in the left table (table1). The result is NULL in the left side when there is no match.
SELECT column_name(s)
FROM table1
RIGHT JOIN table2
ON table1.column_name=table2.column_name;');
INSERT INTO cards (question, answer) VALUES ('FULL OUTER JOIN', 'The FULL OUTER JOIN keyword returns all rows from the left table (table1) and from the right table (table2). The FULL OUTER JOIN keyword combines the result of both LEFT and RIGHT joins.
SELECT column_name(s)
FROM table1
FULL OUTER JOIN table2
ON table1.column_name=table2.column_name;
');
INSERT INTO cards (question, answer) VALUES ('UNION', 'The UNION operator is used to combine the result-set of two or more SELECT statements. Notice that each SELECT statement within the UNION must have the same number of columns. The columns must also have similar data types. Also, the columns in each SELECT statement must be in the same order.
SELECT column_name(s) FROM table1
UNION
SELECT column_name(s) FROM table2;');
INSERT INTO cards (question, answer) VALUES ('SELECT INTO', 'The SELECT INTO statement selects data from one table and inserts it into a new table.
SELECT *
INTO newtable [IN externaldb]
FROM table1;
SELECT column_name(s)
INTO newtable [IN externaldb]
FROM table1;');

--DECK 4
INSERT INTO cards (question, answer) VALUES ('Accessor Method', 'Provides information on one or more instance variables. It returns a value from a private or protected field. Does not modify an object. In general, an accessor performs some computation using the fields as long as that computation does not modify any of the fields.');
INSERT INTO cards (question, answer) VALUES ('Final Keyword', 'A keyword that stops variables from being changed.
Once a final variable has been assigned, it always contains the same value. If a final variable holds a reference to an object, then the state of the object may be changed by operations on the object, but the variable will always refer to the same object.
Make final all capitals. (constant)');
INSERT INTO cards (question, answer) VALUES ('Mutator Method', 'Changes the value of one or more instance variables.
Setter as opposed to getter.');
INSERT INTO cards (question, answer) VALUES ('Main Method', '
Is the "Meta algorithm" for any program.
Conductor of the orchestra, the Driver');
INSERT INTO cards (question, answer) VALUES ('Class', 'A blueprint or Template
Datatype encapsulates our notion of a type that contains instance variables and methods');
INSERT INTO cards (question, answer) VALUES ('Long', 'A longer version of int. Uses 64 bit instead of ints 32 bit.');
INSERT INTO cards (question, answer) VALUES ('The collection of public methods in a class', 'the interface that any user will use to interact with program');
INSERT INTO cards (question, answer) VALUES ('Constructor Method', 'Uses the same name as the parent class.
Initializes instances variables.
Does not return anything.
3 types: Default, no-arg, and parametrized');
INSERT INTO cards (question, answer) VALUES ('Instantiation', '1. Scope - Where a variable is accessible in a program
2. How much space (memory) I need for this variable (str,int, double,etc)
3. How we should interpret the contents of those variables (How java should interpret ones and zeros)');
INSERT INTO cards (question, answer) VALUES ('Object', 'An instance of a class. Can be variables or related methods. Has three characteristics:
-State - Data value
-Behavior - Functionality
-Identity - Unique ID in JVM
i.e. "You" are an instance of a "Human" class.');
INSERT INTO cards (question, answer) VALUES ('Actual Parameters', 'Is passed "to" a method. Also referred to as an "argument".
The "type" of data that a method can receive is referred to as a "parameter". (You may see "arguments" referred to as "actual parameters" and "parameters" referred to as "formal parameters".)
public int addNumbers (2 , 4)
2 and 4 are _________.');
INSERT INTO cards (question, answer) VALUES ('Formal Parameters', 'The "type" of data that a method can receive is referred to as a "parameter". Refers to the variable as found in the method definition.
i.e.
public int addNumbers (int a , int b)
int a and int b are _________.');
INSERT INTO cards (question, answer) VALUES ('bit', '(short for binary digit) is the smallest unit of data on a computer; each bit has a single value of either 1 or 0.');
INSERT INTO cards (question, answer) VALUES ('Arithmetic/logic unit', 'is the part of a computer processor (CPU) that carries out arithmetic and logic operations on the operands in computer instruction words');
INSERT INTO cards (question, answer) VALUES ('Algorithm', 'A well-ordered collection of unambiguous and effectively computable operations that when executed produces a result and halts in a finite amount of time. (Textbook)
Remove all intelligence from a solution');
INSERT INTO cards (question, answer) VALUES ('Address**', 'The coded representation of the physical or logical location of a source or destination resource, such as a register, a memory partition, an application, or a node or station.');
INSERT INTO cards (question, answer) VALUES ('Boolean**', 'In computer operation with binary values, "______" logic can be used to describe electromagnetically charged memory locations or circuit states that are either charged (1 or true) or not charged (0 or false). The computer can use an AND gate or an OR gate operation to obtain a result that can be used for further processing. The following table shows the results from applying AND and OR operations to two compared states:
0 AND 0 = 0
1 AND 0 = 0
1 AND 1 = 1
0 OR 0 = 0
0 OR 1 = 1
1 OR 1 = 1');
INSERT INTO cards (question, answer) VALUES ('boolean expression', 'A Java expression that, when evaluated, returns a Boolean value: true or false. Boolean expressions are used in conditional statements, such as if, while, and switch.');
INSERT INTO cards (question, answer) VALUES ('boolean operator', 'An operator that returns a Boolean result thats based on the Boolean result of one or two other expressions.
not, and, or, xor');
INSERT INTO cards (question, answer) VALUES ('byte', 'The byte is a unit of digital information that most commonly consists of eight bits.
Smallest integer type. This is a signed 8-bit type that has a range from -128 to 127.');
INSERT INTO cards (question, answer) VALUES ('Cache Memory', 'a small-sized type of volatile computer memory that provides high-speed data access to a processor and stores frequently used computer programs, applications and data.');
INSERT INTO cards (question, answer) VALUES ('cast', 'Also known as "type conversion". Consists of changing from one data type to another.');
INSERT INTO cards (question, answer) VALUES ('compiler', 'A compiler is a special program that processes statements written in a particular programming language and turns them into machine language or "code" that a computers processor uses.');
INSERT INTO cards (question, answer) VALUES ('Computer Science', 'The study of algorithms including:
-Their formal and mathematical properties
-Their hardware realizations
-Their linguistic realizations
-Their applications');
INSERT INTO cards (question, answer) VALUES ('encapsulation', 'A mechanism of wrapping the data (variables) and code acting on the data (methods) together as a single unit. In encapsulation, the variables of a class will be hidden from other classes, and can be accessed only through the methods of their current class. (Java)');

--add card to default deck(s)
--deck 1
INSERT INTO card_deck (card_id, deck_id) VALUES (1, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (2, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (3, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (4, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (5, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (6, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (7, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (8, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (9, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (10, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (11, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (12, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (13, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (14, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (15, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (16, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (17, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (18, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (19, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (20, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (21, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (22, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (23, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (24, 1);
INSERT INTO card_deck (card_id, deck_id) VALUES (25, 1);

--deck 2
INSERT INTO card_deck (card_id, deck_id) VALUES (26, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (27, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (28, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (29, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (30, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (31, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (32, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (33, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (34, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (35, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (36, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (37, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (38, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (39, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (40, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (41, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (42, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (43, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (44, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (45, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (46, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (47, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (48, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (49, 2);
INSERT INTO card_deck (card_id, deck_id) VALUES (50, 2);

--deck 3 card_deck
INSERT INTO card_deck (card_id, deck_id) VALUES (51, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (52, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (53, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (54, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (55, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (56, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (57, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (58, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (59, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (60, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (61, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (62, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (63, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (64, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (65, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (66, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (67, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (68, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (69, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (70, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (71, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (72, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (73, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (74, 3);
INSERT INTO card_deck (card_id, deck_id) VALUES (75, 3);

--deck 4 card_deck
INSERT INTO card_deck (card_id, deck_id) VALUES (76, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (77, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (78, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (79, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (80, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (81, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (82, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (83, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (84, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (85, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (86, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (87, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (88, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (89, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (90, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (91, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (92, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (93, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (94, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (95, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (96, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (97, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (98, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (99, 4);
INSERT INTO card_deck (card_id, deck_id) VALUES (100, 4);

--set user_card_status defuat to incorrect
--deck 1
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 1, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 2, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 3, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 4, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 5, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 6, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 7, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 8, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 9, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 10, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 11, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 12, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 13, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 14, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 15, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 16, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 17, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 18, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 19, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 20, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 21, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 22, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 23, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 24, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 25, 2);
--deck 2
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 26, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 27, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 28, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 29, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 30, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 31, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 32, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 33, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 34, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 35, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 36, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 37, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 38, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 39, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 40, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 41, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 42, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 43, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 44, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 45, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 46, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 47, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 48, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 49, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 50, 2);
--deck 3
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 51, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 52, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 53, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 54, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 55, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 56, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 57, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 58, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 59, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 60, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 61, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 62, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 63, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 64, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 65, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 66, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 67, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 68, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 69, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 70, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 71, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 72, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 73, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 74, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 75, 2);
--user_card_status for deck 4
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 76, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 77, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 78, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 79, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 80, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 81, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 82, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 83, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 84, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 85, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 86, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 87, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 88, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 89, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 90, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 91, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 92, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 93, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 94, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 95, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 96, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 97, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 98, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 99, 2);
INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (1, 100, 2);

COMMIT TRANSACTION;

-- From user.sql

CREATE USER final_capstone_owner
WITH PASSWORD 'finalcapstone';

GRANT ALL
ON ALL TABLES IN SCHEMA public
TO final_capstone_owner;

GRANT ALL
ON ALL SEQUENCES IN SCHEMA public
TO final_capstone_owner;

CREATE USER final_capstone_appuser
WITH PASSWORD 'finalcapstone';

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA public
TO final_capstone_appuser;

GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA public
TO final_capstone_appuser;







