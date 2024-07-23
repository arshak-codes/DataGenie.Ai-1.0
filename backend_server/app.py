from flask import Flask, request, jsonify, send_file
import os
import sqlite3
import google.generativeai as genai
from dotenv import load_dotenv

load_dotenv()
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

app = Flask(__name__)

def get_db_schema(db_path):
    conn = sqlite3.connect(db_path)
    cur = conn.cursor()
    cur.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = cur.fetchall()
    
    schema_info = {}
    for table in tables:
        table_name = table[0]
        cur.execute(f"PRAGMA table_info({table_name});")
        columns = cur.fetchall()
        schema_info[table_name] = [col[1] for col in columns]
    
    conn.close()
    return schema_info

def generate_prompt(schema_info):
    prompt = "You are an expert in converting English questions to SQL query!\n"
    prompt += "The SQL database has the following tables with columns:\n"
    
    for table, columns in schema_info.items():
        prompt += f"- {table}: {', '.join(columns)}\n"
    
    prompt += """
\n\nFor example,
Example 1 - How many entries of records are present in TABLE_NAME?, 
the SQL command will be something like this SELECT COUNT(*) FROM TABLE_NAME ;
\nExample 2 - Tell me all the records from TABLE_NAME where COLUMN_NAME = 'value', 
the SQL command will be something like this SELECT * FROM TABLE_NAME where COLUMN_NAME='value';
Please ensure the SQL command is a single query using JOIN or UNION as needed and never generate multiple separate SELECT statements.
"""
    return prompt

def get_gemini_response(question, db_path):
    schema_info = get_db_schema(db_path)
    prompt = generate_prompt(schema_info)
    model = genai.GenerativeModel('gemini-pro')
    response = model.generate_content([prompt, question])
    print(response)
    # Remove markdown code block delimiters if present
    response_text = response.text.strip().strip('```sql').strip('```')
    return response_text

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
    db_path = request.json.get('db_path', 'student.db')
    response = get_gemini_response(question, db_path)
    rows, column_names, executed_sql = read_sql_query(response, db_path)
    return jsonify({'columns': column_names, 'data': rows, 'sql': executed_sql})

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
    if file:
        file.save(file.filename)  # Save the uploaded file with its original name
        return jsonify({'message': 'File uploaded successfully', 'filename': file.filename}), 200

@app.route('/download', methods=['GET'])
def download_file():
    filename = 'student.db'
    return send_file(filename, as_attachment=True)

if __name__ == '__main__':
    app.run(debug=False)
