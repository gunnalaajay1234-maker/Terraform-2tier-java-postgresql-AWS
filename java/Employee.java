package com.example.employeeapi.model;

import jakarta.persistence.*;     // JPA annotations

@Entity                           // tells JPA: this class = a database table
@Table(name = "employees")        // the actual table name in PostgreSQL
public class Employee {

    @Id                           // primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY)  // auto-increment
    private Long id;

    @Column(nullable = false)     // this column cannot be empty
    private String name;

    @Column(unique = true, nullable = false)  // must be unique, cannot be empty
    private String email;

    private String department;
    private Double salary;

    // ── No-argument constructor (required by JPA) ──
    public Employee() {}

    // ── Constructor with fields ──
    public Employee(String name, String email, String department, Double salary) {
        this.name       = name;
        this.email      = email;
        this.department = department;
        this.salary     = salary;
    }

    // ── Getters ──
    public Long   getId()         { return id; }
    public String getName()       { return name; }
    public String getEmail()      { return email; }
    public String getDepartment() { return department; }
    public Double getSalary()     { return salary; }

    // ── Setters ──
    public void setName(String name)             { this.name = name; }
    public void setEmail(String email)           { this.email = email; }
    public void setDepartment(String department) { this.department = department; }
    public void setSalary(Double salary)         { this.salary = salary; }
}
