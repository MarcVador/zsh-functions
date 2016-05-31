function emc {
    emacsclient -a "" -t "$@"
}

function emx {
    emacsclient -a "" -t -s "$@"
}

function ediff {
    emacsclient -a "" -c --eval "(ediff-files \"$1\" \"$2\")""\")"
}
