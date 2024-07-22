from flask import Flask, request, jsonify
import os
import sqlite3
import google.generativeai as genai
from dotenv import load_dotenv

load_dotenv()
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

app = Flask(__name__)

base_prompt = """
You are an expert in converting English questions to SQL query!
The SQL database has the following tables with columns:
- STUDENT: NAME, CLASS, SECTION, MARKS
- EMPLOYEE: NAME, DEPARTMENT, SALARY
\n\nFor example,
Example 1 - How many entries of records are present in STUDENT?, 
the SQL command will be something like this SELECT COUNT(*) FROM STUDENT ;
\nExample 2 - Tell me all the students studying in Data Science class?, 
the SQL command will be something like this SELECT * FROM STUDENT where CLASS="Data Science";
\nExample 3 - List all employees in the IT department, 
the SQL command will be something like this SELECT * FROM EMPLOYEE where DEPARTMENT="IT";
\nExample 4 - Show the names which contain "sh" from both STUDENT and EMPLOYEE tables, 
the SQL command will be something like this SELECT NAME, NULL AS CLASS, NULL AS SECTION, NULL AS MARKS FROM STUDENT WHERE NAME LIKE '%sh%' 
UNION 
SELECT NAME, DEPARTMENT AS CLASS, NULL AS SECTION, SALARY AS MARKS FROM EMPLOYEE WHERE NAME LIKE '%sh%';
Please ensure the SQL command is a single query using JOIN or UNION as needed and never generate multiple separate SELECT statements.
also the sql code should not have ``` in beginning or end and sql word in output
"""

def get_gemini_response(question):
    model = genai.GenerativeModel('gemini-pro')
    response = model.generate_content([base_prompt, question])
    print(response)
    return response.text.strip()

def read_sql_query(sql, db):
    conn = sqlite3.connect(db)
    cur = conn.cursor()
    cur.execute(sql)
    rows = cur.fetchall()
    column_names = [description[0] for description in cur.description]
    print(cur.description)
    conn.commit()
    conn.close()
    return rows, column_names, sql

@app.route('/query', methods=['POST'])
def query():
    question = request.json.get('question')
    response = get_gemini_response(question)
    rows, column_names, executed_sql = read_sql_query(response, "student.db")
    return jsonify({'columns': column_names, 'data': rows, 'sql': executed_sql})

if __name__ == '__main__':
    app.run(debug=True)
