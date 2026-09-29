
# SQL Server Integration Services (SSIS)

A repository containing SQL Server Integration Services (SSIS) packages developed as part of the Data Engineering track. The project demonstrates ETL workflows, data transformation pipelines, conditional stream routing, and automated database maintenance against the **ITI** database.

---

## Project Architecture & Overview

The project extracts data from the operational source database (`ITI`), applies schema transformations and text normalization, and loads data into a staging/target database (`Test`).

### Core SSIS Components Used:
- **Control Flow:** `Execute SQL Task`, `Data Flow Task`, and `Backup Database Task`.
- **Data Flow Transformations:** `OLE DB Source`, `Derived Column`, `Sort`, `Character Map`, `Conditional Split`, `OLE DB Destination`, and `Flat File Destination`.
- **Database Administration:** Idempotent table truncation/drop scripts and automated full database backups (`.bak`).

---

## Packages Breakdown

### Package 1: Department Data Migration (`Task1_Departments.dtsx`)
Extracts department structures and loads them into the destination database with pre-execution environment setup.

- **Control Flow:**
  1. `Preparation SQL Task 1`: Prepares destination tables and clears preexisting records.
  2. `Data Flow Task 1`: Manages the extraction and load pipeline.
---

### Package 2: Student Transformation & Backup (`Task2_Students.dtsx`)
Executes an ETL flow that standardizes student names, stages them into the `Test` database, and triggers an automated database backup.

- **Control Flow Workflow:**
  1. `Clear Student if Exists` (`Execute SQL Task`): Cleans existing target student records to maintain idempotent package runs.
  2. `Copy and Transform Student Data` (`Data Flow Task`): Executes data cleansing and staging.
  3. `Backup Test Database` (`Execute SQL Task` / `Backup Task`): Triggers a full backup of the target database (`Test.bak`) upon successful data load.
- **Data Flow Pipeline (`Copy and Transform Student Data`):**
  - `Source ITI Student` (`OLE DB Source`): Pulls raw student records from `ITI`.
  - `Full name` (`Derived Column`): Derives a single student identity attribute.
  - `Destination Test` (`OLE DB Destination`): Stages cleaned student data into the destination `Test` database.

---

### Package 3: Course Partitioning & Export (`Task3_Courses.dtsx`)
Sorts course records, normalizes string casing, and routes records based on duration criteria into dedicated flat text files.

- **Data Flow Pipeline (`Split Course Data`):**
  - `Source ITI Courses` (`OLE DB Source`): Extracts course entities from `LocalHost.ITI`.
  - `Sort`: Orders course records prior to downstream transformations.
  - `Character Map`: Standardizes string case across course names (e.g., uppercase conversion).
  - `Conditional Split`: Evaluates course durations and branches records into three distinct execution streams:
    - **`Duration_LessThan_30`**: Routed to `File1 Less Than 30` (`CourseData/File1.txt`).
    - **`Duration_Equals_30`**: Routed to `File2 Equals 30` (`CourseData/File2.txt`).
    - **`Duration_GreaterThan_30`**: Routed to `File3 Greater Than 30` (`CourseData/File3.txt`).
- **Connection Managers:**
  - Database: `LocalHost.ITI`, `LocalHost.Test`
  - Flat Files: `File1_Conn`, `File2_Conn`, `File3_Conn`

---
## Repository Structure

```text
ITI-SSIS-Tasks/
├── ITI_SSIS_Tasks/
│   ├── BckupTest/
│   │   └── Test.bak                      # Target database backup output
│   ├── CourseData/
│   │   ├── File1.txt                     # Courses with Duration < 30
│   │   ├── File2.txt                     # Courses with Duration = 30
│   │   └── File3.txt                     # Courses with Duration > 30
│   ├── ITI_SSIS_Tasks.database
│   ├── ITI_SSIS_Tasks.dtproj             # SSIS project file
│   ├── Project.params                    # Package parameters
│   ├── Task1_Departments.dtsx           # Package 1
│   ├── Task2_Students.dtsx              # Package 2
│   └── Task3_Courses.dtsx               # Package 3
├── Queries/                              # Database queries and configuration scripts
├── .gitattributes
├── .gitignore
├── ITI_SSIS_Tasks.sln                    # Visual Studio Solution
└── README.md

```

---

## Prerequisites

* **SQL Server:** Microsoft SQL Server 2016+ with the sample `ITI` database attached and a target `Test` database configured.
* **Development Tool:** Visual Studio 2019/2022 with **SQL Server Integration Services Projects** extension.

---

## Getting Started

1. **Clone the repository:**
```bash
git clone [https://github.com/riham-basheer/ITI-SSIS-Tasks.git](https://github.com/riham-basheer/ITI-SSIS-Tasks.git)

```


2. **Open the Solution:**
Open `ITI_SSIS_Tasks.sln` in Visual Studio.
3. **Configure Connection Managers:**
Update `LocalHost.ITI` and `LocalHost.Test` connection strings to match your local SQL Server instance authentication credentials.
4. **File Path Verification:**
Ensure destination flat file connection managers (`File1_Conn`, `File2_Conn`, `File3_Conn`) and backup destinations point to valid paths on your local drive.
In `Task2_Students.dtsx` and `Task3_Courses.dtsx`, verify that the file paths for `BckupTest/` and `CourseData/` point to valid directories.
5. **Run:** Right-click any package (`.dtsx`) in the Solution Explorer and select **Execute Package** to test execution.
