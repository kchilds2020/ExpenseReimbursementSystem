package models;

/**
 * model for token
 * */
public class Token {
    private String token;
    private int role;

    public Token(String token, int role) {
        this.token = token;
        this.role = role;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return "Token{" +
                "token='" + token + '\'' +
                ", role=" + role +
                '}';
    }
}
