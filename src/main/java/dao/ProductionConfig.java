package dao;
/**
 * configuration connection for production
 * */
public class ProductionConfig {
    public static String url = System.getenv("JDBC_POSTGRES_URL");;
    public static String username = System.getenv("JDBC_POSTGRES_USERNAME");
    public static String password = System.getenv("JDBC_POSTGRES_PASSWORD");
}
