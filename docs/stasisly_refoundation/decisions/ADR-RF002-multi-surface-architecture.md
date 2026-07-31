# ADR-RF002 - Multi-surface architecture

## Status

`Decision: APPROVED`

`Implementation: PLANNED`

## Decision

Adopt Product, Development and Administration as the initial independently
governed surfaces, plus Founder Private Console and an internal Platform layer.
Each has explicit identity, authorization, audit and contract boundaries.

New top-level surfaces require Founder approval and an ADR. Existing surfaces
must remain independently evolvable and scalable.
