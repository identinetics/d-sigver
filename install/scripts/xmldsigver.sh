#!/usr/bin/env bash


cd /pwd

echo 'Verify a signed xml document with different tools'
if [[ -e $SIGNED_XMLFILE ]]; then
    echo "verifying $SIGNED_XMLFILE"
else
    echo "File $SIGNED_XMLFILE not found"
    exit 1
fi

if [[ -e $CERTFILE ]]; then
    echo "Checking signature with certificate in $CERTFILE"
else
    echo "Certificate $CERTFILE not found"
    exit 2
fi

status=0
echo "xmlsectool: verify signature including signature certificate"
export JAVA_HOME=/etc/alternatives/java_sdk_1.8.0
/opt/xmlsectool/xmlsectool.sh --verifySignature --inFile $SIGNED_XMLFILE --certificate $CERTFILE
let status=status+$?

echo "xmlsec1: verify signature (any cert)"
xmlsec1 --verify $SIGNED_XMLFILE
let status=status+$?

#echo "xmlsec1: verify signature including signature certificate"
#xmlsec1 --verify $SIGNED_XMLFILE
#let status=status+$?

exit $status
