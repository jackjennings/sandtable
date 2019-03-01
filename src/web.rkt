#lang racket

(require json
         web-server/servlet)

(define (response-json content)
  (response/full 200 #"OK"
                 (current-seconds)
                 #"application/json; charset=utf-8"
                 '()
                 (list (jsexpr->bytes content))))

(define (response-404 content)
  (response/full 404 #"Not Found"
                 (current-seconds)
                 #f
                 '()
                 (list content)))

(provide response-404
         response-json)
