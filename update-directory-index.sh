#!/bin/bash

for a in "$@"; do
	case "$a" in
	--sync) SYNC=1 ;;
	--verbose) VERBOSE=1 ;;
	esac
    shift
done

for DIR in $(find -type d -not -name .git -print -or -prune); do
  (
    echo -e "<html>\n<body>\n<h1>Directory listing</h1>\n<hr/>\n<pre>"
    ls -1pa "${DIR}" | grep -v "^\.[^\.]" | grep -v "^index\.html$" | awk '{ printf "<a href=\"%s\">%s</a>\n",$1,$1 }'
    echo -e "</pre>\n</body>\n</html>"
  ) > "${DIR}/index.html"
  [ -n "$VERBOSE" ] && echo "${DIR}/index.html"
done

if [ -n "$SYNC" ]; then
	[  -n "$VERBOSE" ] || exec >/dev/null
	git add -A && git commit -m 'synchronizing repository' && git push origin gh-pages && exit 0
else
	exit 0
fi
