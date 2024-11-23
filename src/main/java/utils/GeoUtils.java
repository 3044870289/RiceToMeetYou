package utils;

public class GeoUtils {
    private static final double MIN_LAT = 24.396308; // 日本最低纬度
    private static final double MAX_LAT = 45.551483; // 日本最高纬度
    private static final double MIN_LNG = 122.93457; // 日本最西经度
    private static final double MAX_LNG = 153.986672; // 日本最东经度

    /**
     * 生成随机纬度
     */
    public static double generateRandomLatitude() {
        return MIN_LAT + (Math.random() * (MAX_LAT - MIN_LAT));
    }

    /**
     * 生成随机经度
     */
    public static double generateRandomLongitude() {
        return MIN_LNG + (Math.random() * (MAX_LNG - MIN_LNG));
    }
}
