#lang racket

(require web-server/servlet-env
         web-server/dispatch
         "src/airtable.rkt"
         "src/http.rkt"
         "src/web.rkt")

(define port (if (getenv "PORT")
                 (string->number (getenv "PORT"))
                 8080))

(define api-key (getenv "AIRTABLE_API_KEY"))

(define base (getenv "AIRTABLE_BASE"))

(define (fields record)
  (hash-ref record 'fields))

(define (field record key default)
  (hash-ref (fields record) key default))

(define (records content)
  (filter (lambda (record) (field record 'Public #f))
          (hash-ref content 'records)))

(define (game name)
  (records (airtable-get api-key (format "/v0/~a/~a" base name))))

(define (season game-name season-name)
  (findf (lambda (s) (equal? season-name (field s 'Season #f)))
           (game game-name)))

(define (serialize-season season)
  (hash-remove (fields season) 'Public))

(define (handle-season req game-name season-name)
  (response-json
    (serialize-season (season game-name season-name))))

(define (handle-404 req)
  (response-404 #"Not Found"))

(define-values (dispatch dispatch-url)
  (dispatch-rules
    [("game" (string-arg) "season" (string-arg)) handle-season]
    [else handle-404]))

(serve/servlet dispatch
               #:servlet-path "/"
               #:servlet-regexp #rx""
               #:listen-ip #f
               #:port port
               #:command-line? #t)
