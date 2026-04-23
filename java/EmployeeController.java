package com.example.employeeapi.controller;

import com.example.employeeapi.model.Employee;
import com.example.employeeapi.repository.EmployeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController                       // marks this class as a REST API controller
@RequestMapping("/api/employees")     // all routes start with /api/employees
@CrossOrigin(origins = "*")   // ✅ ADD THIS
public class EmployeeController {

    @Autowired                        // Spring automatically injects the repository
    private EmployeeRepository repo;

    // ── GET /api/employees  ─────────────── get all employees ──
    @GetMapping
    public List<Employee> getAll() {
        return repo.findAll();
    }

    // ── GET /api/employees/{id}  ─────────── get one employee ──
    @GetMapping("/{id}")
    public ResponseEntity<Employee> getById(@PathVariable Long id) {
        return repo.findById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    // ── POST /api/employees  ─────────────── add new employee ──
    @PostMapping
    public Employee create(@RequestBody Employee employee) {
        return repo.save(employee);
    }

    // ── PUT /api/employees/{id}  ─────────── update employee ───
    @PutMapping("/{id}")
    public ResponseEntity<Employee> update(@PathVariable Long id,
                                           @RequestBody Employee updated) {
        return repo.findById(id).map(emp -> {
            emp.setName(updated.getName());
            emp.setEmail(updated.getEmail());
            emp.setDepartment(updated.getDepartment());
            emp.setSalary(updated.getSalary());
            return ResponseEntity.ok(repo.save(emp));
        }).orElse(ResponseEntity.notFound().build());
    }

    // ── DELETE /api/employees/{id}  ──────── delete employee ───
    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable Long id) {
        if (!repo.existsById(id)) return ResponseEntity.notFound().build();
        repo.deleteById(id);
        return ResponseEntity.ok("Employee deleted successfully");
    }
}
