#!/usr/bin/env python3
"""Convert this project's report markdown into a LaTeX body file.

This is not a general Markdown converter. It covers the patterns used by
../rrrrrreporrrrrrt.md so the LaTeX project can be refreshed without Pandoc.
"""

from __future__ import annotations

import re
import unicodedata
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rrrrrreporrrrrrt.md"
TARGET = ROOT / "latex" / "content.tex"


TEXT_REPLACEMENTS = {
    "\u2018": "'",
    "\u2019": "'",
    "\u201c": '"',
    "\u201d": '"',
    "\u2013": "--",
    "\u2014": "---",
    "\u2026": r"\ldots{}",
    "\u03b1": r"$\alpha$",
    "\u03b2": r"$\beta$",
    "\u03b5": r"$\varepsilon$",
    "\u2264": r"$\le$",
    "\u2265": r"$\ge$",
    "\u2248": r"$\approx$",
    "\u2192": r"$\to$",
    "\u00b2": "ZZZSUPERSCRIPTTWOZZZ",
}

CODE_REPLACEMENTS = {
    "\u2018": "'",
    "\u2019": "'",
    "\u201c": '"',
    "\u201d": '"',
    "\u2013": "-",
    "\u2014": "-",
    "\u2026": "...",
    "\u03b1": "alpha",
    "\u03b2": "beta",
    "\u03b5": "epsilon",
    "\u2264": "<=",
    "\u2265": ">=",
    "\u2248": "~",
    "\u2192": "->",
    "\u00b2": "^2",
}

SECTION_COMMANDS = {
    1: "section",
    2: "subsection",
    3: "subsubsection",
    4: "paragraph",
}

ESCAPED_STAR = "ZZZESCAPEDSTARZZZ"
ESCAPED_PIPE = "ZZZESCAPEDPIPEZZZ"
SUPERSCRIPT_TWO = "ZZZSUPERSCRIPTTWOZZZ"
MATH_R_SQUARED = "ZZZMATHRSQUAREDZZZ"


def replace_many(text: str, mapping: dict[str, str]) -> str:
    for old, new in mapping.items():
        text = text.replace(old, new)
    return text


def escape_text(text: str) -> str:
    text = replace_many(text, TEXT_REPLACEMENTS)
    text = text.replace("R" + SUPERSCRIPT_TWO, MATH_R_SQUARED)
    text = text.replace("R^2", MATH_R_SQUARED)
    text = text.replace(ESCAPED_STAR, "*").replace(ESCAPED_PIPE, "|")
    text = text.replace(r"\*", "*").replace(r"\|", "|")

    escaped = []
    for ch in text:
        if ch == "\\":
            escaped.append(r"\textbackslash{}")
        elif ch == "&":
            escaped.append(r"\&")
        elif ch == "%":
            escaped.append(r"\%")
        elif ch == "#":
            escaped.append(r"\#")
        elif ch == "_":
            escaped.append(r"\_")
        elif ch == "{":
            escaped.append(r"\{")
        elif ch == "}":
            escaped.append(r"\}")
        elif ch == "~":
            escaped.append(r"\textasciitilde{}")
        elif ch == "^":
            escaped.append(r"\textasciicircum{}")
        elif ch == "<":
            escaped.append(r"\textless{}")
        elif ch == ">":
            escaped.append(r"\textgreater{}")
        else:
            escaped.append(ch)
    return (
        "".join(escaped)
        .replace(MATH_R_SQUARED, r"$R^2$")
        .replace(SUPERSCRIPT_TWO, r"\textsuperscript{2}")
    )


def code_text(text: str) -> str:
    text = replace_many(text, CODE_REPLACEMENTS)
    text = text.replace("\t", "    ")
    return text


def texttt(raw: str) -> str:
    return r"\texttt{\detokenize{" + code_text(raw) + "}}"


def convert_link(label: str, target: str) -> str:
    label_tex = render_basic_markup(label)
    if target.startswith("#"):
        return r"\hyperref[sec:" + target[1:] + r"]{\sectionlink{" + label_tex + "}}"
    return label_tex


