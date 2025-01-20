;; === Функціональний підхід до сортування вибором з ключовими параметрами ===

;; Функція знаходження мінімального елемента з параметром key та test
(defun find-min-with-key (lst key test)
  "Знаходить мінімальний елемент у списку `lst` з урахуванням `key` та `test`,
   викликаючи `key` для кожного елемента лише один раз."
  (when lst
    (let* ((keyed-lst (mapcar (lambda (x)
                                (cons (funcall key x) x))
                              lst))
           (min-pair (reduce (lambda (pair1 pair2)
                               (if (funcall test (car pair1) (car pair2))
                                   pair1
                                   pair2))
                             keyed-lst)))
      (cdr min-pair))))  ; повертаємо оригінальний елемент

;; Функція сортування вибором з ключовими параметрами
(defun selection-sort (lst &key (key #'identity) (test #'<))
  "Сортує список lst за допомогою сортування вибором з параметрами key та test."
  (if (null lst)
      nil
      (let ((min (find-min-with-key lst key test)))
        (cons min
              (selection-sort (remove min lst :count 1) :key key :test test)))))

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

;; === Модульні тести для функцій ===

;; Загальна функція для перевірки результату
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

;; === Запуск тестів ===
(defun run-tests ()
  (format t "=== Testing selection-sort ===~%")
  (test-selection-sort)
  (format t "=== Testing add-prev-fn ===~%")
  (test-add-prev-fn))

;; Запуск тестів
(run-tests)

