package org.heavenRun.server.api.UserAccount;

import org.heavenRun.server.infra.UserAccount.UserAccount;
import org.heavenRun.server.infra.UserAccount.UserAccountRepository;
import org.heavenRun.server.service.UserAccount.CreateUserAccountDto;
import org.heavenRun.server.service.UserAccount.UserAccountDto;
import org.heavenRun.server.service.UserAccount.UserAccountService;
import org.heavenRun.server.service.UserAccount.UserAccountsDto;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
@RestController
public class UserAccountController {

    private final UserAccountService userAccountService;

    public UserAccountController() {
        userAccountService = new UserAccountService();
    }

    @PostMapping("/accounts")
    public UserAccountDto postAccount(@RequestBody CreateUserAccountDto dto) {
        return userAccountService.createUser(dto);
    }

    // to rethink
    @PutMapping("/accounts/{id}")
    public UserAccountDto putAccount(@PathVariable String id, @RequestBody CreateUserAccountDto dto) {
        return userAccountService.updateUser(id, dto);
    }

    @GetMapping("/accounts/{id}")
    public UserAccountDto getAccount(@PathVariable String id) {
        return userAccountService.getUser(id);
    }

    @GetMapping("/accounts")
    public UserAccountsDto getAccounts(){
        return userAccountService.getAllUsers();
    }

    @DeleteMapping("/accounts/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteAccount(@PathVariable String id) {
        userAccountService.deleteUser(id);
    }

}
