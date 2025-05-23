# Лабораторна 5
## Розробити додаток «Список справ» з використанням Combine framework

В цьому завданні ваша мета - створити додаток "Список справ", що дозволяє користувачам створювати, переглядати, оновлювати та видаляти завдання. Ви будете використовувати Combine framework для керування потоками даних та реактивного програмування. Ваш додаток повинен мати такі функції:

- Домашній екран, який відображає всі завдання у вигляді списку
- Екран "Нове завдання", який дозволяє користувачам створювати нове завдання
- Екран "Редагувати завдання", який дозволяє користувачам оновлювати завдання
- Функція "Видалити завдання", яка дозволяє користувачам видаляти завдання
- Збереження даних за допомогою Core Data, Realm або SwiftData!

Вимоги:
- Використання Combine framework для керування потоками даних та реактивного програмування
- Використання SwiftUI для компонентів інтерфейсу користувача
- Реалізація архітектури MVVM для зв'язування даних та розділення обов'язків
- Реалізація збереження даних за допомогою Core Data, Realm або SwiftData


# Лабораторна 6
## До додатку "Список справ", який ви розробляли минулого разу, додати функціонал.

1. Справа тепер містить не лише рядок (власне, справу), а й термін виконання (час+дата), пріоритет (високий/середній/низький) та позначку, чи виконана вона. Подумайте про створення різних VM для головного екрану та екрану редагування/створення.
2. На екран зі списком справ додати поле вводу для фільтрування справ за назвою.
3. На екран зі списком справ додати кнопку з меню для сортування (https://www.hackingwithswift.com/quick-start/swiftui/how-to-show-a-menu-when-a-button-is-pressed); передбачити сортування за терміном виконання (спочатку нагальніші), за пріоритетом (прочатку пріоритетніші), або за замовчуванням (сортування за всіма полями https://sarunw.com/posts/how-to-sort-by-multiple-properties-in-swift/#what-is-multiple-criteria-and-properties-sorting) (сортування за тим, чи виконана справа (спочатку невиконані), потім за пріоритетом (прочатку пріоритетніші), за терміном виконання (спочатку нагальніші), вкінці за алфавітом).
