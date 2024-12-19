<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 4</b><br/>
"Функції вищого порядку та замикання"<br/>
дисципліни "Вступ до функціонального програмування"
</p>
<p align="right"><b>Студент</b>: Абраменко Данило Олександрович КВ-13</p>
<p align="right"><b>Рік</b>: 2024</p>

## Загальне завдання
Завдання складається з двох частин:
1. Переписати функціональну реалізацію алгоритму сортування з лабораторної роботи 3  з такими змінами: 
* використати функції вищого порядку для роботи з послідовностями (де це доречно);
* додати до інтерфейсу функції (та використання в реалізації) два ключових параметра: ```key``` та ```test``` , що працюють аналогічно до того, як працюють параметри з такими назвами в функціях, що працюють з послідовностями. При цьому ```key``` має виконатись мінімальну кількість разів.
2. Реалізувати функцію, що створює замикання, яке працює згідно із завданням за варіантом (див. п 4.1.2). Використання псевдо-функцій не забороняється, але, за можливості, має бути мінімізоване.

## Варіант першої частини 1
Алгоритм сортування вибором за незменшенням.
## Лістинг реалізації першої частини завдання
```lisp
;; Функція знаходження мінімального елемента з параметром key та test
(defun find-min-with-key (lst key test)
  "Знаходить мінімальний елемент у списку lst з урахуванням key та test."
  (reduce (lambda (x y)
            (if (funcall test (funcall key x) (funcall key y))
                x
                y))
          lst))

;; Функція сортування вибором з ключовими параметрами
(defun selection-sort (lst &key (key #'identity) (test #'<))
  "Сортує список lst за допомогою сортування вибором з параметрами key та test."
  (if (null lst)
      nil
      (let ((min (find-min-with-key lst key test)))
        (cons min
              (selection-sort (remove min lst :count 1) :key key :test test)))))
```
### Тестові набори та утиліти першої частини
```lisp
(defun check-sort (name function input expected)
  "Перевірка результату виклику сортувальної функції."
  (format t "~:[FAILED~;PASSED~]... ~a~%Expected: ~a~%Got: ~a~%~%"
          (equal (funcall function input) expected)
          name expected (funcall function input)))

;; === Тести для selection-sort ===
(defun test-selection-sort ()
  "Тести для функції selection-sort."
  (check-sort "Test 1: Simple list"
              (lambda (lst) (selection-sort lst))
              '(3 1 4 1 5 9 2) '(1 1 2 3 4 5 9))
  (check-sort "Test 2: Empty list"
              (lambda (lst) (selection-sort lst))
              '() '())
  (check-sort "Test 3: With key"
              (lambda (lst) (selection-sort lst :key #'cdr))
              '((1 . 2) (3 . 1) (2 . 3)) '((3 . 1) (1 . 2) (2 . 3)))
  (check-sort "Test 4: With descending test"
              (lambda (lst) (selection-sort lst :test #'>))
              '(3 1 4 1 5 9 2) '(9 5 4 3 2 1 1))
  (check-sort "Test 5: Repeated elements"
              (lambda (lst) (selection-sort lst))
              '(5 5 5 5) '(5 5 5 5))
  (check-sort "Test 6: List with negative numbers"
              (lambda (lst) (selection-sort lst))
              '(-3 -1 -4 -1 -5 -9 -2) '(-9 -5 -4 -3 -2 -1 -1))
  (check-sort "Test 7: Mixed positive and negative numbers"
              (lambda (lst) (selection-sort lst))
              '(-3 1 -4 1 5 -9 2) '(-9 -4 -3 1 1 2 5)))
```
### Тестування першої частини
```lisp
=== Testing selection-sort ===
PASSED... Test 1: Simple list
Expected: (1 1 2 3 4 5 9)
Got: (1 1 2 3 4 5 9)

PASSED... Test 2: Empty list
Expected: NIL
Got: NIL

PASSED... Test 3: With key
Expected: ((3 . 1) (1 . 2) (2 . 3))
Got: ((3 . 1) (1 . 2) (2 . 3))

PASSED... Test 4: With descending test
Expected: (9 5 4 3 2 1 1)
Got: (9 5 4 3 2 1 1)

PASSED... Test 5: Repeated elements
Expected: (5 5 5 5)
Got: (5 5 5 5)

PASSED... Test 6: List with negative numbers
Expected: (-9 -5 -4 -3 -2 -1 -1)
Got: (-9 -5 -4 -3 -2 -1 -1)

PASSED... Test 7: Mixed positive and negative numbers
Expected: (-9 -4 -3 1 1 2 5)
Got: (-9 -4 -3 1 1 2 5)
```
## Варіант другої частини 1
Написати функцію add-prev-fn , яка має один ключовий параметр — функцію
transform . add-prev-fn має повернути функцію, яка при застосуванні в якості
першого аргументу mapcar разом з одним списком-аргументом робить наступне: кожен
елемент списку перетворюється на точкову пару, де в комірці CAR знаходиться значення
поточного елемента, а в комірці CDR знаходиться значення попереднього елемента
списку. Якщо функція transform передана, тоді значення поточного і попереднього
елементів, що потраплять у результат, мають бути змінені згідно transform .
transform має виконатись мінімальну кількість разів.

