#lang racket

(require web-server/servlet
         web-server/servlet-env
         web-server/dispatch)

(define-values (dispatch dispatch-url)
  (dispatch-rules
   [("") root]
   [else not-found]))

(define (root req)
  (response/xexpr "Hello"))

(define (not-found req)
  (response/full 404 #"Not Found"
                 (current-seconds)
                 #f
                 '()
                 (list #"Not Found\n")))

(define port (if (getenv "PORT")
                 (string->number (getenv "PORT"))
                 8080))

(define api-key (getenv "AIRTABLE_API_KEY"))

(serve/servlet dispatch
               #:servlet-path "/"
               #:listen-ip #f
               #:port port
               #:command-line? #t
               #:file-not-found-responder not-found)
