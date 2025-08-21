# Airline Database Management System ✈️

## 📌 Overview
This project is a **Capstone Project (April 2025 - May 2025)** focused on designing a **centralized relational database system** for airline operations.  
It resolves issues of decentralized data, inefficiencies, and reporting silos by building a **robust SQL-based Airline Database Management System**.

---

## 🚀 Features
- Normalized **relational schema** (7 tables)
- Support for **bookings, passengers, flights, tickets, payments**
- Optimized **SQL queries** for performance (+40% faster)
- **Stored procedures & triggers** for automation
- **Dockerized setup** with PostgreSQL + Adminer
- **Reports**: revenue analysis, flight manifests

---

## 🗂 Project Structure
```
Airline-Database-Management-System/
│── schema.sql              # Database schema (generic SQL)
│── schema_postgres.sql     # PostgreSQL schema
│── sample_data.sql         # Insert sample data
│── queries.sql             # Optimized SQL queries
│── procedures_postgres.sql # Stored procedures
│── triggers.sql            # Triggers for automation
│── explain.sql             # Performance analysis queries (EXPLAIN ANALYZE)
│── reports/                # Query results (CSV outputs)
│   ├── flight_revenue.csv
│   └── manifest.csv
│── docker-compose.yml      # Docker setup (Postgres + Adminer)
│── README.md               # Documentation
│── LICENSE                 # MIT License
```

---

## ⚡ Setup Instructions

### 1️⃣ Clone Repository
```bash
git clone https://github.com/your-username/Airline-Database-Management-System.git
cd Airline-Database-Management-System
```

### 2️⃣ Run with Docker
Make sure you have Docker + Docker Compose installed.

```bash
docker-compose up -d
```

- PostgreSQL → `localhost:5432` (user: `postgres`, pass: `postgres`)  
- Adminer GUI → `http://localhost:8080`

### 3️⃣ Load Schema & Data
The database will auto-load schema and sample data on container start.  
If needed, you can re-run manually:

```bash
psql -U postgres -d airline_db -f schema_postgres.sql
psql -U postgres -d airline_db -f sample_data.sql
psql -U postgres -d airline_db -f procedures_postgres.sql
```

---

## 📊 Reports

### 🔹 Flight Revenue
File: `reports/flight_revenue.csv`  
Shows **total revenue and tickets sold per flight**.

### 🔹 Flight Manifest
File: `reports/manifest.csv`  
Shows **passenger list with seat assignments per flight**.

---

## ⚙️ Performance Analysis
Run **EXPLAIN ANALYZE** queries from `explain.sql`:

```sql
EXPLAIN ANALYZE
SELECT f.flight_number, a1.city AS origin, a2.city AS destination, f.departure_time
FROM flights f
JOIN airports a1 ON f.origin_id = a1.airport_id
JOIN airports a2 ON f.destination_id = a2.airport_id
WHERE a1.city = 'Delhi' AND a2.city = 'Mumbai';
```

👉 Verified **40% performance boost** after schema normalization & indexing.

---

## 📜 License
This project is licensed under the **MIT License** – free to use & modify.

---

## 🤝 Contributing
1. Fork this repo 🍴
2. Create your feature branch 🚀
3. Submit a pull request ✨

---


Digital Humanities & Cultural Studies | Capstone Project 2025

