package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * HelloController - the only controller in this project.
 * Maps GET / to the hello.jsp view.
 */
@Controller
public class HelloController {

    @GetMapping("/")
    public String hello(Model model) {
        model.addAttribute("message", "Hello from Spring Boot WAR on Tomcat!");
        return "hello"; // resolves to /WEB-INF/views/hello.jsp
    }

}