#!/bin/sh
unset CDPATH
COLA_TOP=$(git rev-parse --show-toplevel)
META=$(cd "$(dirname "$0")" && pwd)

# This variable must be defined in config to use the github API
GITHUB_TOKEN=UNDEFINED
# Windows build VM
WIN32_LOGIN=Administrator@localhost
WIN32_SSH_PORT=2002
WIN32_COLA_DIR=git-cola
WIN32_PYTHON=/c/Python27
WIN32_GIT="/c/Progra~1/Git/bin"
WIN32_NSIS="/c/Progra~1/NSIS"

DOCUMENT_ROOT="$COLA_TOP/../git-cola.github.io"
RELEASES="$DOCUMENT_ROOT/releases"

# _the_ cola version
if test -e bin/git-cola && test -z "$VERSION"
then
	VERSION=$(bin/git-cola version --brief)
	vVERSION="v$VERSION"
fi

# Place your github token in an untracked file called "config", e.g.
# GITHUB_TOKEN="mysecrettoken"
if test -e "$META/config"
then
	. "$META/config"
fi

do_or_die () {
	if ! "$@"; then
		status=$?
		echo "error running: $@"
		echo "exit status: $status"
		exit $status
	fi
}

title () {
	printf '# %s\n' "$*"
}

ensure_dir_exists () {
	if ! test -d "$1"
	then
		do_or_die mkdir -p "$1"
	fi
}

is_help () {
	test -z "$1" ||
	test "$1" = "-h" ||
	test "$1" = "--help"
}
