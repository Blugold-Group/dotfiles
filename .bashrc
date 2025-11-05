# ==============================
# Pentester's Bash Arsenal
# ==============================

# ------------------------------
# General Aliases
# ------------------------------

# Enhanced ls
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'

# Common typos
alias sl='ls'
alias cd..='cd ..'

# Cleaner terminal
alias cls='clear'

# ------------------------------
# Networking Tools
# ------------------------------

# Quick nmap scan
alias nmapscan="nmap -sC -sV -A"

# Quick port scan
alias portscan='nmap -T4 -p-'

# Full recon
alias fullrecon='nmap -A -T4 -p-'

# HTTP server for quick file transfers
alias serve="python3 -m http.server"

# Wireshark live capture on eth0
alias sniff="sudo tshark -i eth0"

# DNS recon
alias dnsrecon='dig ANY @8.8.8.8'

# ------------------------------
# Functions for Advanced Tasks
# ------------------------------

# Function to run an Nmap scan and save the results
nmap_save() {
    if [ -z "$1" ]; then
        echo "Usage: nmap_save <target>"
    else
        nmap -sC -sV -oN "nmap_$1_$(date +%Y%m%d).txt" "$1"
        echo "Scan saved to nmap_$1_$(date +%Y%m%d).txt"
    fi
}

# Auto enumerate SMB shares
smb_enum() {
    if [ -z "$1" ]; then
        echo "Usage: smb_enum <target>"
    else
        smbclient -L "\\\\$1" -N
    fi
}

# Extract open ports and run targeted Nmap scripts
nmap_ports() {
    if [ -z "$1" ]; then
        echo "Usage: nmap_ports <target>"
    else
        ports=$(nmap -p- --min-rate=1000 -T4 "$1" | grep "^[0-9]" | cut -d '/' -f 1 | tr '\n' ',' | sed 's/,$//')
        echo "Ports found: $ports"
        nmap -sC -sV -p"$ports" "$1"
    fi
}

# Quick HTTP brute force with gobuster
web_enum() {
    if [ -z "$1" ]; then
        echo "Usage: web_enum <URL>"
    else
        gobuster dir -u "$1" -w /usr/share/wordlists/dirb/common.txt -x php,html,txt -t 50
    fi
}

# Check for subdomains
subdomain_scan() {
    if [ -z "$1" ]; then
        echo "Usage: subdomain_scan <domain>"
    else
        for sub in www mail ftp admin; do
            ping -c 1 "$sub.$1" | grep PING | cut -d " " -f 2
        done
    fi
}

# ------------------------------
# Environment Settings
# ------------------------------

# Add tools to PATH
export PATH=$PATH:/usr/share/nmap/scripts:/opt/pentest-tools

# Pretty Prompt
export PS1="\[\e[32m\]\u@\h:\w\[\e[m\]$ "

# ------------------------------
# Final Touch: Welcome Message
# ------------------------------
cat <<'EOF'
                                  @@@@@@##@@@@@@@                                   
                             @@@       #%%##      @@                                
                         @@@      %%%##%  %%#%%%%     % %                           
                       @@          ##%%    %%##            @                        
                     @@  %%       ##%        %%#%       @%  @@                      
                   @@   %%@     ##%%          %%##      @%%   @@                    
                 ########      #%%              %%##     ########                   
                @@%%###%%%%%%##%%                @%###%%%%%%##%% @                  
               @@%@  %%###                               ##%%@  % @                 
              @@ @%%%   %%###                         ##%%@  %%%%  @                
              @   @%%%%%   %%###                   ##%%@  %%%@%@%   @               
              @    @%% @%%%   %%###             ##%%%  %%%@@ %@  %  @@              
                    @%%  @@%%%   %%###       ##%%%  %%%@@  %%@   %%  @              
             %@      @%%    @@%%%   %%### ##%%%   %%@@    %%@     %  @              
                 %%%%%@@       @@%%%   %%#%%   %%%@       @@%%%%% %  @@             
          %%%%%%@@@@       @#     @%%%      %%%@@    ##       @@@@%%%%%%            
         @%%%%              %###    @@%%  %%@@    ####               %%%@           
            @@%%%             %%%###  %%  %%   ##%%%@            %%%@@@             
               @@@%%%                 %%  %%                  %%@@@                 
             @     @%%                %%  %%                 %@@ %%                 
             @      @%%               %%  %%               %%@   %                  
              @      @%%              %%  %%              %%@   %                   
              @@   %  @%%             %%  %%             %%@   %   %%               
                   @%  @%%            %%  %%            %%@   %                     
                     %  @@%%%%        %%  %%        %%%%@@   %  @@                  
                      %%    @@%%%%%%  %%  %%  @%%%%%@@@    %   @@                   
                    @   %%       @@@%%%%  %%%%@@@             @                     
                     @@    %%              @         @      @@                      
                       @@     %%%                   @@   @@                         
                          @@          %%%%%%%%%%      @@@                           
                                                  @@@                               
                                   @@@@@@@@@@@@                                     

EOF

echo -e "\033[1;38;2;65;105;225mWelcome, Operator. Ready to hack the planet?\033[0m"
