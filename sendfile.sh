#!/bin/bash

# Get date and time
DATE=$(date +"%m-%d-%y")


######################### Colours ############################

ON_BLUE=`echo -e "\033[44m"`
RED=`echo -e "\033[1;31m"`
BLUE=`echo -e "\033[1;34m"`
GREEN=`echo -e "\033[1;32m"`
STD=`echo -e "\033[0m"`		# Clear colour


##############################################################
echo "________________________________________________________"
echo " "
echo "$GREEN            ViP3R-KERNEL   ${STD}"
echo " "
echo " ${RED}       TELEGRAM KERNEL MANAGER${STD}"
echo " "
echo "$GREEN             DATE:$DATE   ${STD}"
echo "________________________________________________________"
echo " "

######################## BOT INFO ############################

BOT_TOKEN=""
CHAT_ID=""
kernel_path=""
module_path=""


# Function to send a message to Telegram
send_message() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
    -d "chat_id=$CHAT_ID" \
    -d "text=$message"
}
send_message "Congrulation! Build Successful.. UPLOADING here..."
echo " "
echo "_____________________________________"
echo " "
echo " ${RED}             Message Send ${STD}"
echo "_____________________________________"
echo " "
echo " ${ON_BLUE}       Uploading to Telegram${STD}"
echo " "
echo " "
			
# Function to send a file to Telegram
send_file() {
    local kernel_path="$1"
    local caption="$2"
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendDocument" \
    -F "chat_id=$CHAT_ID" \
    -F "document=@$kernel_path" \
    -F "caption=$caption"
}

send_file "" "Your Kernel is here." > /dev/null
echo " ${ON_BLUE}        Kernel Upload Complete ${STD}"

send_file "" "Kernel Modules is here." > /dev/null
echo " ${ON_BLUE}      Module Upload Complete ${STD}"
