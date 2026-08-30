"""Parse the neovim start time."""

import argparse
import re

import numpy as np


class InfoParser:
    """Parse the information from the line."""

    def __init__(self) -> None:
        """Take in a string, it must have 'require'."""
        self.info_tree: dict[str, dict[str, list[float] | InfoParser]] = {}
        self.total_time: float = 0

    def __add_keys(self, keys: list[str], times: list[float], recorded_times) -> None:
        """Add info to the dictionary, recurse through different keys."""
        # Get the times
        _, elapsed, self_time = times

        name = keys[0]

        # Add the times to the info_tree
        if name not in self.info_tree:
            self.info_tree[name] = {"elapsed": [0], "self": [0]}

        elapsed_list = self.info_tree[name]["elapsed"]
        self_list = self.info_tree[name]["self"]
        assert type(elapsed_list) == list
        assert type(self_list) == list

        if len(elapsed_list) < recorded_times:
            elapsed_list.append(0)
            self_list.append(0)
        elapsed_list[-1] += elapsed
        self_list[-1] += self_time

        if len(keys) > 1:
            if "sub_info" not in self.info_tree[name]:
                self.info_tree[name]["sub_info"] = InfoParser()

            sinfo = self.info_tree[name]["sub_info"]
            assert type(sinfo) == InfoParser

            sinfo.__add_keys(keys[1:], times, recorded_times)

    def add_string(self, string: str, recorded_times: int) -> None:
        """Add more info."""
        assert "require" in string

        # This takes the first three times of the string
        times = [float(x) for x in string.replace(":", "").split()[0:3]]
        # This finds all the dot-separated values inside of "require"
        required = [
            x.strip()
            for x in re.sub("^.*require\\('(.*)'\\)", "\\1", string).split(".")
        ]

        self.__add_keys(required, times, recorded_times)

    def pretty_string(
        self, n_print: int = 10, sort_elapsed: bool = False, depth: int | None = None
    ) -> str:
        """Sort and print the self.info_treermation."""
        # Sort the keys by self time or elapsed time
        if sort_elapsed:
            sort_type = "elapsed"
        else:
            sort_type = "self"

        sorted_keys = sorted(
            self.info_tree.keys(),
            reverse=True,
            key=lambda x: np.mean(self.info_tree[x][sort_type]),  # type: ignore
        )

        s = ""
        for i, key in enumerate(sorted_keys):
            if i == n_print:
                break

            elapsed_list = self.info_tree[key]["elapsed"]
            self_list = self.info_tree[key]["self"]
            assert type(elapsed_list) == list
            assert type(self_list) == list

            mean_elapsed = np.mean(elapsed_list)
            std_elapsed = np.std(elapsed_list)
            mean_self = np.mean(self_list)
            std_self = np.std(self_list)

            s += f"{key}:\n"
            s += f"    self: {mean_self:.2f} 󱓉 {std_self:.2f}\n"
            s += f"    elapsed: {mean_elapsed:.2f} 󱓉 {std_elapsed:.2f}\n"

            if "sub_info" in self.info_tree[key]:
                sinfo = self.info_tree[key]["sub_info"]
                assert type(sinfo) == InfoParser

                lines = None
                if depth and depth > 1:
                    lines = sinfo.pretty_string(n_print, sort_elapsed, depth - 1)
                elif depth is None:
                    lines = sinfo.pretty_string(n_print, sort_elapsed)

                # Tab the sub-line for clarity
                if lines:
                    s += "\n".join("    " + x for x in lines.strip().split("\n")) + "\n"

        return s


def parse_file(fname: str) -> InfoParser:
    """Parse the file and print out data."""
    info = InfoParser()
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
                info.add_string(line, recorded_times)

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
    parser.add_argument("-d", "--depth", type=int)

    args = parser.parse_args()
    n_lines = args.n_lines if args.n_lines else 10
    print(
        parse_file(args.file[0]).pretty_string(
            n_print=n_lines, sort_elapsed=args.elapsed, depth=args.depth
        )
    )


if __name__ == "__main__":
    main()