def render_basic_markup(text: str) -> str:
    text = text.replace(r"\*", ESCAPED_STAR).replace(r"\|", ESCAPED_PIPE)
    rendered = []
    cursor = 0

    while cursor < len(text):
        if text.startswith("**", cursor):
            end = text.find("**", cursor + 2)
            if end != -1:
                rendered.append(r"\textbf{" + escape_text(text[cursor + 2 : end]) + "}")
                cursor = end + 2
                continue

        if text[cursor] == "*" and (cursor == 0 or text[cursor - 1] != "\\"):
            end = cursor + 1
            while True:
                end = text.find("*", end)
                if end == -1 or text[end - 1] != "\\":
                    break
                end += 1
            if end != -1:
                rendered.append(r"\emph{" + escape_text(text[cursor + 1 : end]) + "}")
                cursor = end + 1
                continue

        next_mark = len(text)
        for marker in ("**", "*"):
            position = text.find(marker, cursor + 1)
            if position != -1:
                next_mark = min(next_mark, position)
        rendered.append(escape_text(text[cursor:next_mark]))
        cursor = next_mark

    return "".join(rendered)


def convert_markup_in_text(text: str) -> str:
    rendered = []
    cursor = 0
    for match in re.finditer(r"\[([^\]]+)\]\(([^)]+)\)", text):
        rendered.append(render_basic_markup(text[cursor : match.start()]))
        rendered.append(convert_link(match.group(1), match.group(2)))
        cursor = match.end()
    rendered.append(render_basic_markup(text[cursor:]))
    return "".join(rendered)


def inline_tex(text: str) -> str:
    parts = re.split(r"(`[^`]*`|\$[^$]+\$)", text)
    rendered = []

    for part in parts:
        if not part:
            continue
        if part.startswith("`") and part.endswith("`"):
            rendered.append(texttt(part[1:-1]))
        elif part.startswith("$") and part.endswith("$"):
            rendered.append(part)
        else:
            rendered.append(convert_markup_in_text(part))

    return "".join(rendered)


def image_path(path: str) -> str:
    if path.startswith("plottwists/"):
        return "figures/" + path
    return "../" + path


def figure_width(raw_width: str | None, count: int) -> str:
    if raw_width:
        pct = max(1, min(100, int(raw_width)))
        return f"{pct / 100:.2f}\\linewidth"
    if count > 1:
        return f"{0.92 / count:.2f}\\linewidth"
    return "0.88\\linewidth"


def caption_from(alt: str, path: str) -> str:
    if alt.strip() and alt.strip().lower() != "alt text":
        return inline_tex(alt.replace("_", " "))
    stem = Path(path).stem.replace("_", " ")
    return inline_tex(stem)


def parse_images(line: str) -> list[tuple[str, str, str | None]]:
    pattern = re.compile(r"!\[([^\]]*)\]\(([^)]+)\)(?:\{width=(\d+)%\})?")
    return [(m.group(1), m.group(2), m.group(3)) for m in pattern.finditer(line)]


def emit_figure(line: str, caption: str | None = None) -> list[str]:
    images = parse_images(line)
    if not images:
        return []

    out = ["\\begin{figure}[H]", "\\centering"]
    captions = []
    for index, (alt, path, width) in enumerate(images):
        if index:
            out.append("\\hfill")
        out.append(
            "\\includegraphics[width="
            + figure_width(width, len(images))
            + "]{"
            + image_path(path)
            + "}"
        )
        captions.append(caption_from(alt, path))
    out.append("\\caption{" + (caption if caption is not None else " / ".join(captions)) + "}")
    out.append("\\end{figure}")
    out.append("")
    return out


def split_table_row(line: str) -> list[str]:
    placeholder = "@@LATEX_ESCAPED_PIPE@@"
    line = line.strip().strip("|").replace(r"\|", placeholder)
    cells = [cell.strip().replace(placeholder, "|") for cell in line.split("|")]
    return cells


