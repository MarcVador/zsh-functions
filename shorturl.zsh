# resolve shortened url
function shorturl() {
    curl -s -D - -o /dev/null $1 | grep -i ^location
}
