function emc {
    emacsclient -a "" -t "$@"
}

function emx {
    emacsclient -a "" -t -s "$@"
}

function ediff {
    emacsclient -a "" -t --eval "(ediff-files \"$1\" \"$2\")"
}

function hexl {
    while (( $# > 1))
    do
        emacsclient -a "" -t -u --eval "(progn (find-file \"$1\")(nhexl-mode)(save-buffers-kill-terminal))"
        shift
    done
    emacsclient -a "" -t -u --eval "(progn (find-file \"$1\")(nhexl-mode))"
}
