package org.heavenRun.server.infra.UserAccount;

import java.util.HashMap;
import java.util.Map;

public class UserAccount {
    private String UserName;
    private String UserId;
    private Map<String, String> UserRuns;

    public UserAccount(String UserName, String UserId, Map<String, String> UserRuns){
        this.UserName = UserName;
        this.UserId = UserId;
        this.UserRuns = UserRuns;
    }

    public UserAccount(String UserName, String UserId){
        this.UserName = UserName;
        this.UserId = UserId;
        this.UserRuns = new HashMap<>();
    }

    public String getUserName() {return UserName; }

    public String getUserId() {
        return UserId;
    }

    public Map<String, String> getUserRuns(){
        return UserRuns;
    }
}
