package connect.models;

import connect.api.Query;


/**
    Represents an account in the Connect platform, of either a Vendor or a Provider.
**/
class Account extends IdModel {
    /** Name of account object. **/
    public var name: String;


    /** Type of the account object ("vendor" or "provider"). **/
    public var type: String;


    /** Contains the `created` event, with the date when the account object was created. **/
    public var events: Events;


    /** Brand id of the account object. **/
    public var brand: String;


    /** External id of the account object. **/
    public var externalId: String;


    /**
        Whether the account has the ability to create Sourcing Agreements (is HyperProvider),
        defaults to false.
    **/
    public var sourcing: Bool;


    /**
        Lists all Accounts that match the given filters.

        @returns A Collection of Accounts.
    **/
    public static function list(filters: Query): Collection<Account> {
        final accounts = Env.getGeneralApi().listAccounts(filters);
        return Model.parseArray(Account, accounts);
    }


    /**
        Creates a new Account.

        @returns The created Account.
    **/
    public static function create(): Account {
        final account = Env.getGeneralApi().createAccount();
        return Model.parse(Account, account);
    }


    /** @returns The Account with the given id, or `null` if it was not found. **/
    public static function get(id: String): Account {
        try {
            final account = Env.getGeneralApi().getAccount(id);
            return Model.parse(Account, account);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /** @returns A Collection of Users of `this` Account. **/
    public function listUsers(): Collection<User> {
        final users = Env.getGeneralApi().listAccountUsers(this.id);
        return Model.parseArray(User, users);
    }


    /**
        @returns The User belonging to `this` Account with the given `userId`,
        or `null` if it was not found.
    **/
    public function getUser(userId: String): User {
        final users = this.listUsers().toArray().filter((user) -> user.id == userId);
        if (users.length > 0) {
            return users[0];
        } else {
            return null;
        }
    }
}
