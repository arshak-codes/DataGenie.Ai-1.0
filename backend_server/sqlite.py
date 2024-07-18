import sqlite3

# Connect to SQLite
connection = sqlite3.connect("student.db")

# Create a cursor object to insert records and create tables
cursor = connection.cursor()

# Create the STUDENT table
table_info_student = """
CREATE TABLE IF NOT EXISTS STUDENT (
    NAME VARCHAR(25),
    CLASS VARCHAR(25),
    SECTION VARCHAR(25),
    MARKS INT
);
"""
cursor.execute(table_info_student)

# Insert records into the STUDENT table
cursor.execute("INSERT INTO STUDENT VALUES ('Krish', 'Data Science', 'A', 90)")
cursor.execute("INSERT INTO STUDENT VALUES ('Sudhanshu', 'Data Science', 'B', 100)")
cursor.execute("INSERT INTO STUDENT VALUES ('Darius', 'Data Science', 'A', 86)")
cursor.execute("INSERT INTO STUDENT VALUES ('Vikash', 'DEVOPS', 'A', 50)")
cursor.execute("INSERT INTO STUDENT VALUES ('Dipesh', 'DEVOPS', 'A', 35)")

# Create the EMPLOYEE table
table_info_employee = """
CREATE TABLE IF NOT EXISTS EMPLOYEE (
    NAME VARCHAR(25),
    DEPARTMENT VARCHAR(25),
    SALARY INT
);
"""
cursor.execute(table_info_employee)

# Insert records into the EMPLOYEE table
cursor.execute("INSERT INTO EMPLOYEE VALUES ('ARSHAK', 'IT', 90000)")
cursor.execute("INSERT INTO EMPLOYEE VALUES ('AFEEF', 'HR', 100000)")

# Display all records from STUDENT table
print("The inserted records in STUDENT table are:")
data = cursor.execute("SELECT * FROM STUDENT")
for row in data:
    print(row)

# Display all records from EMPLOYEE table
print("The inserted records in EMPLOYEE table are:")
data = cursor.execute("SELECT * FROM EMPLOYEE")
for row in data:
    print(row)

# Commit your changes in the database
connection.commit()
connection.close()
