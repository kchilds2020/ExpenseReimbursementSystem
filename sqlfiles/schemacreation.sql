
/*Reimbursement type lookup table*/
CREATE TABLE ERS_REIMBURSEMENT_TYPE(
	REIMB_TYPE_ID int NOT NULL,
	REIMB_TYPE varchar(10) NOT NULL,
	PRIMARY KEY(REIMB_TYPE_ID)
);

/*Reimbursement status lookup table*/
CREATE TABLE ERS_REIMBURSEMENT_STATUS(
	REIMB_STATUS_ID int NOT NULL,
	REIMB_STATUS varchar(10) NOT NULL,
	PRIMARY KEY(REIMB_STATUS_ID)
);

/*user role lookup table*/
CREATE TABLE ERS_USER_ROLES(
	ERS_USER_ROLE_ID int NOT NULL,
	USER_ROLE varchar(10) NOT NULL,
	PRIMARY KEY(ERS_USER_ROLE_ID)
);

/*users table*/
CREATE TABLE ERS_USERS(
	ERS_USER_ID SERIAL NOT NULL,
	ERS_USERNAME varchar(50) NOT NULL,
	ERS_PASSWORD varchar(50) NOT NULL,
	USER_FIRST_NAME varchar(100) NOT NULL,
	USER_LAST_NAME varchar(100) NOT NULL,
	USER_EMAIL varchar(150) NOT NULL,
	USER_ROLE_ID int NOT NULL,
	CONSTRAINT USER_ROLES_FK FOREIGN KEY(USER_ROLE_ID) REFERENCES ERS_USER_ROLES(ERS_USER_ROLE_ID),
	UNIQUE(ERS_USERNAME, USER_EMAIL),
	PRIMARY KEY(ERS_USER_ID)
);

/*reimbursement data*/
CREATE TABLE ERS_REIMBURSEMENT (
	REIMB_ID SERIAL NOT NULL,
	REIMB_AMOUNT DECIMAL NOT NULL,
	REIMB_SUBMITTED TIMESTAMP DEFAULT NOW(),
	REIMB_RESOLVED TIMESTAMP,
	REIMB_DESCRIPTION varchar(250),
	REIMB_RECEIPT BYTEA,
	REIMB_AUTHOR int,
	REIMB_RESOLVER int,
	REIMB_STATUS_ID int,
	REIMB_TYPE_ID int,
	CONSTRAINT ERS_USERS_FK_AUTH FOREIGN KEY(REIMB_AUTHOR) REFERENCES ERS_USERS(ERS_USER_ID),
	CONSTRAINT ERS_USERS_FK_RESLVR FOREIGN KEY(REIMB_RESOLVER) REFERENCES ERS_USERS(ERS_USER_ID),
	CONSTRAINT ERS_REIMBURSEMENT_STATUS_FK FOREIGN KEY (REIMB_STATUS_ID) REFERENCES ERS_REIMBURSEMENT_STATUS(REIMB_STATUS_ID),
	CONSTRAINT ERS_REIMBURSEMENT_TYPE_FK FOREIGN KEY(REIMB_TYPE_ID) REFERENCES ERS_REIMBURSEMENT_TYPE(REIMB_TYPE_ID),
	PRIMARY KEY(REIMB_ID)
);


/*hard coded values for the lookup tables*/
INSERT INTO ers_reimbursement_type (reimb_type_id, reimb_type) VALUES (1, 'LODGING');
INSERT INTO ers_reimbursement_type (reimb_type_id, reimb_type) VALUES (2, 'TRAVEL');
INSERT INTO ers_reimbursement_type (reimb_type_id, reimb_type) VALUES (3, 'FOOD');
INSERT INTO ers_reimbursement_type (reimb_type_id, reimb_type) VALUES (4, 'OTHER');

INSERT INTO ers_reimbursement_status (reimb_status_id, reimb_status) VALUES (1,'PENDING');
INSERT INTO ers_reimbursement_status (reimb_status_id, reimb_status) VALUES (2,'APPROVED');
INSERT INTO ers_reimbursement_status (reimb_status_id, reimb_status) VALUES (3,'DENIED');

INSERT INTO ers_user_roles (ers_user_role_id, user_role) VALUES (1, 'EMPLOYEE');
INSERT INTO ers_user_roles (ers_user_role_id, user_role) VALUES (2, 'MANAGER');

SELECT * FROM ers_user_roles ORDER BY ers_user_role_id;
SELECT * FROM ers_reimbursement_status ORDER BY reimb_status_id;
SELECT * FROM ers_reimbursement_type ORDER BY reimb_type_id;



/*create a financial manager*/
INSERT INTO ers_users (ers_username, ers_password, user_first_name, user_last_name, user_email, user_role_id)
VALUES ('financialmanager1', 'password123', 'Financial', 'Manager', 'fm1@email.com', 2);

SELECT * FROM ers_users;

/*create an employee*/

INSERT INTO ers_users (ers_username, ers_password, user_first_name, user_last_name, user_email, user_role_id)
VALUES ('employee1', 'password123', 'Employee', 'User', 'e1@email.com', 1);

SELECT * FROM ers_users;

/*create a reimbursement request*/

INSERT INTO ers_reimbursement (reimb_amount, reimb_author,reimb_status_id, reimb_type_id)
VALUES (938.11,2,1,1);

