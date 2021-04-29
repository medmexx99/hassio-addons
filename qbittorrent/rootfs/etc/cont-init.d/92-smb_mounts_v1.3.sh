#!/usr/bin/with-contenv bashio

####################
# MOUNT SMB SHARES #
####################
if bashio::config.has_value 'networkdisks'; then
    # Mount CIFS Share if configured and if Protection Mode is active
    bashio::log.info 'Mounting smb share(s)...'

    # Define variables 
    MOREDISKS=$(bashio::config 'networkdisks')
    CIFS_USERNAME=$(bashio::config 'cifsusername')
    CIFS_PASSWORD=$(bashio::config 'cifspassword')

    if bashio::config.has_value 'cifsdomain'; then 
      DOMAIN=",domain=$(bashio::config 'cifsdomain')" 
    else
      DOMAIN=""
    fi
 
    # Mounting disks
    for disk in ${MOREDISKS//,/ }  # Separate comma separated values
    do
      # Clean name of network share
      disk=$(echo $disk | sed "s,/$,,") # Remove / at end of name
      diskname=${disk//\\//} #replace \ with /
      diskname=${diskname##*/} # Get only last part of the name
      # Prepare mount point
      mkdir -p /mnt/$diskname
      chown -R root:root /mnt/$diskname
      
      #Tries to mount with default options
      mount -t cifs -o rw,iocharset=utf8,file_mode=0777,dir_mode=0777,uid=0,gid=0,forceuid,forcegid,username="$CIFS_USERNAME",password="${CIFS_PASSWORD}"$DOMAIN $disk /mnt/$diskname
      
      # if Fail test different smb and sec versions
      while [ $? -ne 0 ]; do
            # Declare all possible options
            declare -a SMBVERSION=( ",vers=2.1" ",vers=3.0" ",vers=1.0" ",vers=3.1.1" ",vers=2.0" ",vers=3.0.2" )
            declare -a SECVERSION=( ",sec=ntlmi" ",sec=ntlmv2" ",sec=ntlmv2i" ",sec=ntlmssp" ",sec=ntlmsspi" ",sec=ntlm" ",sec=krb5i" ",sec=krb5" ",sec=" )

            # Test all options until successful
            for SMBVERS in ${SMBVERSION[@]}; do
                for SECVERS in ${SECVERSION[@]}; do
                     bashio::log.warning "... trying to mount with $SMBVERS $SECVERS"
                     mount -t cifs -o rw,iocharset=utf8,file_mode=0777,dir_mode=0777,uid=$(id -u),gid=$(id -g),forceuid,forcegid,username="$CIFS_USERNAME",password="${CIFS_PASSWORD}"$DOMAIN $disk /mnt/$diskname || \
                     mount -t cifs -o rw,iocharset=utf8,file_mode=0777,dir_mode=0777,username="$CIFS_USERNAME",password="${CIFS_PASSWORD}"$DOMAIN$SMBVERS $disk /mnt/$diskname || \
                     mount -t cifs -o rw,iocharset=utf8,file_mode=0777,dir_mode=0777,username="$CIFS_USERNAME",password="${CIFS_PASSWORD}"$DOMAIN$SMBVERS$SECVERS $disk /mnt/$diskname
                done
            done
      done

      # Messages
      if [ $? = 0 ]; then
        bashio::log.info "... $disk successfully mounted to /mnt/$diskname"
        #Test write permissions
        touch /mnt/$diskname/testaze && rm /mnt/$diskname/testaze || bashio::log.fatal "Unable to write in the shared disk. Please check UID/GID for permissions, and if the share is rw" 
      else
        # message if still fail
        bashio::log.fatal "Unable to mount $disk to /mnt/$diskname with username $CIFS_USERNAME, $CIFS_PASSWORD. Please check your remote share path, username, password, domain" # Mount share
      fi

    done
fi