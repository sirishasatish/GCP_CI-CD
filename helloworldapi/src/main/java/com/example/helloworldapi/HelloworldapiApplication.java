package com.example.helloworldapi;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class HelloworldapiApplication {

    public static void main(String[] args) {
        SpringApplication.run(HelloworldapiApplication.class, args);
    }

    @RestController
    class HelloWorldController {

        @GetMapping("/hello")
        public String helloWorld() {
            return "Hello World";
        }
    }
}

