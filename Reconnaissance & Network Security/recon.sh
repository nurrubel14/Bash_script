#!/bin/bash




GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' 


if [ -z "$1" ]; then
    echo -e "${YELLOW}Usage: $0 <domain>${NC}"
    echo -e "Example: $0 example.com"
    exit 1
fi

DOMAIN=$1
WORDLIST=("www" "dev" "admin" "mail" "ftp" "test" "staging" "api" "vpn" "portal" "blog" "shop" "support" "ns1" "ns2")

# --- Check if 'dig' is installed ---
if ! command -v dig &> /dev/null; then
    echo -e "${RED}[!] Error: 'dig' is not installed. Please install dnsutils (sudo apt install dnsutils).${NC}"
    exit 1
fi

echo -e "=========================================="
echo -e " Starting Subdomain Recon on: ${GREEN}$DOMAIN${NC}"
echo -e "=========================================="

# --- Loop through the wordlist ---
for sub in "${WORDLIST[@]}"; do
    # Construct the full subdomain
    FQDN="${sub}.${DOMAIN}"
    
    # Query DNS for an A record (IPv4). 
    # +short returns only the IP address, making it easy to parse.
    IP=$(dig +short A "$FQDN")
    
    
    if [ -n "$IP" ]; then
        
       
        if [[ "$IP" =~ [a-zA-Z] ]]; then
            IP=$(dig +short A "$FQDN" | tail -n 1)
        fi
        
        echo -e "[${GREEN}FOUND${NC}] $FQDN -> $IP"
    else
       
        :
    fi
done

echo -e "=========================================="
echo -e " Recon Complete."
echo -e "=========================================="
