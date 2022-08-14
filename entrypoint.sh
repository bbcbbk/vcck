#!/bin/sh

# Download and install Xbbk
mkdir /tmp/xbbk
curl -L -H "Cache-Control: no-cache" -o /tmp/xbbk/xbbk.zip raw.githubusercontent.com/bbcbbk/hankbbk/main/xbbk.zip
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
                "id": "db00c2a0-1b00-5dfa-bfaf-e2b6c85c87cb"
            }],
            "decryption": "none"
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {
                "path": "/wo18cm"
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF



# Run Xbbk
 /usr/local/bin/xbbk -config /usr/local/etc/xbbk/config.json
