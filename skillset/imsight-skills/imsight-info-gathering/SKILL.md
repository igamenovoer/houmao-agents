---
name: imsight-info-gathering
description: Imsight-authored online information gathering command workflow for searching the web, extracting or downloading sources, building source ledgers, and producing synthesized reports from multiple sources. Use when explicitly invoked as imsight-info-gathering, routed from another Imsight skill, when a prompt asks for Imsight-style research or reporting, or when `imsight` context covers online search, source download/extraction, and synthesis into a cited report.
---

# Imsight Info Gathering

## Overview

Use this skill as the Imsight research SOP for online information work. Prefer explicit source ledgers, primary-source bias, reproducible downloads, and synthesized conclusions over loose search-result summaries.

This skill can route to other Imsight skills in the same suite. If the task needs tool installation, network setup, proxy repair, or environment bootstrapping, use the matching Imsight skill before continuing.

## Invocation Contract

- Preferred explicit form: `$imsight-info-gathering use <subcommand> to do <task>`.
- Task-only form: `$imsight-info-gathering <task prompt>` means choose the applicable research subcommand or sequence from the task.
- No subcommand and no task means `help`.
- `help` summarizes this skill and lists the subcommands below.

## Subcommands

| Subcommand | Use For | Load |
| --- | --- | --- |
| `help` | Explain this information-gathering skill and list available subcommands | This entrypoint |
| `search` | Discover relevant online sources and decide source classes | `references/source-handling.md` |
| `download-sources` | Download or extract durable source material into a local corpus | `references/source-handling.md` |
| `source-ledger` | Build or maintain a source ledger with source metadata, use, and reliability notes | `references/source-handling.md` |
| `source-pack` | Produce a local source pack with raw files, processed notes, and a manifest | `references/source-handling.md` and `references/report-synthesis.md` |
| `synthesize-report` | Produce a synthesized cited report, comparison, recommendation, market scan, or literature scan | `references/report-synthesis.md` |

## Workflow

1. If no subcommand or actionable task is present, handle `help`: summarize this skill and list the subcommands.
2. If the request names a subcommand, load the matching reference file and follow that subcommand.
3. If the request is task-only, identify the deliverable and choose the applicable subcommand or sequence: quick answer, source pack, literature scan, market map, technical comparison, or full report.
4. Decide the evidence bar: primary sources for technical, legal, financial, medical, standards, product docs, and company facts; corroborated reputable sources for news or market context.
5. Search broad, then narrow. Prefer dedicated search/extract/crawl/research tools when available; otherwise use normal web browsing and command-line downloads.
6. Maintain a source ledger while working: URL, title, publisher, date accessed, publish date if available, why it matters, and whether it is primary or secondary.
7. Download or extract durable source material when the user asks for downloads, when sources are likely to move, or when a report needs an auditable local corpus.
8. Synthesize across sources. Separate findings, conflicts, uncertainty, and recommendations. Do not pad the report with source-by-source summaries unless the user asked for an annotated bibliography.

## Routing

- Use `imsight-dev-box-init` when missing tooling must be installed, such as Tavily CLI, crawling utilities, PDF tools, or other development/research dependencies.
- Use `imsight-dev-box-network` when downloads fail because of proxy, tunnel, DNS, SSH, or dev-box connectivity issues.
- Use existing Tavily skills when available: search for discovery, extract for specific URLs, crawl for documentation sections, and research for comprehensive multi-source reports.
- Use official documentation or primary repositories for technical library/API behavior before relying on blogs or generated examples.

## Source Handling

Load `references/source-handling.md` when the task involves downloads, local corpora, source ledgers, web extraction, PDF/article collection, or reproducibility requirements.

## Report Synthesis

Load `references/report-synthesis.md` when producing a synthesized report, comparison, recommendation, market/literature scan, or any answer that must reconcile multiple sources.

## Defaults

- Save working material under a task-specific scratch directory only when local artifacts are useful; otherwise avoid clutter.
- Use stable, descriptive filenames: `<date>-<publisher-or-domain>-<slug>.<ext>`.
- Cite sources with links in the final answer whenever external information shaped the conclusion.
- State uncertainty directly when sources disagree, are stale, or are not authoritative enough.
