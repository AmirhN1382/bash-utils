#!/bin/bash

# Token of Telegram bot
BOT_TOKEN=""

# chat_id of user who wants to get backup files in Telegram
CHAT_ID=0

# Current time in YYYY-MM-DD format
DATE=$(date +%F)

function telegram_send_message() {
    curl -F chat_id="$1" -F text="$2" https://api.telegram.org/bot$BOT_TOKEN/sendMessage &> /dev/null
}

function telegram_send_document() {
    curl -F chat_id="$1" -F document=@"$2" caption="$3" https://api.telegram.org/bot$BOT_TOKEN/sendDocument &> /dev/null
}

function backup_sources() {
    # Send current date to Telegram
    cd ..
    telegram_send_message $CHAT_ID "Source Backup - $DATE:"
    backup_file="./$DATE.sources.zip"
    zip -r $backup_file folder1 folder2 folder3 -x "**/node_modules/*"
    backup_file_size=$(stat -c%s $backup_file)
    telegram_send_document $CHAT_ID $backup_file
    rm $backup_file
}

backup_sources