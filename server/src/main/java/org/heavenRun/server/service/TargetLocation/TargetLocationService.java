package org.heavenRun.server.service.TargetLocation;

import org.heavenRun.server.infra.TargetLocation.TargetLocation;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

//TODO
// fix error NAN generated with target longitude
//  add null checks
//  handle errors

public class TargetLocationService {
    public TargetLocation getTargetLocation(Map<String,Double> input){
        double INIT_LATITUDE = input.get("latitude");
        double INIT_LONGITUDE = input.get("longitude");
        double DISTANCE = input.get("distance");
        double RAYON = 6371;

        double TARGET_LATITUDE = ThreadLocalRandom.current().nextDouble(-90.00000,90.00000);
        double TARGET_LONGITUDE = 2 * Math.asin( Math.sqrt( ( Math.pow( Math.sin( (DISTANCE*RAYON) / 2 ) , 2) - Math.pow( Math.sin( (TARGET_LATITUDE - INIT_LATITUDE) / 2 ) , 2) ) / ( Math.cos(INIT_LATITUDE) * Math.cos(TARGET_LATITUDE) ) ) ) + INIT_LONGITUDE;

        return new TargetLocation(TARGET_LATITUDE,TARGET_LONGITUDE);
    }

    public Map<String, Double> TestGetTargetLocation(Map<String,Double> input){
        double INIT_LATITUDE = input.get("latitude");
        double INIT_LONGITUDE = input.get("longitude");
        double DISTANCE = input.get("distance");
        double RAYON = 6371;
        boolean isNegatif = false;

        double TARGET_LATITUDE = ThreadLocalRandom.current().nextDouble(-90.00000,90.00000);
        double TARGET_LONGITUDE = Math.sqrt( Math.abs( ( Math.pow( Math.sin( (DISTANCE*RAYON) / 2 ) , 2) - Math.pow( Math.sin( (TARGET_LATITUDE - INIT_LATITUDE) / 2 ) , 2) ) / ( ( Math.cos(INIT_LATITUDE) * Math.cos(TARGET_LATITUDE) ) ) ) ) ;
        double TEST_WITHOUT_SQRT =  ( Math.pow( Math.sin( (DISTANCE*RAYON) / 2 ) , 2) - Math.pow( Math.sin( (TARGET_LATITUDE - INIT_LATITUDE) / 2 ) , 2) ) / ( Math.cos(INIT_LATITUDE) * Math.cos(TARGET_LATITUDE) );
        if(TEST_WITHOUT_SQRT < 0){
            isNegatif = true;
        }
        Map<String, Double> testOutput = new HashMap<>();
        testOutput.put("latitude", TARGET_LATITUDE);
        testOutput.put("longitude", TARGET_LONGITUDE);
        if(isNegatif){
            testOutput.put("longitude", -1 * TARGET_LONGITUDE);
        }

        return testOutput;
        // problem the value in test without sqrt is negative
        // find a way to solve that
    }
}