SELECT * FROM ers_reimbursement;


/*query for reimursements*/
SELECT r.reimb_id, r.reimb_amount, r.reimb_submitted, r.reimb_resolved, r.reimb_description, r.reimb_receipt, 
u.ers_user_id, u.ers_username, u.ers_password, u.user_first_name, u.user_last_name, u.user_email,
eur.ers_user_role_id, eur.user_role,
s.ers_user_id, s.ers_username, s.ers_password, s.user_first_name, s.user_last_name, s.user_email,
eur2.ers_user_role_id, eur2.user_role, 
ers.reimb_status_id, ers.reimb_status,
ert.reimb_type_id, ert.reimb_type 
FROM ers_reimbursement r
LEFT JOIN ers_users u ON u.ers_user_id = r.reimb_author 
INNER JOIN ers_user_roles eur ON eur.ers_user_role_id = u.user_role_id
LEFT JOIN ers_users s ON s.ers_user_id = r.reimb_resolver 
LEFT JOIN ers_user_roles eur2 ON eur2.ers_user_role_id  = s.user_role_id 
LEFT JOIN ers_reimbursement_status ers ON ers.reimb_status_id = r.reimb_status_id 
LEFT JOIN ers_reimbursement_type ert ON ert.reimb_type_id = r.reimb_type_id;

/*query for reimursements with where*/
SELECT r.reimb_id, r.reimb_amount, r.reimb_submitted, r.reimb_resolved, r.reimb_description, r.reimb_receipt, 
u.ers_user_id, u.ers_username, u.ers_password, u.user_first_name, u.user_last_name, u.user_email,
eur.ers_user_role_id, eur.user_role,
s.ers_user_id, s.ers_username, s.ers_password, s.user_first_name, s.user_last_name, s.user_email,
eur2.ers_user_role_id, eur2.user_role, 
ers.reimb_status_id, ers.reimb_status,
ert.reimb_type_id, ers.reimb_status 
FROM ers_reimbursement r
LEFT JOIN ers_users u ON u.ers_user_id = r.reimb_author 
INNER JOIN ers_user_roles eur ON eur.ers_user_role_id = u.user_role_id
LEFT JOIN ers_users s ON s.ers_user_id = r.reimb_resolver 
LEFT JOIN ers_user_roles eur2 ON eur2.ers_user_role_id  = s.user_role_id 
LEFT JOIN ers_reimbursement_status ers ON ers.reimb_status_id = r.reimb_status_id 
LEFT JOIN ers_reimbursement_type ert ON ert.reimb_type_id = r.reimb_type_id
WHERE u.ers_username = 'employee1';

/*query for users*/
SELECT u.ers_user_id, u.ers_username, u.ers_password, u.user_first_name, u.user_last_name, u.user_email, eur.ers_user_role_id ,eur.user_role
FROM ers_users u
INNER JOIN ers_user_roles eur ON eur.ers_user_role_id = u.user_role_id;

--approve reimbursement
UPDATE ers_reimbursement 
SET reimb_status_id = 2, reimb_resolver = 1, reimb_resolved = NOW()
WHERE reimb_id = 3;



DELETE FROM ers_reimbursement WHERE reimb_id = 56;
DELETE FROM ers_users WHERE ers_user_id = 33;

/*DROP TABLES*/
/*DROP TABLE ers_reimbursement;
DROP TABLE ers_users;
DROP TABLE ers_reimbursement_status;
DROP TABLE ers_reimbursement_type;
DROP TABLE ers_user_roles;*/

SELECT * FROM ers_users;
SELECT * FROM ers_user_roles;
SELECT * FROM ers_reimbursement_status;
SELECT * FROM ers_reimbursement_type;
SELECT * FROM ers_reimbursement er;
























--truncate tables
TRUNCATE TABLE ers_users, ers_reimbursement;

--dummy values

INSERT INTO ers_users (ers_username, ers_password, user_first_name, user_last_name, user_email, user_role_id)
VALUES ('employee1', 'password123', 'Employee', 'User', 'e1@email.com', 1);

/*create a financial manager*/
INSERT INTO ers_users (ers_username, ers_password, user_first_name, user_last_name, user_email, user_role_id)
VALUES ('admin', 'vvHdCQBRifnlXe9tJ0l1dg==', 'admin', 'account', 'admin@email.com', 2);

INSERT INTO ers_reimbursement (reimb_amount, reimb_author,reimb_status_id, reimb_type_id)
VALUES (938.11,9,1,1);
INSERT INTO ers_reimbursement (reimb_amount, reimb_author,reimb_status_id, reimb_type_id)
VALUES (289.33,9,1,2);
INSERT INTO ers_reimbursement (reimb_amount, reimb_author,reimb_status_id, reimb_type_id)
VALUES (720.42,9,1,2);
INSERT INTO ers_reimbursement (reimb_amount, reimb_author,reimb_status_id, reimb_type_id)
VALUES (45.00,9,1,3);
INSERT INTO ers_reimbursement (reimb_amount, reimb_author,reimb_status_id, reimb_type_id)
VALUES (102.21,9,1,3);
INSERT INTO ers_reimbursement (reimb_amount, reimb_author,reimb_status_id, reimb_type_id)
VALUES (313.31,9,1,1);