def emit_table(lines: list[str], caption: str | None = None) -> list[str]:
    rows = [split_table_row(row) for row in lines if not re.match(r"^\|\s*:?-+", row)]
    if not rows:
        return []

    columns = len(rows[0])
    spec = "l" * columns
    out = ["\\begin{table}[H]", "\\centering"]
    if caption:
        out.append("\\caption{" + caption + "}")
    out.extend([f"\\begin{{tabular}}{{{spec}}}", "\\toprule"])
    for index, row in enumerate(rows):
        row = row + [""] * (columns - len(row))
        out.append(" & ".join(inline_tex(cell) for cell in row[:columns]) + r" \\")
        if index == 0:
            out.append("\\midrule")
    out.extend(["\\bottomrule", "\\end{tabular}", "\\end{table}", ""])
    return out


def is_table_line(line: str) -> bool:
    return line.strip().startswith("|") and line.strip().endswith("|")


def emit_listing(lines: list[str], caption: str | None = None) -> list[str]:
    options = "style=rconsole"
    if caption:
        options += ",caption={" + caption + "}"
    return [r"\begin{lstlisting}[" + options + "]", *lines, r"\end{lstlisting}", ""]


def italic_caption(line: str) -> str | None:
    match = re.match(r"^\*([^*].*?)\*$", line.strip())
    if not match:
        return None
    return inline_tex(match.group(1).strip())


def section_label(title: str) -> str:
    text = re.sub(r"`([^`]*)`", r"\1", title).strip().lower()
    text = unicodedata.normalize("NFKD", text).encode("ascii", "ignore").decode("ascii")
    text = re.sub(r"[^a-z0-9\s-]", "", text)
    text = re.sub(r"\s+", "-", text.strip())
    text = re.sub(r"-+", "-", text)
    return text


