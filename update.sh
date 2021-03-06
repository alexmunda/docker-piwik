#!/bin/bash
set -e

declare -A cmd=(
	[apache]='apache2-foreground'
	[fpm]='php-fpm'
)

latest="$(
	git ls-remote --tags https://github.com/piwik/piwik.git \
		| cut -d/ -f3 \
		| grep -vE -- '-rc|-b' \
		| sort -V \
		| tail -1
)"

set -x

for variant in apache fpm; do
	cp Dockerfile.template "$variant/Dockerfile"
	sed -ri -e '
		s/%%VARIANT%%/'"$variant"'/;
		s/%%VERSION%%/'"$latest"'/;
		s/%%CMD%%/'"${cmd[$variant]}"'/;
	' "$variant/Dockerfile"
done
