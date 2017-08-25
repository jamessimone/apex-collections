public class Filter {
    private final List<SObject> collection;
    private final Set<SObject> filtered;
    private final Map<String, SObject> mapCollection;
    private final Map<Id, SObject> mapIdCollection;
    private final Map<String, SObject> mapOfMaps;
    private String whereField;
    private String index;
    private Object value;
    private SObject ref;

    private Filter() {
        this.filtered = new Set<SObject>();
        this.index = '0';
        this.value = 0;
        this.mapOfMaps = new Map<String, SObject>();
    }

    private Filter(List<SObject> collection) {
        this();
        this.collection = collection;
        this.mapCollection = new Map<String, SObject>();
        this.mapIdCollection = new Map<Id, SObject>();
        this.setup();
    }

    private Filter(Map<String, SObject> mapCollection) {
        this();
        this.collection = mapCollection.values();
        this.mapCollection = mapCollection;
        this.mapIdCollection = new Map<Id, SObject>();
        this.setup();
    }

    private Filter(Map<Id, SObject> mapIdCollection) {
        this();
        this.collection = mapIdCollection.values();
        this.mapCollection = new Map<String, SObject>();
        this.mapIdCollection = mapIdCollection;
        this.setup();
    }

    private void setup() {
        for(Id key : this.mapIdCollection.keySet()) {
            this.mapOfMaps.put(key, this.mapIdCollection.get(key));
        }

        for(String key : this.mapCollection.keySet()) {
            this.mapOfMaps.put(key, this.mapCollection.get(key));
        }

        for(Integer i = 0; i < this.collection.size(); i++) {
            SObject o = this.collection[i];
            this.mapOfMaps.put(String.valueOf(i),o);
        }
    }

    public static Filter the(List<SObject> collection) {
        return new Filter(collection);
    }

    public static Filter the(Map<String, SObject> mapCollection) {
        return new Filter(mapCollection);
    }

    public static Filter the(Map<Id, SObject> mapIdCollection) {
        return new Filter(mapIdCollection);
    }

    public Filter to { get { return this; }}

    public Set<SObject> filteredSet() {
        return this.filtered;
    }

    public List<SObject> filteredList() {
        return new List<SObject>(this.filtered);
    }

    public Map<Id, SObject> filteredMap() {
        return new Map<Id, SObject>(this.filteredList());
    }

    public Filter whereField(SObjectField field) {
        return this.whereField(String.valueOf(field));
    }

    public Filter whereField(String field) {
        this.whereField = field;
        return this;
    }

    public Filter is(Object value) {
        this.value = value;
        return this;
    }

    public Filter byField(SObjectField field) {
        return this.byField(String.valueOf(field));
    }

    public Filter byField(String field) {
        this.whereField = field;
        for(String key : this.mapOfMaps.keySet()) {
            this.index = key;
            this.ref = this.mapOfMaps.get(key);
            if(get() != null) {
                this.cleanCollections();
            }
        }
        return this;
    }

    private Object get() {
        return this.ref.get(this.whereField);
    }

    public Filter lessThan(Object otherValue) {
        for(String key : this.mapOfMaps.keySet()) {
            this.index = key;
            this.ref = this.mapOfMaps.get(key);
            this.value = get() != null ? get() : value;
            if(new Comparer(value).compareTo(otherValue) == 1) {
                this.cleanCollections();
            }
        }
        return this;
    }

    public Filter greaterThan(Object otherValue) {
        for(String key : this.mapOfMaps.keySet()) {
            this.index = key;
            this.ref = this.mapOfMaps.get(key);
            this.value = get() != null ? get() : value;
            if(new Comparer(value).compareTo(otherValue) == -1) {
                this.cleanCollections();
            }
        }
        return this;
    }

    public Filter equals(Object otherValue) {
        for(String key : this.mapOfMaps.keySet()) {
            this.index = key;
            this.ref = this.mapOfMaps.get(key);
            this.value = get() != null ? get() : value;
            if(new Comparer(value).compareTo(otherValue) == 0) {
                this.cleanCollections();
            }
        }
        return this;
    }

    Public Filter andReplaceFieldWithValueFrom(SObjectField fieldToAddValue, Map<String, SObject> replacementMap, SObjectField matchingField) {
        for(String key : this.mapOfMaps.keySet()) {
            this.ref = this.mapOfMaps.get(key);
            if(ref.get(this.whereField) == this.value) {
                if(replacementMap.containsKey(key)) {
                    SObject matchingRecord = replacementMap.get(key);
                    ref.put(fieldToAddValue, matchingRecord.get(matchingField));
                }
            }
        }
        return this;
    }

    public Filter andReplaceFieldWithValueFrom(SObjectField fieldToAddValue, Map<Id, SObject> replacementMap, SObjectField matchingField) {
        Map<String, SObject> newMap = new Map<String, SObject>();
        for(Id key : replacementMap.keySet()) {
            newMap.put(key, replacementMap.get(key));
        }
        return this.andReplaceFieldWithValueFrom(fieldToAddValue, newMap, matchingField);
    }

    private void cleanCollections() {
        this.mapOfMaps.remove(this.index);
        if(this.index instanceof Id) {
            this.mapIdCollection.remove(Id.valueOf(this.index));
        }
        this.mapCollection.remove(this.index);
        this.collection.remove(Integer.valueof(this.index));
        this.filtered.add(this.ref);
    }

    private class Comparer implements Comparable {
        private final Integer base;
        public Comparer(Object base) {
            this.base = Integer.valueOf(base);
        }

        public Integer compareTo(Object comparison) {
            Integer comparisonValue = Integer.valueOf(comparison);
            if(base == comparisonValue) return 0;
            if(base < comparisonValue) return -1;
            return 1;
        }
    }
}