# MoltenBot `.github` Repository

This repository contains organization-level metadata and guardrails used by automation for the `Molten-Bot` GitHub org.

## Repository Layout

- `profile/README.md`: public organization profile content.
- `scripts/validate-repo.sh`: local and CI repository policy validator.
- `.github/workflows/ci.yml`: CI entrypoint that runs repository validation.

## Task Routing

Use this repository for:

- organization profile documentation updates.
- GitHub automation and repository policy checks.
- git hygiene updates that prevent generated task artifacts from being committed.

Do not use this repository for product/runtime application features. Those belong in the corresponding service repositories.
