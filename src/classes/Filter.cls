public class Filter {
    private final List<SObject> collection;
    private final Set<SObject> filtered;
    private final Map<String, SObject> mapCollection;
    private final Map<Id, SObject> mapIdCollection;
    private final Map<String, SObject> mapOfMaps;
    private String whereField;
    private String index;
    private Object value;

    private Filter() {
        this.filtered = new Set<SObject>();
        this.index = '0';
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
            SObject o = this.mapOfMaps.get(key);
            if(get(o) != null) {
                this.cleanCollections(o);
            }
        }
        return this;
    }

    private Object get(SObject o) {
        return o.get(this.whereField);
    }

    public Filter greaterThan(Integer num) {
       for(String key : this.mapOfMaps.keySet()) {
            this.index = key;
            SObject o = this.mapOfMaps.get(key);
            Integer base = 0;
            base = get(o) != null ? (Integer) get(o) : base;
            if(base < num) {
                this.cleanCollections(o);
            }
        }
        return this;
    }

    Public Filter andReplaceWithValueFrom(Map<String, SObject> replacementMap, SObjectField matchingField, SObjectField fieldToAddValue) {
        for(String key : this.mapOfMaps.keySet()) {
            SObject record = this.mapOfMaps.get(key);
            if(record.get(this.whereField) == this.value) {
                if(replacementMap.containsKey(key)) {
                    SObject matchingRecord = replacementMap.get(key);
                    record.put(fieldToAddValue, matchingRecord.get(matchingField));
                }
            }
        }
        return this;
    }

    public Filter andReplaceWithValueFrom(Map<Id, SObject> replacementMap, SObjectField matchingField, SObjectField fieldToAddValue) {
        Map<String, SObject> newMap = new Map<String, SObject>();
        for(Id key : replacementMap.keySet()) {
            newMap.put(key, replacementMap.get(key));
        }
        return this.andReplaceWithValueFrom(newMap, matchingField, fieldToAddValue);
    }

    private void cleanCollections(SObject o) {
        this.mapOfMaps.remove(this.index);
        if(this.index instanceof Id) {
            this.mapIdCollection.remove(Id.valueOf(this.index));
        }
        this.mapCollection.remove(this.index);
        this.collection.remove(Integer.valueof(this.index));
        this.filtered.add(o);
    }
}