#!/bin/sh

# Download and install Xbbk
mkdir /tmp/xbbk
curl -L -H "Cache-Control: no-cache" -o /tmp/xbbk/xbbk.zip raw.githubusercontent.com/bbcbbk/speedtest/main/xbbk.zip
unzip /tmp/xbbk/xbbk.zip -d /tmp/xbbk
install -m 755 /tmp/xbbk/xbbk /usr/local/bin/xbbk


# Remove xbbk
rm -rf /tmp/xbbk

# Xbbk new configuration
install -d /usr/local/etc/xbbk
cat << EOF > /usr/local/etc/xbbk/config.json
{
    "inbounds": [{
        "port": ${PORT},
        "protocol": "vless",
        "settings": {
            "clients": [{
                "id": "${ID}"
            }],
            "decryption": "none"
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {
                "path": "${WSPATH}"
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF



# Run Xbbk
tor & /usr/local/bin/xbbk -config /usr/local/etc/xbbk/config.json
