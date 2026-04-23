<!DOCTYPE html>
<html>
<head>
    <title>Employee Directory</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #c3d7f7;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
        }

        .container {
            margin-top: 50px;
            width: 420px;
            background: #ffffff;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        h1 {
            text-align: center;
            margin-bottom: 20px;
        }

        .form-row {
            display: flex;
            align-items: center;
            margin-bottom: 12px;
        }

        label {
            width: 110px;
            font-weight: bold;
        }

        input {
            flex: 1;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 6px;
            outline: none;
        }

        input:focus {
            border-color: #4a90e2;
        }

        button {
            width: 100%;
            margin-top: 15px;
            padding: 10px;
            background: #4cf966;
            color: rgb(0, 0, 0);
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }

        button:hover {
            background: #f5de11;
        }

        ul {
            list-style: none;
            padding: 0;
            margin-top: 20px;
        }

        li {
            background: #f4f6f8;
            padding: 10px;
            margin-bottom: 8px;
            border-radius: 8px;
        }
    </style>
</head>

<body>

<div class="container">
    <h1>Employee Directory 🧑‍💼 </h1>

    <div class="form-row">
        <label>Name :</label>
        <input type="text" id="name">
    </div>

    <div class="form-row">
        <label>Department :</label>
        <input type="text" id="department">
    </div>

    <div class="form-row">
        <label>Email :</label>
        <input type="email" id="email">
    </div>

    <div class="form-row">
        <label>Salary :</label>
        <input type="number" id="salary">
    </div>

    <button onclick="addEmployee()">Add Employee</button>

    <ul id="list"></ul>
</div>

<script>
    async function addEmployee() {
        let name = document.getElementById("name").value.trim();
        let department = document.getElementById("department").value.trim();
        let email = document.getElementById("email").value.trim();
        let salary = document.getElementById("salary").value.trim();

        if (!name) {
            alert("Name is required");
            return;
        }

        if (!department) department = "None";
        if (!email) email = "None";
        if (!salary) salary = 0;

        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (email !== "None" && !emailPattern.test(email)) {
            alert("Invalid email");
            return;
        }

        await fetch("/api/employees", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                name,
                department,
                email,
                salary: Number(salary)
            })
        });

        document.getElementById("name").value = "";
        document.getElementById("department").value = "";
        document.getElementById("email").value = "";
        document.getElementById("salary").value = "";

        loadEmployees();
    }

    async function loadEmployees() {
        const res = await fetch("/api/employees");
        const data = await res.json();

        document.getElementById("list").innerHTML =
            data.map(e => `
                <li>
                    <b>$${e.name}</b><br>
                    Dept: $${e.department} | Email: $${e.email} | Salary: ₹$${e.salary}
                </li>
            `).join("");
    }

    loadEmployees();
</script>

</body>
</html>