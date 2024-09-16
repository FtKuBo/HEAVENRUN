package org.heavenRun.server.api.TargetLocation;

import org.heavenRun.server.infra.TargetLocation.TargetLocation;
import org.heavenRun.server.service.TargetLocation.TargetLocationService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class TargetLocationController {
    private final TargetLocationService targetLocationService;

    public TargetLocationController(){targetLocationService = new TargetLocationService();}

    @GetMapping("/targetLocation")
    public TargetLocation getTargetLocation(@RequestBody Map<String,Double> input){
        return targetLocationService.getTargetLocation(input);
    }

    @GetMapping("/testTargetLocation")
    public Map<String, Double>  TestGetTargetLocation(@RequestBody Map<String, Double> input){
        return targetLocationService.TestGetTargetLocation(input);
    }
}
