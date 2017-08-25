@isTest
private class Filter_Tests {
    static final Id leadId = '00Q000000000000';
    static final Id accountId = '001000000000000';
    static final Id contactId = '003000000000000';
    static final String testString = 'test@test.com';

    @isTest
    static void it_should_remove_matching_items_from_one_list_and_add_to_new_list() {
        Account a = new Account(Name = 'Hi');
        List<Account> accs = new List<Account>{ a };

        Filter that = Filter.the(accs).byField(Account.Name);
        System.assertEquals(0, accs.size());
        System.assert(that.to.filteredSet().contains(a));
    }

    @isTest
    static void it_should_remove_items_from_one_list_using_conditional() {
        Lead lead = new Lead(NumberOfEmployees = 5);
        List<Lead> leads = new List<Lead>{ lead };

        Filter that = Filter.the(leads)
            .whereField(Schema.Lead.NumberOfEmployees)
            .greaterThan(2);

        System.assertEquals(false, leads.isEmpty());

        that.greaterThan(7);
        System.assertEquals(true, leads.isEmpty());
    }

    @isTest
    static void it_should_return_map_of_filtered_values() {
        Lead l = new Lead(Id = leadId, FirstName = 'James');

        Map<Id, SObject> filteredMap = Filter.the(new List<Lead>{ l })
            .byField(Lead.FirstName)
            .to
            .filteredMap();

        System.assertEquals(true, filteredMap.containsKey(l.Id));
    }

    @isTest
    static void it_should_update_list_field_reference_in_map_with_matching_field_ref_from_other_map() {
        Map<String, Contact> contactMap = new Map<String, Contact>{ testString => new Contact(Email = testString) };
        Map<String, Account> accountMap = new Map<String, Account>{ testString => new Account(Id = accountId) };

        Filter.the((Map<String, SObject>) contactMap)
            .whereField(Contact.AccountId)
            .is(null)
            .andReplaceWithValueFrom(accountMap, Account.Id, Contact.AccountId);

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
            .andReplaceWithValueFrom(accountMap, Account.Id, Contact.AccountId);

        Contact con = contactMap.get(contactId);
        System.assertEquals(accountId, con.AccountId);
    }
}