def main() -> None:
    source_lines = SOURCE.read_text(encoding="utf-8").splitlines()
    output: list[str] = [
        "% Generated by tools/md_to_tex.py from ../rrrrrreporrrrrrt.md.",
        "% Edit the markdown source or the converter, then run `make content`.",
        "",
    ]

    paragraph: list[str] = []
    in_code = False
    in_math = False
    code_buffer: list[str] = []
    list_stack: list[int] = []
    table_buffer: list[str] = []
    pending_block: tuple[str, object] | None = None

    def close_lists() -> None:
        while list_stack:
            output.append("\\end{itemize}")
            list_stack.pop()
        if output and output[-1] != "":
            output.append("")

    def flush_paragraph() -> None:
        if paragraph:
            output.append(inline_tex(" ".join(part.strip() for part in paragraph)))
            output.append("")
            paragraph.clear()

    def flush_table() -> None:
        if table_buffer:
            set_pending("table", table_buffer.copy())
            table_buffer.clear()

    def set_pending(kind: str, payload: object) -> None:
        flush_pending()
        nonlocal_pending[0] = (kind, payload)

    nonlocal_pending: list[tuple[str, object] | None] = [None]

    def flush_pending(caption: str | None = None) -> None:
        block = nonlocal_pending[0]
        if block is None:
            return
        kind, payload = block
        if kind == "listing":
            output.extend(emit_listing(payload, caption))  # type: ignore[arg-type]
        elif kind == "figure":
            output.extend(emit_figure(payload, caption))  # type: ignore[arg-type]
        elif kind == "table":
            output.extend(emit_table(payload, caption))  # type: ignore[arg-type]
        nonlocal_pending[0] = None

    for raw_line in source_lines:
        line = raw_line.rstrip()

        if in_code:
            if line.startswith("```"):
                set_pending("listing", code_buffer.copy())
                code_buffer.clear()
                in_code = False
            else:
                code_buffer.append(code_text(line))
            continue

        if in_math:
            if line.strip() == "$$":
                output.append(r"\]")
                output.append("")
                in_math = False
            else:
                output.append(line)
            continue

        if not line.strip():
            flush_paragraph()
            flush_table()
            close_lists()
            continue

        if line.strip().startswith("<!--") and line.strip().endswith("-->"):
            continue

        if table_buffer and not is_table_line(line):
            flush_table()

        caption = italic_caption(line)
        if caption and nonlocal_pending[0] is not None:
            flush_paragraph()
            close_lists()
            flush_pending(caption)
            continue

        flush_pending()

        if line.startswith("```"):
            flush_paragraph()
            flush_table()
            close_lists()
            in_code = True
            continue

        if line.strip() == "$$":
            flush_paragraph()
            flush_table()
            close_lists()
            output.append(r"\[")
            in_math = True
            continue

        if is_table_line(line):
            flush_paragraph()
            close_lists()
            table_buffer.append(line)
            continue

        flush_table()

        images = parse_images(line)
        if images and line.strip().startswith("!["):
            flush_paragraph()
            close_lists()
            set_pending("figure", line)
            continue

        heading = re.match(r"^(#{1,6})\s+(.*)$", line)
        if heading:
            flush_paragraph()
            close_lists()
            level = min(len(heading.group(1)), 4)
            command = SECTION_COMMANDS[level]
            title = heading.group(2).strip()
            output.append("\\" + command + "{" + inline_tex(title) + "}")
            output.append("\\label{sec:" + section_label(title) + "}")
            output.append("")
            continue

        if line.startswith("***") and line.endswith("***") and len(line) > 6:
            flush_paragraph()
            close_lists()
            # The opening markdown title is represented by main.tex.
            continue

        bullet = re.match(r"^(\s*)-\s+(.*)$", line)
        if bullet:
            flush_paragraph()
            indent = len(bullet.group(1).replace("\t", "    "))
            while list_stack and indent < list_stack[-1]:
                output.append("\\end{itemize}")
                list_stack.pop()
            if not list_stack or indent > list_stack[-1]:
                output.append("\\begin{itemize}")
                list_stack.append(indent)
            output.append("\\item " + inline_tex(bullet.group(2)))
            continue

        line = line.replace("<br>", " ")
        paragraph.append(line)

    flush_paragraph()
    flush_table()
    close_lists()
    flush_pending()

    rendered = "\n".join(output).rstrip() + "\n"

    rendered = rendered.replace(
        r"""\[
\begin{array}{rllllll}
\text{Test globale } F && H_0: \beta_1 = \dots = \beta_p = 0 && H_A: \text{almeno un } \beta_j \neq 0 && F = \frac{MSQR}{MSQE} = \displaystyle{\frac{\frac{SQR}{p}}{\frac{SQE}{n-(p+1)}}} \\\\
\text{Test } t \text{ sui coefficienti} && H_0: \beta_j = 0 && H_A: \beta_j \neq 0  && t_j =\displaystyle{\frac{\hat{\beta}_j}{\text{SE}(\hat{\beta}_j)}}
\end{array}
\]""",
        r"""\[
\begin{aligned}
\text{Test globale } F:\quad
& H_0: \beta_1 = \dots = \beta_p = 0,\quad
  H_A: \text{almeno un } \beta_j \neq 0\\
& F = \frac{MSQR}{MSQE}
    = \displaystyle{\frac{\frac{SQR}{p}}{\frac{SQE}{n-(p+1)}}}\\[0.6em]
\text{Test } t \text{ sui coefficienti}:\quad
& H_0: \beta_j = 0,\quad H_A: \beta_j \neq 0\\
& t_j = \displaystyle{\frac{\hat{\beta}_j}{\text{SE}(\hat{\beta}_j)}}
\end{aligned}
\]""",
    )

    rendered = rendered.replace(
        r"""Y = 141.16 - 9.88 \cdot \text{x1\_ISO} - 9.23 \cdot \text{x2\_T} + 5.96 \cdot \text{x3\_MP} - 8.20 \cdot \text{x6\_GSI} - 3.65 \cdot \text{x2\_T}^2 - 4.09 \cdot \text{x7\_UA}^2 + \varepsilon""",
        r"""\begin{aligned}
Y =\;& 141.16 - 9.88 \cdot \text{x1\_ISO}
       - 9.23 \cdot \text{x2\_T}
       + 5.96 \cdot \text{x3\_MP}\\
     & - 8.20 \cdot \text{x6\_GSI}
       - 3.65 \cdot \text{x2\_T}^2
       - 4.09 \cdot \text{x7\_UA}^2 + \varepsilon
\end{aligned}""",
    )

    TARGET.write_text(rendered, encoding="utf-8")


if __name__ == "__main__":
    main()
