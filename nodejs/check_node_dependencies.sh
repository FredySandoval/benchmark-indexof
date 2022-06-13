#!/bin/bash

# Check if the dependencies are installed
PACKAGEMANAGER=""
# Check if apt or pacman is installed
if [ -x "$(command -v apt)" ]; then
    PACKAGEMANAGER="apt"
elif [ -x "$(command -v pacman)" ]; then
    PACKAGEMANAGER="pacman"
fi

# Check if Curl is installed
if ! [ -x "$(command -v curl)" ]; then
  echo 'curl is not installed, Installing...'
  # Install curl
  if [ $PACKAGEMANAGER == "apt" ]; then
        sudo apt install curl
  elif [ $PACKAGEMANAGER == "pacman" ]; then
        sudo pacman -S curl
  fi
else 
  echo 'Curl is installed.'
fi
# Check if unzip is installed
if ! [ -x "$(command -v unzip)" ]; then
  echo 'unzip is not installed, Installing...'
  # Install unzip
  if [ $PACKAGEMANAGER == "apt" ]; then
        sudo apt install unzip
  elif [ $PACKAGEMANAGER == "pacman" ]; then
        sudo pacman -S unzip
  fi
else 
  echo 'unzip is installed.'
fi

# Checking if fnm is installed
if ! [ -x "$(command -v fnm)" ]; then
    echo 'Installing fnm, node version manager...'
  
    # Install node via fnm
    curl -fsSL https://fnm.vercel.app/install | bash
    
    # Append the String 'eval "$(fnm env --use-on-cd)"' to the end of the .bashrc file
    echo 'eval "$(fnm env --use-on-cd)"' >> ~/.bashrc

    # Reload the .bashrc file
else 
  echo 'node is installed.'
fi

source ~/.bashrc