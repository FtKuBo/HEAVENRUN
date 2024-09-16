package org.heavenRun.server.api;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
public class HomeController {
    @GetMapping("/")
    public String getHome(){
        return "THE SERVER IS RUNNING...";
    }
}
