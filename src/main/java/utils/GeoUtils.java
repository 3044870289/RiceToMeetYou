package utils;

import java.util.Random;

public class GeoUtils {
    private static final Random RANDOM = new Random();

    // 日本范围的经纬度边界
    private static final double JAPAN_MIN_LAT = 24.396308; // 日本最低纬度（冲绳）
    private static final double JAPAN_MAX_LAT = 45.551483; // 日本最高纬度（北海道）
    private static final double JAPAN_MIN_LNG = 122.93457; // 日本最西经度
    private static final double JAPAN_MAX_LNG = 153.986672; // 日本最东经度

    // 全球范围的经纬度边界
    private static final double GLOBAL_MIN_LAT = -90.0; // 全球最低纬度
    private static final double GLOBAL_MAX_LAT = 90.0;  // 全球最高纬度
    private static final double GLOBAL_MIN_LNG = -180.0; // 全球最西经度
    private static final double GLOBAL_MAX_LNG = 180.0;  // 全球最东经度

    /**
     * 生成随机纬度。
     * 80% 的概率在日本，20% 的概率在全球。
     * 
     * @return 随机生成的纬度
     */
    public static double generateRandomLatitude() {
        double latitude;
        if (RANDOM.nextDouble() <= 0.8) {
            latitude = JAPAN_MIN_LAT + (JAPAN_MAX_LAT - JAPAN_MIN_LAT) * RANDOM.nextDouble();
        } else {
            latitude = GLOBAL_MIN_LAT + (GLOBAL_MAX_LAT - GLOBAL_MIN_LAT) * RANDOM.nextDouble();
        }
        System.out.println("Generated Latitude: " + latitude);
        return latitude;
    }

    public static double generateRandomLongitude() {
        double longitude;
        if (RANDOM.nextDouble() <= 0.8) {
            longitude = JAPAN_MIN_LNG + (JAPAN_MAX_LNG - JAPAN_MIN_LNG) * RANDOM.nextDouble();
        } else {
            longitude = GLOBAL_MIN_LNG + (GLOBAL_MAX_LNG - GLOBAL_MIN_LNG) * RANDOM.nextDouble();
        }
        System.out.println("Generated Longitude: " + longitude);
        return longitude;
    }

}
