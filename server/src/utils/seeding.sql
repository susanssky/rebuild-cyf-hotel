DROP TABLE IF EXISTS customers;

CREATE TABLE IF NOT EXISTS customers (  
id SERIAL PRIMARY KEY NOT NULL,  
title VARCHAR(30) NOT NULL,  
first_name VARCHAR(30) NOT NULL,  
surname VARCHAR(30) NOT NULL,  
email VARCHAR(120) NOT NULL,  
room_id INTEGER,  
check_in_date VARCHAR(20),  
check_out_date VARCHAR(20)  
);

INSERT INTO customers (title, first_name, surname, email, room_id, check_in_date, check_out_date) VALUES ('Mr','John','Doexx','johndoe@doe.com',2,'2017-11-21','2017-11-23');  
INSERT INTO customers (title, first_name, surname, email, room_id, check_in_date, check_out_date) VALUES ('Doctor','Sadia','Begum','begum_sadia@sadia.org',1,'2018-02-15','2018-02-28');  
INSERT INTO customers (title, first_name, surname, email, room_id, check_in_date, check_out_date) VALUES ('Prince','Henry','Wales','harry@wales.com',5,'2018-03-01','2018-04-09');  
INSERT INTO customers (title, first_name, surname, email, room_id, check_in_date, check_out_date) VALUES ('Dame','Judi','Dench','Judi@dench.co.uk',6,'2017-12-25','2018-01-03');  
INSERT INTO customers (title, first_name, surname, email, room_id, check_in_date, check_out_date) VALUES ('Madam','Anuradha','Selvam','anu@selvam.net',3,'2017-08-30','2017-10-02');  