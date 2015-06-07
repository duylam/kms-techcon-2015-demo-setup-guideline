CREATE KEYSPACE techcon2015
WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 2 }
AND DURABLE_WRITES = false;

USE techcon2015;

CREATE TABLE participant(
  department text,
  employee_id int,
  name text,
  PRIMARY KEY (department, employee_id)
);

INSERT INTO participant(department, employee_id, name) VALUES ('HR', 1, 'Nguyen Quoc Hung');

INSERT INTO participant(department, employee_id, name) VALUES ('RD', 2, 'Lam Phuong Duy');
