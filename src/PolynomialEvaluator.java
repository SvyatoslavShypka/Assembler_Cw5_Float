import java.util.Scanner;


public class PolynomialEvaluator {

    private static double eval_poly(float[] coefs, int degree, float x) {
        double result = coefs[0];
        for (int i = 1; i <= degree; i++) {
            result = result * x + coefs[i];
        }
        return result;
    }

    public static void main(String[] args) {
        float[] coefs = {2.3f, 3.45f, 7.67f, 5.32f};
        int degree = 3;
        Scanner scanner = new Scanner(System.in);
        while (true) {
            System.out.print("Podaj wartość argumentu x (lub wpisz '0' aby zakończyć): ");
            String input = scanner.next();

            float x = Float.parseFloat(input);
            double result = eval_poly(coefs, degree,x);
            System.out.println("Wynik: " + result);
            if (input.equals("0")) {
                break;
            }
        }
        scanner.close();
    }
}
