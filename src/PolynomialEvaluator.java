import java.util.Scanner;

public class PolynomialEvaluator {
    private static float evalPoly(float[] coefficients, float x) {
        int n = coefficients.length;
        float result = coefficients[n - 1];

        for (int i = n - 2; i >= 0; i--) {
            result = result * x + coefficients[i];
        }

        return result;
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Podaj stopień wielomianu: ");
        int degree = scanner.nextInt();

        float[] coefficients = new float[degree + 1];
        for (int i = degree; i >= 0; i--) {
            System.out.print("Podaj współczynnik przy x^" + i + ": ");
            coefficients[i] = scanner.nextFloat();
        }

        while (true) {
            System.out.print("Podaj wartość argumentu x (lub wpisz '0' aby zakończyć): ");
            String input = scanner.next();

            float x = Float.parseFloat(input);
            float result = evalPoly(coefficients, x);
            System.out.println("Wynik: " + result);
            if (input.equals("0")) {
                break;
            }
        }
        scanner.close();
    }
}
