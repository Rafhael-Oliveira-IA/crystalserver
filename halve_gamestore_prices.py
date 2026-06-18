#!/usr/bin/env python3
"""Halve `price = <number>,` values in gamestore Lua files.

By default this script runs in dry-run mode and only reports planned changes.
Use --apply to write updates to disk.
"""

from __future__ import annotations

import argparse
import re
import shutil
from pathlib import Path


PRICE_LINE_RE = re.compile(r"^(\s*price\s*=\s*)(\d+)(\s*,.*)$")


def halve_prices_in_text(text: str) -> tuple[str, int, int]:
    """Return updated text, number of changed lines, and odd values found."""
    changed = 0
    odd_values = 0
    updated_lines: list[str] = []

    for line in text.splitlines(keepends=True):
        match = PRICE_LINE_RE.match(line)
        if not match:
            updated_lines.append(line)
            continue

        prefix, value_text, suffix = match.groups()
        value = int(value_text)
        if value % 2 != 0:
            odd_values += 1

        new_value = value // 2
        if new_value != value:
            changed += 1
            line_ending = "\n" if line.endswith("\n") else ""
            line = f"{prefix}{new_value}{suffix}{line_ending}"

        updated_lines.append(line)

    return "".join(updated_lines), changed, odd_values


def process_file(file_path: Path, apply_changes: bool, backup_ext: str) -> tuple[int, int]:
    original_text = file_path.read_text(encoding="utf-8")
    updated_text, changed, odd_values = halve_prices_in_text(original_text)

    if changed > 0 and apply_changes:
        backup_path = file_path.with_name(file_path.name + backup_ext)
        shutil.copy2(file_path, backup_path)
        file_path.write_text(updated_text, encoding="utf-8")

    return changed, odd_values


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Halve all `price = <number>,` values in gamestore Lua files."
    )
    parser.add_argument(
        "path",
        nargs="?",
        default="data/modules/scripts/gamestore",
        help="Root folder containing gamestore Lua files.",
    )
    parser.add_argument(
        "--apply",
        action="store_true",
        help="Apply changes in-place. Without this flag the script only reports.",
    )
    parser.add_argument(
        "--backup-ext",
        default=".bak",
        help="Backup suffix used when --apply is enabled (default: .bak).",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    root = Path(args.path)

    if not root.exists():
        print(f"Path not found: {root}")
        return 1

    lua_files = sorted(p for p in root.rglob("*.lua") if p.is_file())
    if not lua_files:
        print(f"No .lua files found under: {root}")
        return 1

    total_changed = 0
    total_odd_values = 0
    touched_files = 0

    mode = "APPLY" if args.apply else "DRY-RUN"
    print(f"Mode: {mode}")
    print(f"Scanning {len(lua_files)} Lua files under: {root}")

    for file_path in lua_files:
        changed, odd_values = process_file(file_path, args.apply, args.backup_ext)
        if changed > 0:
            touched_files += 1
            total_changed += changed
            total_odd_values += odd_values
            print(f"- {file_path}: {changed} prices updated")

    if touched_files == 0:
        print("No matching `price = <number>,` entries found.")
        return 0

    print(
        f"Done. Files touched: {touched_files} | Prices updated: {total_changed} | "
        f"Odd values truncated by //2: {total_odd_values}"
    )
    if not args.apply:
        print("Run again with --apply to write changes.")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())