# get all files in the all_node_benchmarks folder, and puts them in separate variables
# for each node version
cd "$(dirname "$0")"

array=($( ls ./nodejs/all_node_benchmarks ) ) 

python ./scripts/my_plot.py --files ./nodejs/all_node_benchmarks/${array[0]} ./nodejs/all_node_benchmarks/${array[1]} ./nodejs/all_node_benchmarks/${array[2]} ./nodejs/all_node_benchmarks/${array[3]} ./nodejs/all_node_benchmarks/${array[4]} ./nodejs/all_node_benchmarks/${array[5]} ./nodejs/all_node_benchmarks/${array[6]} ./nodejs/all_node_benchmarks/${array[7]} ./nodejs/all_node_benchmarks/${array[8]} ./nodejs/all_node_benchmarks/${array[9]} ./nodejs/all_node_benchmarks/${array[10]} ./nodejs/all_node_benchmarks/${array[11]} ./nodejs/all_node_benchmarks/${array[12]} ./nodejs/all_node_benchmarks/${array[13]} ./nodejs/all_node_benchmarks/${array[14]} 