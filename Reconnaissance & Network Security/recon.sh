#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

read -p "Enter the target domain: " DOMAIN

if [ -z "$DOMAIN" ]; then
    echo -e "${RED}No domain provided. Exiting.${NC}"
    exit 1
fi

if [[ "$DOMAIN" != *.* ]]; then
    echo -e "${YELLOW}Warning: '$DOMAIN' doesn't look like a domain.${NC}"
fi

WORDLIST=("www" "dev" "admin" "mail" "ftp" "test" "staging" "api" "vpn" "portal" "blog" "shop" "support" "ns1" "ns2")

if ! command -v dig &> /dev/null; then
    echo -e "${RED}dig is not installed. Run: sudo apt install dnsutils${NC}"
    exit 1
fi

echo "Scanning $DOMAIN..."
echo ""

FOUND_COUNT=0

for sub in "${WORDLIST[@]}"; do
    FQDN="${sub}.${DOMAIN}"
    IP=$(dig +short A "$FQDN")

    if [ -n "$IP" ]; then
        if [[ "$IP" =~ [a-zA-Z] ]]; then
            IP=$(dig +short A "$FQDN" | tail -n 1)
        fi
        echo -e "[${GREEN}+${NC}] $FQDN -> $IP"
        FOUND_COUNT=$((FOUND_COUNT + 1))
    fi
done

echo ""
echo "Done. Found $FOUND_COUNT subdomain(s)."
