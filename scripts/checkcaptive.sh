#!/bin/bash
res=$(curl -sL -w "%{http_code}\\n" "http://clients3.google.com/generate_204" -o /dev/null)
echo "HTTP response:$res"
