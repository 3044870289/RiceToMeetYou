package utils;

import java.util.Random;

public class GeoUtils {
    private static final Random RANDOM = new Random();

    // 三个主要区域的中心点（纬度，经度）
    private static final double[][] AREAS = {
        {35.6895, 139.6917},  // 东京中心点
        {34.6937, 135.5023},  // 大阪中心点
        {38.429000, 140.143913} // 西川町中心点
    };

    // 对应三个区域的生成权重（总和为1.0）
    private static final double[] WEIGHTS = {0.4, 0.2, 0.4}; // 东京40%，大阪20%，西川町40%

    /**
     * 随机生成在三个主要区域附近的经纬度
     *
     * @return double[] 数组，包含生成的纬度（索引0）和经度（索引1）
     */
    public static double[] generateCoordinatesForSpecificAreas() {
        // 随机选择区域
        double randomValue = RANDOM.nextDouble();
        double cumulativeWeight = 0.0;
        int selectedIndex = 0;

        for (int i = 0; i < WEIGHTS.length; i++) {
            cumulativeWeight += WEIGHTS[i];
            if (randomValue <= cumulativeWeight) {
                selectedIndex = i;
                break;
            }
        }

        // 在选定区域中心点附近生成坐标
        double latitude = AREAS[selectedIndex][0] + generateRandomOffset(0.02); // ±0.02° 的随机偏移
        double longitude = AREAS[selectedIndex][1] + generateRandomOffset(0.02); // ±0.02° 的随机偏移

        return new double[]{latitude, longitude};
    }

    /**
     * 生成随机偏移量
     *
     * @param range 偏移范围（±range）
     * @return double 随机偏移值
     */
    private static double generateRandomOffset(double range) {
        return (RANDOM.nextDouble() - 0.5) * 2 * range; // 范围为 -range 到 +range
    }

    // 测试方法
    public static void main(String[] args) {
        for (int i = 0; i < 10; i++) {
            double[] coordinates = generateCoordinatesForSpecificAreas();
            System.out.printf("Generated coordinates: Latitude %.6f, Longitude %.6f%n", coordinates[0], coordinates[1]);
        }
    }
}
