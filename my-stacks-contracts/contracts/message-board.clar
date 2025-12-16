;; title: message-board
;; version:
;; summary:
;; description:

;; traits
;;

;; token definitions
;;

;; constants
;;

;; data vars
;;

;; data maps
;;

;; public functions
;;

;; read only functions
;;

;; private functions
;; Define contract owner 
(define-constant CONTRACT_OWNER tx-sender)

;; Define error codes
(define-constant ERR_NOT_ENOUGH_SBTC (err u1004))
(define-constant ERR_NOT_CONTRACT_OWNER (err u1005))
(define-constant ERR_BLOCK_NOT_FOUND (err u1003))


;; Define a map to store messages
;; Each message has an ID, content, author, and Bitcoin block height timestamp
(define-map messages
  uint
  {
    message: (string-utf8 280),
    author: principal,
    time: uint,
  }
)

;; Counter for total messages
(define-data-var message-count uint u0)

;; Public function to add a new message for 1 satoshi of sBTC
;; @format-ignore
(define-public (add-message (content (string-utf8 280)))
  (let ((id (+ (var-get message-count) u1)))
    ;; Charge 1 satoshi of sBTC from the caller to the contract
    (unwrap!
      (contract-call? 'SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token
        transfer u1 contract-caller current-contract none)
      ERR_NOT_ENOUGH_SBTC)

    (map-set messages id {
      message: content,
      author: contract-caller,
      time: burn-block-height,
    })
    (var-set message-count id)
    (print {
      event: "[Stacks Dev Quickstart] New Message",
      message: content,
      id: id,
      author: contract-caller,
      time: burn-block-height,
    })

    ;; Return the message ID
    (ok id)))
