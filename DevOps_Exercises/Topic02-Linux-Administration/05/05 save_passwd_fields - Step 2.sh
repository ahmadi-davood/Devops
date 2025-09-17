
#########################################################

sudo crontab -e

# Add this line to run daily at 2 AM:

0 2 * * * /usr/local/bin/save_passwd_fields.sh

0 2 * * * /bin/bash /usr/local/bin/save_passwd_fields_simple.sh


#########################################################