# clean various temporary files
function clean() {
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for i in `find . -name '*~' -o -name '\#*\#' 2>/dev/null`
    do
    echo "$i"
    rm -f "$i"
    done 
IFS=$SAVEIFS
}
