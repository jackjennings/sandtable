#lang racket

(require json
         net/http-client
         web-server/servlet
         web-server/servlet-env
         web-server/dispatch)

(define port (if (getenv "PORT")
                 (string->number (getenv "PORT"))
                 8080))

(define api-key (getenv "AIRTABLE_API_KEY"))

(define base (getenv "AIRTABLE_BASE"))

(define (auth-bearer key)
  (string-append "Authorization: Bearer " key))

(define (airtable-request method path)
  (define-values (status headers content)
    (http-sendrecv
      "api.airtable.com"
      path
      #:ssl? #t
      #:version "2.0"
      #:method method
      #:headers (list (auth-bearer api-key))))
  (read-json content))

(define (airtable-get path)
  (airtable-request "GET" path))

(define (fields record)
  (hash-ref record 'fields))

(define (field record key default)
  (hash-ref (fields record) key default))

(define (records content)
  (filter (lambda (record) (field record 'Public #f))
          (hash-ref content 'records)))

(define (game name)
  (records (airtable-get (format "/v0/~a/~a" base name))))

(define (season game-name season-name)
  (serialize-season
    (findf (lambda (s) (equal? season-name (field s 'Season #f)))
           (game game-name))))

(define (serialize-season season)
  (hash-remove (fields season) 'Public))

(define (response-json content)
  (response/full 200 #"OK"
                 (current-seconds)
                 #"application/json; charset=utf-8"
                 '()
                 (list (jsexpr->bytes content))))

(define (handle-season req game-name season-name)
  (response-json (season game-name season-name)))

(define (not-found req)
  (response/full 404 #"Not Found"
                 (current-seconds)
                 #f
                 '()
                 (list #"Not Found\n")))

(define-values (dispatch dispatch-url)
  (dispatch-rules
    [("game" (string-arg) "season" (string-arg)) handle-season]
    [else not-found]))

(serve/servlet dispatch
               #:servlet-path "/"
               #:servlet-regexp #rx""
               #:listen-ip #f
               #:port port
               #:command-line? #t)
