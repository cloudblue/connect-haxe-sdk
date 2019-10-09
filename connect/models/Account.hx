package connect.models;

import connect.api.QueryParams;


/**
    Represents an account in the Connect platform, of either a Vendor or a Provider.
**/
class Account extends IdModel {
    /** Name of account object. **/
    public var name(default, null): String;


    /** Type of the account object ("vendor" or "provider"). **/
    public var type(default, null): String;


    /** Contains the `created` event, with the date when the account object was created. **/
    public var events(default, null): Events;


    /** Brand id of the account object. **/
    public var brand(default, null): String;


    /** External id of the account object. **/
    public var externalId(default, null): String;


    /**
        Whether the account has the ability to create Sourcing Agreements (is HyperProvider),
        defaults to false.
    **/
    public var sourcing(default, null): Bool;


    /**
        Lists all Accounts that match the given filters.

        @returns A Collection of Accounts.
    **/
    public static function list(filters: QueryParams): Collection<Account> {
        var accounts = Environment.getGeneralApi().listAccounts(filters);
        return Model.parseArray(Account, accounts);
    }


    /**
        Creates a new Account.

        @returns The created Account.
    **/
    public static function create(): Account {
        var account = Environment.getGeneralApi().createAccount();
        return Model.parse(Account, account);
    }


    /** @returns The Account with the given id, or `null` if it was not found. **/
    public static function get(id: String): Account {
        try {
            var account = Environment.getGeneralApi().getAccount(id);
            return Model.parse(Account, account);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /** @returns A Collection of Users of `this` Account. **/
    public function listUsers(): Collection<User> {
        var users = Environment.getGeneralApi().listAccountUsers(this.id);
        return Model.parseArray(User, users);
    }


    /**
        @returns The User belonging to `this` Account with the given `userId`,
        or `null` if it was not found.
    **/
    public function getUser(userId: String): User {
        var users = this.listUsers().toArray().filter(function(user) {
            return user.id == userId;
        });
        if (users.length > 0) {
            return users[0];
        } else {
            return null;
        }
    }
}
