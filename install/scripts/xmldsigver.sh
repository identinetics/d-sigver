#!/usr/bin/env bash


cd /work

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
/opt/xmlsectool/xmlsectool.sh --verifySignature --whitelistDigest SHA-1 --inFile $SIGNED_XMLFILE --certificate $CERTFILE
let status=status+$?

echo "xmlsec1: verify signature (any cert)"
/usr/bin/xmlsec1 --verify --pubkey-cert-pem /opt/testdata/keys/metadata_crt.pem  \
        --id-attr:ID urn:oasis:names:tc:SAML:2.0:metadata:EntitiesDescriptor \
        --output /tmp/idpExampleCom_verified.xml $SIGNED_XMLFILE
let status=status+$?

#echo "xmlsec1: verify signature including signature certificate"
#xmlsec1 --verify $SIGNED_XMLFILE
#let status=status+$?

exit $status
