#!/usr/bin/env python

import argparse
import json
import matplotlib.pyplot as plt
import numpy as np


def fn_moving_average(times, num_runs):
    times_padded = np.pad(
        times, (num_runs // 2, num_runs - 1 - num_runs // 2), mode="edge"
    )
    kernel = np.ones(num_runs) / num_runs
    return np.convolve(times_padded, kernel, mode="valid")

def AverageNumberOfList(lst):
    return sum(lst) / len(lst)

def GetMax(lst):
    return max(lst)

def Get20Porcent(num):
    return num * 0.2

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument(
    "-f",
    "--files",
    nargs="*",
    type=str,
    default=[],
    help="Array of file names to plot"
)
parser.add_argument("file", nargs='?', help="JSON file with benchmark results")
parser.add_argument("--title", help="Plot Title")
parser.add_argument("-o", "--output", help="Save image to the given filename.")
parser.add_argument(
    "-w",
    "--moving-average-width",
    type=int,
    metavar="num_runs",
    help="Width of the moving-average window (default: N/5)",
)

args = parser.parse_args()

results = []

# if not args.file 
if args.file:
    with open(args.file) as f:
        results = json.load(f)["results"]


filenames = args.files
for filename in filenames:
    with open(filename) as f:
        r = json.load(f)["results"]
        results.extend(r)

def get_mean(obj):
    return obj.get('mean')

results.sort(key=get_mean, reverse=True)

get_labels = [arr['command'] for arr in results]
get_times = [arr['times'] for arr in results]
get_median = AverageNumberOfList([arr['median'] for arr in results])
get_medians = [arr['median'] for arr in results]
max_of_get_medians = max(get_medians)
plus_20_percente_m_o_g_m = (max_of_get_medians * 0.2) + max_of_get_medians

num = len(get_times[0])
nums = range(num)
moving_average_width = (
    num // 3 if args.moving_average_width is None else args.moving_average_width
)
if moving_average_width < 1: # if moving_average_width == 0: will cause error
    moving_average_width = 1
    
colormap = plt.cm.nipy_spectral 
colors = [ "#ff0000", "#ef1002", "#df2004", "#cf3006", "#bf4008", "#af5009", "#9f600b", "#8f700d", "#80800f", "#708f11", "#609f13", "#50af15", "#40bf17", "#30cf18", "#20df1a", "#10ef1c", "#00ff1e"]
for i in range(len(get_labels)):
    moving_average = fn_moving_average(get_times[i], moving_average_width)
    # to get non-repetive colors use color=colormap(i / len(get_labels)
    plt.plot(nums, moving_average, "-", color=colors[i])


plt.axis([0, num - 1, 0, plus_20_percente_m_o_g_m])
plt.legend(labels=get_labels, loc="right", fontsize="medium", ncol=1)

plt.ylabel("Time in Seconds")
plt.xlabel("Number of Runs")

if args.title:
    plt.title(args.title)

if args.output:
    plt.savefig(args.output)
else:
    plt.show()
