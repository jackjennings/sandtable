#lang racket

(require json
         net/http-client)

(define (auth-bearer key)
  (string-append "Authorization: Bearer " key))

(define (request method host path headers)
  (http-sendrecv host
                 path
                 #:ssl? #t
                 #:version "2.0"
                 #:method method
                 #:headers headers))

(provide auth-bearer
         request)
