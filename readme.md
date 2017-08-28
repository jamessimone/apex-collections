## Apex Collections - chaining support for filtering Apex collections.

Salesforce's Apex implementation of Java has no support for lambdas, which makes working with the equivalent of IEnumerable<T> collections tiresome. Repeated "for(...) { method body }" loops abound
in Apex code.

Filter is a static helper class that can be chained to filter lists / other collections to:
1. Update existing SObject values with the help of a map with matching key value
2. Remove existing elements from a collection based on field level comparisons to a given value
3. Improve readability of code by drawing attention towards the intent of each iteration instead of the actual looping mechanic through collections.

### Example usage


    List<SObject> filteredList = Filter.the(List<SObject> myList)
        .byField(Schema.SObjectField myField)
        .to
        .filteredList()

    Filter.the(List<SObject> myList)
        .whereField(Schema.SObjectField myField)
        .equals(Object valueOfMyFieldForAnyMatchingElement)

    Filter.the((Map<Id or String, SObject>) contactMap)
        .whereField(Schema.SObjectField myField)
        .is(null)
        .andReplaceFieldWithValueFrom(Schema.SObjectField fieldInBaseCollection, Map<Id or String, SObject> relatedMap, Schema.SObjectField fieldInRelatedMapToTakeValueFrom);

    Set<SObject> filteredSet = Filter.the(List<SObject> myList)
        .whereField(Schema.SObjectField myField)
        .isNot(null)
        .gather
        .also
        .whereField(Schema.SObjectField anotherField)
        .equals(Object valueThatWhereFieldShouldEqual)
        .gatherTo
        .filteredSet();

* first example returns List<SObject> with any elements removed from the first collection. Depending on your use case, you may not care about the return value. If that's the case, you can drop the ".to.filteredList()" part.

* Maps require a cast to (Map<Id, SObject>) or (Map<String, SObject>).  The second parameter in "andReplaceFieldWithValueFrom" is a map that needs to have a matching key value!  Useful if you are working with multiple maps at a time and need to update values in the first map with a field value from the second.

* Some functions / property calls are optional.  "also" , and "to" are merely there to assist in the readability.  If your list comprehensions level is over 9000, you may of course abstain from such things.