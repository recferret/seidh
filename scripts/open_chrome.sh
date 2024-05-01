#!/bin/bash
chrome 
    --ignore-certificate-errors-spki-list=xlWN/zo6uNlhvMAgORPO4KLy7Bxp+w8jLUrOvgOc1yk= \
    --origin-to-force-quic-on=23.111.202.19:443 \
    --user-data-dir=quic-user-data \
    https://23.111.202.19:3000