 #!/bin/bash

# Makes sure the script is executed from its own current directory
cd "$(dirname "$0")"

# CURRENTVERSION=$(node -v)
TIMES=100

# Create an Array of names john doe jane doe
NODEVERSIONS=("v4.9.1" "v5.12.0" "v6.17.1" "v7.10.1" "v8.17.0" "v9.11.2" "v10.24.1" "v11.15.0" "v12.22.12" "v13.14.0" "v14.19.3" "v15.14.0" "v16.15.1" "v17.9.1" "v18.3.0")
# NODEVERSIONS=("v11.15.0" "v12.22.12" "v13.14.0" "v14.19.3" "v15.14.0" "v16.15.1" "v17.9.1" "v18.3.0") 

for version in "${NODEVERSIONS[@]}"; do
    ISVERSIONINSTALLED=$(fnm list | grep $version)
    if [ -z "$ISVERSIONINSTALLED" ]; then
        echo "Installing $version"
        fnm install $version
    else
        echo "Version $version installed, skipping..."
        sleep 0.1
    fi
done


# Check if hyperfine is installed
if ! [ -x "$(command -v hyperfine)" ]; then
    echo "Installing hyperfine"
    if [ -x "$(command -v apt)" ]; then
        wget https://github.com/sharkdp/hyperfine/releases/download/v1.14.0/hyperfine_1.14.0_amd64.deb
        sudo echo "Thanks."
        sudo dpkg -i hyperfine_1.14.0_amd64.deb
    elif [ -x "$(command -v pacman)" ]; then
        # Install hyperfine
        sudo echo "Thanks."
        sudo pacman -S hyperfine
    fi

fi

# Loop through the array
for version in "${NODEVERSIONS[@]}"; do
    # echo node version
    echo "OK"
    fnm use $version
    echo $(node -v)
    hyperfine --runs $TIMES --time-unit second "node ./indexof.js" --warmup 3 --export-json ./all_node_benchmarks/bench_node_$(node -v).json -n $(node -v)
done

sleep 2
# TITLE="NODE VERSIONS"
OUTPUT="results"
FILES=$(ls node_benchmarks/ | sed 's/^/.\/node_benchmarks\//')

# Check if python is installed
if [ -x "$(command -v python)" ]; then
    python ../scripts/my_plot.py --title="Node Versions" --output $OUTPUT --files $FILES
else
    echo "Python not installed, skipping..."
fi

# python ../scripts/my_plot.py --title "NODE VERSIONS COMPARISON" --output results --files $(ls node_benchmarks/ | sed 's/^/.\/node_benchmarks\//')