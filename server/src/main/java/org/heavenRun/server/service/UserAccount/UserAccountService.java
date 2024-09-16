package org.heavenRun.server.service.UserAccount;

import org.heavenRun.server.infra.UserAccount.UserAccount;
import org.heavenRun.server.infra.UserAccount.UserAccountRepository;

import java.util.List;

//TODO
//  add null checks
//  handle the situation when the user isn't found in getUser and updateUser

public class UserAccountService {
    private final UserAccountRepository userAccountRepository;

    public UserAccountService() {
        userAccountRepository = new UserAccountRepository();
    }

    public UserAccountDto createUser(CreateUserAccountDto dto){
        if(userAccountRepository.findUser(dto.userId) != null)
            throw new RuntimeException(String.format("The user {%s} already exist", dto.userId));

        UserAccount userAccount = toUserAccount(dto);
        userAccountRepository.saveUser(userAccount);
        return toUserAccountDto(userAccount);
    }

    public UserAccountDto getUser(String userId){
        UserAccount userAccount = userAccountRepository.findUser(userId);
        return toUserAccountDto(userAccount);
    }

    public UserAccountsDto getAllUsers(){
        List<UserAccountDto> accounts = userAccountRepository.findAll().stream().map(this :: toUserAccountDto).toList();
        UserAccountsDto userAccountsDto = new UserAccountsDto();
        userAccountsDto.userAccounts = accounts;
        return userAccountsDto;
    }

    public UserAccountDto updateUser(String userId, CreateUserAccountDto dto){
        if(userAccountRepository.findUser(userId) == null )
            throw new RuntimeException(String.format("The user {%s} doesn't exist",userId));

        if(userAccountRepository.findUser(dto.userId) != null)
            throw new RuntimeException(String.format("The user {%s} already exist", dto.userId));

        UserAccountDto userAccountDto = toUserAccountDto(userAccountRepository.findUser(userId));
        userAccountRepository.deleteUser(userAccountDto.userId);
        userAccountDto.userId = dto.userId;
        userAccountDto.userName = dto.userName;
        userAccountRepository.saveUser(toUserAccount(userAccountDto));
        return userAccountDto;
    }

    public void deleteUser(String userId){
        userAccountRepository.deleteUser(userId);
    }
    private UserAccountDto toUserAccountDto(UserAccount userAccount){
        UserAccountDto dto = new UserAccountDto();
        dto.userName = userAccount.getUserName();
        dto.userId = userAccount.getUserId();
        dto.userRuns = userAccount.getUserRuns();
        return dto;
    }

    private UserAccount toUserAccount(CreateUserAccountDto dto){
        return new UserAccount(dto.userName, dto.userId);
    }

    private UserAccount toUserAccount(UserAccountDto dto){
        return new UserAccount(dto.userName, dto.userId, dto.userRuns);
    }
}