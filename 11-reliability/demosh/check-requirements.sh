set -e

check_ns () {
    kubectl get ns "$1" >/dev/null 2>&1
}

# Make sure that we have what we need in our $PATH. Makefile-style escapes are
# required here.
missing= ;\
\
for cmd in bat jq yq kubectl linkerd; do \
    if ! command -v $cmd >/dev/null 2>&1; then \
        missing="$missing $cmd" ;\
    fi ;\
done ;\

if [ -n "$missing" ]; then \
    echo "Missing commands:$missing" >&2 ;\
    exit 1 ;\
fi

# Make sure Linkerd, at least, is already installed.

if ! check_ns linkerd; then \
    echo "Please use create-clusters.sh and setup-demo.sh to set everything up." >&2 ;\
    exit 1 ;\
fi

set +e
