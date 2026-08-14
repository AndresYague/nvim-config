"""Parse the neovim start time."""

import argparse

import numpy as np


def pretty_print(info: dict[str, list[float]], n_print: int = 10) -> None:
    """Sort and print the information."""
    # Create a new dictionary with the statistics
    sorted_keys = sorted(info.keys(), reverse=True, key=lambda x: info[x])

    info_stats = {}
    for key in sorted_keys:
        info_stats[key] = {"mean": np.mean(info[key]), "std": np.std(info[key])}

    total_time = 0.0
    for key in sorted_keys:
        total_time += info_stats[key]["mean"]

    s = ""
    for i, key in enumerate(sorted_keys):
        if i == n_print:
            break

        mean = info_stats[key]["mean"]
        std = info_stats[key]["std"]

        s += f"{key}: {mean:.2f} 󱓉 {std:.2f} {mean / total_time * 100:.2f}%\n"

    print(s)


def parse_file(fname: str) -> dict[str, list[float]]:
    """Parse the file and print out data."""
    info: dict[str, list[float]] = {}
    is_recording = False
    recorded_times = 0
    with open(fname, "r") as fread:
        for line in fread:
            # Start recording
            if "process: Embedded" in line:
                recorded_times += 1
                is_recording = True

            # Record the self time of each process only save each sample as a
            # list element so that we can do stats on it
            if is_recording and ": require" in line:
                line = line.replace(": require('", " ").replace("')", "")
                _, _, self_time, name = line.split()
                if name not in info:
                    info[name] = [0]
                elif len(info[name]) < recorded_times:
                    info[name].append(0)
                info[name][-1] += float(self_time)

            # Mark the end of the current data
            if is_recording and "--- NVIM STARTED ---" in line:
                is_recording = False

    return info


def main() -> None:
    """Orchestrate file reading."""
    parser = argparse.ArgumentParser()
    parser.add_argument("file", nargs=1)

    pretty_print(parse_file(parser.parse_args().file[0]))


if __name__ == "__main__":
    main()
