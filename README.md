# Projekt QuizApp – Aplikacja Edukacyjna w Flutterze i Firebase

QuizApp to mobilna aplikacja edukacyjna stworzona we Flutterze z wykorzystaniem Firebase. Umożliwia naukę przez interaktywne quizy. Głównym celem jest pokazanie umiejętności tworzenia nowoczesnego interfejsu Flutter, obsługi logowania Google oraz integracji z bazą danych w chmurze.

## Kluczowe funkcjonalności

### Ekran powitalny
- Krótkie wprowadzenie i instrukcje obsługi aplikacji przed rozpoczęciem quizu.

### Lista quizów
- Kategorie: Fizyka, Chemia, Matematyka, Biologia
- Informacja o liczbie pytań i szacowanym czasie (np. 5 pytań, 15 minut)

### Logowanie i autoryzacja
- Wymagane przed rozpoczęciem quizu
- Logowanie przez konto Google za pomocą Firebase Authentication
- Komunikat „Please login before you start” przy próbie uruchomienia quizu bez zalogowania

### Rozwiązywanie quizu (MCQ)
- Pytania wielokrotnego wyboru (4 odpowiedzi)
- Wyświetlanie licznika czasu odliczającego do końca quizu

### Podsumowanie wyników
- Wyświetlenie liczby poprawnych odpowiedzi (np. 2/5)
- Szczegółowe przeglądanie odpowiedzi do każdego pytania
- Opcje „Try again” oraz „Go home”

### Motyw jasny/ciemny i wibracje
- Użytkownik może przełączać się między trybem jasnym i ciemnym oraz czuć wibracje przy interakcji.

## Technologie
- **Frontend:** Flutter – responsywny, nowoczesny interfejs z gradientami i ikonami
- **Backend:** Firebase – przechowywanie pytań, autoryzacja użytkowników
- **Autoryzacja:** Google Sign-In
- **Stan aplikacji:** wstępne łączenie z bazą danych, licznik ostatniej aktywności


---

**Autorzy:**  
– Aleksandra Bąk  
– Jakub Szaraj

**Cel aplikacji:**  
Stworzenie praktycznego przykładu implementacji interakcji użytkownika i logiki quizowej w Flutter
