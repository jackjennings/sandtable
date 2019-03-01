#lang racket

(require json
         net/http-client
         "http.rkt")

(define (airtable-get api-key path)
  (airtable-request api-key "GET" path))

(define (airtable-request api-key method path)
  (define-values (status headers content)
    (request method
             "api.airtable.com"
             path
             (list (auth-bearer api-key))))
  (read-json content))

(provide airtable-get
         airtable-request)
