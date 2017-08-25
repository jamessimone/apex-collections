@isTest
private class Filter_Tests {
    @isTest
    static void it_should_remove_matching_items_from_one_list_and_add_to_new_list() {
        List<Account> accounts = new List<Account>{ acc };

        Filter that = Filter.the(accounts).byField(Account.Name);
        System.assertEquals(0, accounts.size());
        System.assert(that.to.filteredSet().contains(acc));
    }

    @isTest
    static void it_should_remove_items_from_list_using_greater_than_conditional() {
        ld.NumberOfEmployees = 5;
        List<Lead> leads = new List<Lead>{ ld };

        Filter that = Filter.the(leads)
            .whereField(Schema.Lead.NumberOfEmployees)
            .greaterThan(2);

        System.assertEquals(false, leads.isEmpty());

        that.greaterThan(7);
        System.assertEquals(true, leads.isEmpty());
    }

    @isTest
    static void it_should_remove_items_from_list_using_less_than_conditional() {
        ld.NumberOfEmployees = 5;
        List<Lead> leads = new List<Lead>{ ld };

        Filter that = Filter.the(leads)
            .whereField(Lead.NumberOfEmployees)
            .lessThan(7);

        System.assertEquals(false, leads.isEmpty());

        that.lessThan(2);
        System.assertEquals(true, leads.isEmpty());
    }

    @isTest
    static void it_should_remove_items_from_list_using_equals_than_conditional() {
        ld.NumberOfEmployees = 5;
        List<Lead> leads = new List<Lead>{ ld };

        Filter that = Filter.the(leads)
            .whereField(Lead.NumberOfEmployees)
            .equals(7);

        System.assertEquals(false, leads.isEmpty());

        that.equals(5);
        System.assertEquals(true, leads.isEmpty());
    }

    @isTest
    static void it_should_return_map_of_filtered_values() {
        Map<Id, SObject> filteredMap = Filter.the(new List<Lead>{ ld })
            .byField(Lead.FirstName)
            .to
            .filteredMap();

        System.assertEquals(true, filteredMap.containsKey(ld.Id));
    }

    @isTest
    static void it_should_update_list_field_reference_in_map_with_matching_field_ref_from_other_map() {
        Map<String, Contact> contactMap = new Map<String, Contact>{ testString => new Contact(Email = testString) };
        Map<String, Account> accountMap = new Map<String, Account>{ testString => new Account(Id = accountId) };

        Filter.the((Map<String, SObject>) contactMap)
            .whereField(Contact.AccountId)
            .is(null)
            .andReplaceFieldWithValueFrom(Contact.AccountId, accountMap, Account.Id);

        Contact con = contactMap.get(testString);
        System.assertEquals(accountId, con.AccountId);
    }

    @isTest
    static void it_should_treat_ids_as_strings_when_working_with_maps() {
        Map<Id, Contact> contactMap = new Map<Id, Contact> { contactId => new Contact(Id = contactId) };
        Map<Id, Account> accountMap = new Map<Id, Account> { contactId => new Account(Id = accountId) };

        Filter.the((Map<Id, SObject>) contactMap)
            .whereField(Contact.AccountId)
            .is(null)
            .andReplaceFieldWithValueFrom(Contact.AccountId, accountMap, Account.Id);

        Contact con = contactMap.get(contactId);
        System.assertEquals(accountId, con.AccountId);
    }

    @isTest
    static void it_should_return_elements_that_match_criteria_to_filtered_set() {
        List<Account> accounts = new List<Account> { acc };

        Set<SObject> filteredObjects = Filter.the(accounts)
            .whereField(Account.Id)
            .isNot(null)
            .gatherTo
            .filteredSet();

        System.assertEquals(true, filteredObjects.contains(acc));
    }

    @isTest
    static void it_should_track_the_index_correctly_when_moving_elements() {
        Account a = new Account(Name = 'A');
        Account b = new Account(Name = 'B');
        Account c = new Account(Name = 'C');
        List<Account> accounts = new List<Account>{ a, b, c};

        Set<SObject> filtered = Filter.the(accounts)
            .whereField(Account.Name)
            .equals('A')
            .also
            .equals('B')
            .to
            .filteredSet();

        System.assertEquals(true, filtered.contains(a));
        System.assertEquals(true, filtered.contains(b));
        System.assertEquals(1, accounts.size());
    }

    static final Id leadId = '00Q000000000000';
    static final Id accountId = '001000000000000';
    static final Id contactId = '003000000000000';
    static final String testString = 'test@test.com';
    static final Lead ld = new Lead(Id = leadId, FirstName = 'Bird', LastName = 'Person');
    static final Account acc =  new Account(Id = accountId, Name = 'Morty');
    static final Contact con = new ContacT(Id = contactId, FirstName = 'Pencil', LastName = 'Vester');
}