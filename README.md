# DataGenie

DataGenie is a powerful tool designed for efficient database management and querying. Developed for a hackathon, DataGenie leverages the power of large language models to convert user queries into SQL, making database interaction more intuitive and accessible.

## Features

- **Easy Database Upload:** Quickly upload databases to the app with the "Upload Database" button.
- **Intuitive Querying:** Convert natural language queries into SQL using large language models.
- **Sample Queries:** Perform various sample queries such as:
  - Retrieve details of the branch situated in London.
  - Retrieve details of the staff whose name is David Ford.
  - Retrieve staff and branch details of the staff who work as an assistant.
  - Retrieve distinct salaries from staff.
  - Find the average salary of staff.
  - Find the details of staff whose salary is greater than or equal to the average salary.
  - Find the maximum and minimum salary of staff.
- **Export Results:** Export query results to a CSV file with the "Download CSV" button.
- **Multi-Platform Support:** Built with Flutter, DataGenie runs seamlessly on Windows, Linux, Mac, Android, and more.

## Installation

To get started with DataGenie, follow these steps:

1. **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/datagenie.git
    cd datagenie
    ```

2. **Install dependencies:**
    - For the frontend:
        ```bash
        cd frontend
        flutter pub get
        ```
    - For the backend:
        ```bash
        cd backend
        pip install -r requirements.txt
        ```

3. **Run the app:**
    - Start both the frontend and backend services using the provided Bash script:
        ```bash
        ./start_app.sh
        ```

## Usage

1. **Start the app:**
    Launch the app by clicking the "Start App" button, which runs a Bash script to start both the frontend and backend services.

2. **Upload a database:**
    Click the "Upload Database" button to add new databases to DataGenie. A success message will confirm that the database is connected.

3. **Run sample queries:**
    Use the app to run various sample queries. The results and corresponding SQL code will be displayed in the app.

4. **Export results:**
    Click the "Download CSV" button to save query results to a CSV file.

## Technologies Used

- **Frontend:** Flutter
- **Backend:** Flask
- **Natural Language Processing:** Large language models for converting user queries to SQL

## Contributing

We welcome contributions to DataGenie! If you'd like to contribute, please fork the repository and submit a pull request.

## License

This project is licensed under the MIT License.

## Acknowledgements

We would like to thank everyone who contributed to the development of DataGenie and the hackathon organizers for providing the platform to showcase our project.

---

Thank you for using DataGenie! We hope it simplifies your database management and querying process.
