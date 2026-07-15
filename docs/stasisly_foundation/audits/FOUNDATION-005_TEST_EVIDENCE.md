# FOUNDATION-005 Test Evidence

## Metadata

| Field | Value |
|---|---|
| Status | ACTIVE evidence |
| Execution | Local only |
| Baseline | `e053684` |
| Remote fallback | Not used |
| Implementation changes | None |

## Results

| Command | Result | Evidence |
|---|---|---|
| `flutter analyze --no-fatal-infos` | PASS | Exit 0; 52 informational diagnostics, no warning/error failure. |
| `flutter test` | PASS | 406 passed, 5 skipped, 0 failed. |
| `deno test supabase/functions` | PASS | 52 passed, 0 failed across 8 test modules. |
| `supabase status` | PASS | Local loopback development stack running; auxiliary services partially stopped but DB/API available. |
| `supabase db reset --local --no-seed` | PASS | Recreated local DB and applied migrations 00001–00008; no seed executed. |
| `supabase test db --local` | PASS | 16 files, 479 assertions, all successful. |

Total passing checks reported by the executable suites: 937. This total is an
evidence count, not a coverage percentage or conformance score.

## Skips and informational output

Flutter skipped five tests because they require separately approved harnesses
or complete development-remote read/write environments. No remote credentials
or fallback were supplied. The analyzer's 52 diagnostics were informational and
did not include warnings or errors.

## Local database evidence

After the clean no-seed reset, a read-only catalog query inside the local
database confirmed:

- 15 application tables in schema `public`;
- RLS enabled on 5 tables;
- RLS disabled on 10 legacy tables;
- those 10 tables retain broad table privileges for `anon` and
  `authenticated`.

This query exposed no real data and made no database changes. It demonstrates
repository-defined local state only, not any remote deployment state.

## Coverage interpretation

The passing pgTAP suite validates the tables and RPCs it names, including users,
specialist catalog, chat sessions, messages and product catalog constraints.
It has no regression test asserting deny-all behavior for all ten legacy public
tables. Consequently, the green suite and the P0 finding are consistent.

## Execution safety

- No linked Supabase command was used.
- No remote database, deployment, secret or production environment was used.
- No real seed or real user data was used.
- No source, test, migration, function or configuration file was changed to
  obtain a passing result.
- Local credentials emitted by tooling were not copied into this evidence.
