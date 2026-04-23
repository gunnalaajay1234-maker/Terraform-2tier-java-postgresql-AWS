package com.example.employeeapi.repository;

import com.example.employeeapi.model.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
// JpaRepository<Employee, Long> provides:
//   findAll()         - get all employees
//   findById(id)      - get one employee by ID
//   save(employee)    - insert or update an employee
//   deleteById(id)    - delete an employee
//   existsById(id)    - check if employee exists
// No code needed - Spring generates the implementation automatically!
public interface EmployeeRepository extends JpaRepository<Employee, Long> {
}
