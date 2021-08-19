public with sharing class EnumValueOf {

    public enum Season {WINTER, SPRING, SUMMER, FALL}
    
    public static void convertStringToEnumConstant(){
        String currentSeasonInput = 'WINTER';

        // Before - searching the values()
        Map<String, Season> seasonsByName = new Map<String, Season>();
        for (Season enumValue : Season.values())
        {
            seasonsByName.put(enumValue.name().toUpperCase(), enumValue);
        }
        Season currentSeason = seasonsByName.get(currentSeasonInput);

        System.debug('Current season (older technique): ' + currentSeason);

        // With Winter'22
        Season currentSeasonWithValueOf = Season.valueOf(currentSeasonInput);

        System.debug('Current season (new technique): ' + currentSeasonWithValueOf);
    }
}
