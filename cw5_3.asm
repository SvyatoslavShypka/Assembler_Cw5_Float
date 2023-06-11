# Początek sekcji danych
.data
coefs: .float 2.3, 3.45, 7.67, 5.32
degree: .word 3
prompt: .asciiz "    Podaj wartosc argumentu X (lub wpisz '0' aby zakonczyc): "
result_msg: .asciiz "Wynik: "

# Początek sekcji kodu
.text
.globl main

# Definicja etykiety main
main:

input_loop:
    la $a0, prompt           # Adres promptu jako argument dla syscall print_string
    li $v0, 4                # Kod syscall dla print_string
    syscall                  # Wywołanie syscall print_string

    li $v0, 6                # Kod syscall dla read_float
    syscall                  # Wywołanie syscall read_float
    mfc1 $t4, $f0            # move from coprocessor 1 do $t4 - (warunek wyjścia z cyklu "0")
   

#    #wydruk test float z $f4
    la $a0, coefs            # Adres początku wektora współczynników jako argument dla eval_poly
    lw $a1, degree           # Stopień wielomianu jako argument dla eval_poly
    mfc1 $a2, $f0            # move from coprocessor 1 do $a2 - znaczenie X dla podprogramu)
    mtc1 $zero, $f1	     # Wyzerujemy $f1 przed konwersją $f0 w double 
    cvt.d.s $f0, $f0         # Konwersja współczynnika na liczbę podwójnej precyzji  (z single to double)
     
    jal eval_poly            # Wywołanie podprogramu eval_poly
    
    li $v0, 4                # Kod syscall dla print_string
    la $a0, result_msg       # Adres komunikatu "Wynik: " jako argument dla syscall print_string
    syscall                  # Wywołanie syscall print_string

    li $v0, 3                # Kod syscall dla print_double
    mov.d $f12, $f4          # Przeniesienie wyniku z eval_poly ($f4) do $f12 dla wydruku Double
    syscall                  # Wywołanie syscall print_double
    beqz $t4, exit           # Jeśli wartość wynosi 0, przejdź do etykiety exit
    j input_loop             # Powrót do początku pętli

exit:
    li $v0, 10               # Kod syscall dla exit
    syscall                  # Wywołanie syscall exit


# Definicja podprogramu eval_poly
eval_poly:
    move $t1, $zero          # Inicjalizacja zmiennej pomocniczej result jako 0
    li $t2, 0                # Inicjalizacja licznika i = 0
    la $t0, coefs            # Adres początku wektora współczynników w $t0
    lwc1 $f4, ($t0)          # Wczytanie współczynnika z tablicy do $f4
    cvt.d.s $f4, $f4         # Konwersja współczynnika na liczbę podwójnej precyzji
    
eval_poly_loop:
    beq $t2, $a1, eval_poly_end   # Jeśli i == stopień wielomianu, zakończ pętlę

    mul.d $f4, $f4, $f0     # Mnożenie współczynnika przez x
    addiu $t0, $t0, 4        # Inkrementacja adresu początku wektora współczynników
    lwc1 $f6, ($t0)	     # Wczytanie współczynnika z tablicy do $f6
    mtc1 $zero, $f7          
    cvt.d.s $f6, $f6         # Konwersja współczynnika na liczbę podwójnej precyzji 
    add.d $f4, $f4, $f6      # Dodawanie wyniku poprzedniej iteracji do obecnego współczynnika
    
    addiu $t2, $t2, 1        # Inkrementacja licznika i

    j eval_poly_loop         # Skok do początku pętli
    
eval_poly_end:
    jr $ra                   # Powrót do funkcji wywołującej
