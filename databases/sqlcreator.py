import sqlite3

# Connect to the new SQLite database
connection = sqlite3.connect("business.db")

# Create a cursor object to execute SQL commands
cursor = connection.cursor()

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
employees = [
    ('ARSHAK', 'IT', 90000),
    ('AFEEF', 'HR', 100000)
]

# Adding more records
import random
names = ['Arjun', 'Vikas', 'Harish', 'Anjali', 'Sana', 'Vijay', 'Suresh', 'Ravi', 'Geetha', 'Krishna']
departments = ['IT', 'HR', 'Finance', 'Marketing', 'Sales']
for i in range(98):  # Total 100 entries
    employees.append((random.choice(names), random.choice(departments), random.randint(40000, 120000)))

cursor.executemany("INSERT INTO EMPLOYEE (NAME, DEPARTMENT, SALARY) VALUES (?, ?, ?)", employees)

# Create the DEPARTMENT table
table_info_department = """
CREATE TABLE IF NOT EXISTS DEPARTMENT (
    DEPT_NAME VARCHAR(25),
    DEPT_HEAD VARCHAR(25)
);
"""
cursor.execute(table_info_department)

# Insert records into the DEPARTMENT table
departments_data = [
    ('IT', 'John Doe'),
    ('HR', 'Jane Smith'),
    ('Finance', 'Emily Davis'),
    ('Marketing', 'Michael Johnson'),
    ('Sales', 'William Brown')
]

cursor.executemany("INSERT INTO DEPARTMENT (DEPT_NAME, DEPT_HEAD) VALUES (?, ?)", departments_data)

# Create the SALES table
table_info_sales = """
CREATE TABLE IF NOT EXISTS SALES (
    SALE_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    SALE_DATE DATE,
    CUSTOMER_NAME VARCHAR(25),
    AMOUNT INT
);
"""
cursor.execute(table_info_sales)

# Insert records into the SALES table
sales = [
    ('2023-07-01', 'Customer1', 1500),
    ('2023-07-02', 'Customer2', 2300),
    ('2023-07-03', 'Customer3', 4500),
    ('2023-07-04', 'Customer4', 1200),
    ('2023-07-05', 'Customer5', 7800)
]

# Adding more records
for i in range(95):  # Total 100 entries
    sales.append((f'2023-07-{random.randint(1, 30):02}', random.choice(names), random.randint(1000, 10000)))

cursor.executemany("INSERT INTO SALES (SALE_DATE, CUSTOMER_NAME, AMOUNT) VALUES (?, ?, ?)", sales)

# Display all records from EMPLOYEE table
print("The inserted records in EMPLOYEE table are:")
data = cursor.execute("SELECT * FROM EMPLOYEE")
for row in data:
    print(row)

# Display all records from DEPARTMENT table
print("The inserted records in DEPARTMENT table are:")
data = cursor.execute("SELECT * FROM DEPARTMENT")
for row in data:
    print(row)

# Display all records from SALES table
print("The inserted records in SALES table are:")
data = cursor.execute("SELECT * FROM SALES")
for row in data:
    print(row)

# Commit your changes in the database
connection.commit()
connection.close()
