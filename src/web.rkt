#lang racket

(require json
         web-server/servlet
         web-server/servlet-env)

(define (response-json content)
  (response/full 200 #"OK"
                 (current-seconds)
                 #"application/json; charset=utf-8"
                 (list (header #"Access-Control-Allow-Origin" #"*"))
                 (list (jsexpr->bytes content))))

(define (response-404 content)
  (response/full 404 #"Not Found"
                 (current-seconds)
                 #f
                 '()
                 (list content)))

(define (serve dispatch port)
  (serve/servlet dispatch
                 #:servlet-path "/"
                 #:servlet-regexp #rx""
                 #:listen-ip #f
                 #:port port
                 #:command-line? #t))

(provide response-404
         response-json
         serve)
