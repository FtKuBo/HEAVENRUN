package org.heavenRun.server.infra.UserAccount;

import org.apache.catalina.User;
import org.heavenRun.server.service.UserAccount.UserAccountsDto;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserAccountRepository {
    private static final Map<String, UserAccount> accounts = new HashMap<>();

    public void saveUser (UserAccount user){
        accounts.put(user.getUserId(), user);
    }

    public UserAccount findUser(String userId){
        return accounts.get(userId);
    }

    public List<UserAccount> findAll(){
        return new ArrayList<>(accounts.values());
    }

    public void deleteUser (String userId){
        accounts.remove(userId);
    }
}
