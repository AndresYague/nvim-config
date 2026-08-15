"""Parse the neovim start time."""

import argparse

import numpy as np


def pretty_print(
    info: dict[str, dict[str, list[float]]], n_print: int = 10, sort_elapsed=False
) -> None:
    """Sort and print the information."""
    # Sort the keys by self time or elapsed time
    if sort_elapsed:
        sort_type = "elapsed"
    else:
        sort_type = "self"

    sorted_keys = sorted(info.keys(), reverse=True, key=lambda x: info[x][sort_type])

    # Create a new dictionary with the statistics
    info_stats: dict[str, dict[str, dict[str, float]]] = {}
    for key in sorted_keys:
        info_stats[key] = {}
        info_stats[key]["elapsed"] = {
            "mean": np.mean(info[key]["elapsed"]),
            "std": np.std(info[key]["elapsed"]),
        }
        info_stats[key]["self"] = {
            "mean": np.mean(info[key]["self"]),
            "std": np.std(info[key]["self"]),
        }

    # Save the total self time to print out percentages
    total_time = 0.0
    for key in sorted_keys:
        total_time += info_stats[key]["self"]["mean"]

    # Printing block
    s = ""
    for i, key in enumerate(sorted_keys):
        if i == n_print:
            break

        mean_elapsed = info_stats[key]["elapsed"]["mean"]
        std_elapsed = info_stats[key]["elapsed"]["std"]
        mean_self = info_stats[key]["self"]["mean"]
        std_self = info_stats[key]["self"]["std"]

        s += f"{key}:\n"
        s += f"    self: {mean_self:.2f} 󱓉 {std_self:.2f} {mean_self / total_time * 100:.2f}%\n"
        s += f"    elapsed: {mean_elapsed:.2f} 󱓉 {std_elapsed:.2f} {mean_elapsed / total_time * 100:.2f}%\n"

    print(s)


def parse_file(fname: str) -> dict[str, dict[str, list[float]]]:
    """Parse the file and print out data."""
    info: dict[str, dict[str, list[float]]] = {}
    is_recording = False
    recorded_times = 0
    end_clock = 0.0
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
                clock, elapsed, self_time, name = line.split()
                if name not in info:
                    info[name] = {"elapsed": [0], "self": [0]}
                elif len(info[name]["elapsed"]) < recorded_times:
                    info[name]["elapsed"].append(0)
                    info[name]["self"].append(0)
                info[name]["elapsed"][-1] += float(elapsed)
                info[name]["self"][-1] += float(self_time)
                end_clock = max(float(clock), end_clock)

            # Mark the end of the current data
            if is_recording and "--- NVIM STARTED ---" in line:
                is_recording = False

    return info


def main() -> None:
    """Orchestrate file reading."""
    parser = argparse.ArgumentParser()
    parser.add_argument("file", nargs=1)
    parser.add_argument("-e", "--elapsed", action="store_true")
    parser.add_argument("-n", "--n_lines", type=int)

    args = parser.parse_args()
    n_lines = args.n_lines if args.n_lines else 10
    pretty_print(parse_file(args.file[0]), n_print=n_lines, sort_elapsed=args.elapsed)


if __name__ == "__main__":
    main()
