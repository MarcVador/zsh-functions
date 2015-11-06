# markdown previewing
function mdless() {
    if (( $# == 0 )); then
        echo "You must supply at least one file";
        return 1;
    fi
    for i
    do
        pandoc -s -f markdown -t man "$i" | groff -T utf8 -man | less
    done
}
