#!/bin/sh

set -e

echo "create signed metadata file"
cd /pwd
/usr/bin/pyff /opt/testdata/pyff/md_aggregator.fd

echo "verify signature"
export SIGNED_XMLFILE=/pwd/metadata_signed.xml
export CERTFILE=/opt/testdata/keys/metadata_crt.pem

/xmldsigver.sh