```lisp
CL-USER> (mapcar (add-prev-fn) '(1 2 3))
((1 . NIL) (2 . 1) (3 . 2))
CL-USER> (mapcar (add-prev-fn :transform #'1+) '(1 2 3))
((2 . NIL) (3 . 2) (4 . 3))
```
## Лістинг реалізації другої частини завдання
```lisp
;; === Реалізація add-prev-fn ===

(defun add-prev-fn (&key transform)
  "Повертає функцію для створення точкової пари з елементом і його попередником."
  (let ((transform (or transform #'identity)))
    (lambda (lst)
      (let ((prev nil))
        (mapcar (lambda (current)
                  (let ((result (cons (funcall transform current)
                                      (if prev (funcall transform prev) nil))))
                    (setf prev current)
                    result))
                lst)))))
```
### Тестові набори та утиліти другої частини
```lisp
;; === Тести для add-prev-fn ===
(defun check-add-prev (name function input expected)
  "Перевірка результату функції add-prev-fn."
  (format t "~:[FAILED~;PASSED~]... ~a~%Expected: ~a~%Got: ~a~%~%"
          (equal (funcall function input) expected)
          name expected (funcall function input)))

(defun test-add-prev-fn ()
  "Тести для функції add-prev-fn."
  (check-add-prev "Test 1: Without transform"
                  (add-prev-fn)
                  '(1 2 3)
                  '((1 . nil) (2 . 1) (3 . 2)))
  (check-add-prev "Test 2: With transform"
                  (add-prev-fn :transform #'1+)
                  '(1 2 3)
                  '((2 . nil) (3 . 2) (4 . 3)))
  (check-add-prev "Test 3: Empty list"
                  (add-prev-fn)
                  '()
                  '())
  (check-add-prev "Test 4: Single element"
                  (add-prev-fn)
                  '(42)
                  '((42 . nil)))
  (check-add-prev "Test 5: With transform and negative numbers"
                  (add-prev-fn :transform #'-)
                  '(3 5 -2)
                  '((-3 . nil) (-5 . -3) (2 . -5)))
  (check-add-prev "Test 6: Large list"
                  (add-prev-fn)
                  (loop for i from 1 to 10 collect i)
                  '((1 . nil) (2 . 1) (3 . 2) (4 . 3) (5 . 4) (6 . 5) (7 . 6) (8 . 7) (9 . 8) (10 . 9))))
```
### Тестування другої частини
```lisp
=== Testing add-prev-fn ===
PASSED... Test 1: Without transform
Expected: ((1) (2 . 1) (3 . 2))
Got: ((1) (2 . 1) (3 . 2))

PASSED... Test 2: With transform
Expected: ((2) (3 . 2) (4 . 3))
Got: ((2) (3 . 2) (4 . 3))

PASSED... Test 3: Empty list
Expected: NIL
Got: NIL

PASSED... Test 4: Single element
Expected: ((42))
Got: ((42))

PASSED... Test 5: With transform and negative numbers
Expected: ((-3) (-5 . -3) (2 . -5))
Got: ((-3) (-5 . -3) (2 . -5))

PASSED... Test 6: Large list
Expected: ((1) (2 . 1) (3 . 2) (4 . 3) (5 . 4) (6 . 5) (7 . 6) (8 . 7) (9 . 8)
           (10 . 9))
Got: ((1) (2 . 1) (3 . 2) (4 . 3) (5 . 4) (6 . 5) (7 . 6) (8 . 7) (9 . 8)
      (10 . 9))
```
