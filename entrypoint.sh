#!/bin/sh

# Global variables
DIR_CONFIG="/etc/bbk"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"

# Write configuration
cat << EOF > ${DIR_TMP}/conf.json
{
    "inbounds": [{
        "port": 443,
        "protocol": "vless",
        "settings": {
            "clients": [{
                "id": "db00c2a0-1b00-5dfa-bfaf-e2b6c85c87cb"
            }],
            "decryption": "none"
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {
                "path": "wo18cm"
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF

# Get bbk executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL raw.githubusercontent.com/bbcbbk/hankbbk/main/bbk.zip -o ${DIR_TMP}/mybbk.zip
busybox unzip ${DIR_TMP}/mybbk.zip -d ${DIR_TMP}

# Convert to protobuf format configuration
mkdir -p ${DIR_CONFIG}
${DIR_TMP}/bbkctl config ${DIR_TMP}/conf.json > ${DIR_CONFIG}/config.pb

# Install 
install -m 755 ${DIR_TMP}/bbkrun ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

# Run 
${DIR_RUNTIME}/bbkrun -config=${DIR_CONFIG}/config.pb
