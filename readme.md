## Apex Collections - chaining support for filtering Apex collections.

Filter is a statically called helper class that can be chained to filter lists / other collections to:
1. Update existing SObject values with the help of a map with matching key value
2. Remove existing elements from a collection based on field level comparisons to a given value

### Example usage


    Filter.the(List<SObject> myList)
        .byField(Schema.SObjectField myField)
        .to
        .filteredList()

    Filter.the(List<SObject> myList)
        .whereField(Schema.SObjectField myField)
        .equals(Object valueOfMyFieldForAnyMatchingElement)

    Filter.the((Map<Id or String, SObject>) contactMap)
        .whereField(Contact.AccountId)
        .is(null)
        .andReplaceFieldWithValueFrom(Contact.AccountId, Map<Id or String, SObject> accountMap, Account.Id);

* first example returns List<SObject> with any elements removed from the first collection. Depending on your use case, you may not care about the return value. If that's the case, you can drop the ".to.filteredList()" part.

* Maps require a cast to (Map<Id, SObject>) or (Map<String, SObject>).  The second parameter in "andReplaceWithValueFrom" is a map that needs to have a matching key value!  Useful if you are working with multiple maps at a time and need to update values in the first map with a field value from the second.