Інтернет любить котів, а ти?

Потрібно створити додаток, що генеруватиме випадкову історію про кота (див. доданий файл).

По натиску на кнопку "Generate cat story" додаток повинен отримати з https://cataas.com/cat випадкову фотографію кота, а з https://catfact.ninja/fact випадковий факт про кота і відобразити їх одночасно на екрані. Під час виконання запиту замість зображення має бути довільний плейсхолдер (можна вирізати з файлу, що додається), у місці для факту про кота має бути текст на кшталт "Loading, please wait...". Можна також додати стандартне progress view за бажання (шанс повправлятись в зв'язці івентів з UI).

Для завантаження даних використовувати URLSession обгорнуту в Single. Вся робота з даними через RxSwift, UI через UIKit, шаблон проектування MVVM.

Використовувати бібліотеки окрім RxSwift заборонено.
