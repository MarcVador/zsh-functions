function suo () {
    for file in "$@"; do
        sort -u -o "$file" "$file"
    done
}
