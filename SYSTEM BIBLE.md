# SYSTEM BIBLE  
Canonical Specification of the Personal Operating System  
(Layers −1 → 7 + Layer S, Deployment Patterns, Direction)

This document is the authoritative description of the system.
It exists to remove ambiguity.

It defines:
- what the system is
- how it works
- why it exists
- what problems it is solving
- what problems it explicitly refuses to solve
- where the system is going

Anything not written here does not exist.
Anything contradicted here is wrong.

---

## 1. Problem Statement

Modern computing environments fail in predictable ways:

- Machines are treated as special snowflakes.
- State leaks everywhere.
- Tools assume persistence.
- Secrets bleed into systems.
- Safety is bolted on as prompts.
- Context is lost between tools and sessions.
- Rebuilding is painful.
- Remote machines are unusable without compromise.
- Systems optimize for convenience over control.

This system exists to correct those failures.

---

## 2. Core Constraints

These constraints are not preferences.
They are non-negotiable design requirements.

- Machines are disposable.
- Environments are hostile or indifferent.
- Persistence is optional.
- Secrets must not be ambient.
- Safety must be structural.
- Rebuilds must be boring.
- Loss must be survivable.
- Muscle memory must transfer.
- Context must not silently merge.
- Nothing may auto-escalate.

---

## 3. High-Level Architecture

The system is organized as **layers**.

Layers:
- have strict responsibilities
- depend only on lower layers
- never leak upward assumptions downward

In addition to layers, the system operates under **deployment modes** that constrain persistence and access.

Layers define *what exists*.
Deployment modes define *where it is allowed to live*.

---

## 4. Deployment / Residency Patterns

Deployment modes apply across all layers.

They are not layers.
They are operating conditions.

---

### 4.1 Mode 1 — Ephemeral / Memory-Only

#### Definition

- SSH into a machine
- No trust in host
- No writes to disk
- System exists only in memory
- Session exit destroys everything

#### Properties

- No dotfiles written
- No configs persisted
- No secrets available
- No identity assumed
- No cleanup guarantees

#### Purpose

This mode exists to:
- work on machines you do not own
- inspect environments safely
- navigate and reason without leaving residue
- tolerate hostile hosts

This is a first-class mode, not a fallback.

---

### 4.2 Mode 2 — Persistent System / No Secrets

#### Definition

- System state persisted
- Configuration saved
- Secrets unavailable

#### Properties

- Dotfiles installed
- Configs symlinked
- Machine is reproducible
- Machine is safe to lose
- Machine is safe to share

#### Purpose

This mode exists to:
- do daily work
- collaborate
- rebuild without fear
- maintain a stable environment without risk

---

### 4.3 Mode 3 — Full System

#### Definition

- System persisted
- Secrets available under strict rules

#### Properties

- Secrets encrypted
- Secrets scoped and time-bound
- No ambient credentials
- Loss of machine does not imply loss of control

#### Purpose

This mode exists to:
- deploy
- publish
- authenticate
- perform sensitive operations

---

### 4.4 Promotion Model

```
Mode 1 → Mode 2 → Mode 3
```

Rules:
- promotion is manual
- nothing auto-persists
- nothing auto-gains access
- escalation increases responsibility, not convenience

---

## 5. Layer −1 — Host Reality

Layer −1 is everything the system does not control.

---

### 5.1 What Exists

- hardware
- firmware
- operating system
- kernel
- network
- power
- clock
- entropy
- legal and physical constraints

---

### 5.2 Trust Model

Layer −1 is untrusted.

Assumptions:
- availability is not guaranteed
- integrity is not guaranteed
- persistence is not guaranteed
- correctness is not guaranteed

---

### 5.3 Failure Assumptions

Layer −1 may fail by:
- disk loss
- silent updates
- permission changes
- network loss
- clock drift
- confiscation
- destruction

These are expected conditions.

---

### 5.4 Consequences

Because Layer −1 is unreliable:
- all state must be reconstructible
- all persistence must be optional
- all assumptions must be explicit

Layer −1 cannot be fixed.
It can only be survived.

---

## 6. Layer 0 — Provisioning & Determinism

Layer 0 defines how the system comes into existence.

It is infrastructure.
It is not workflow.
It is not UX.

---

### 6.1 Purpose

Layer 0 exists to answer:

Can this machine be destroyed with no meaningful loss?

---

### 6.2 Responsibilities

Layer 0 owns:
- bootstrapping
- installation order
- package management
- PATH determinism
- shell baseline
- teardown
- rebuild

Layer 0 does not own:
- shortcuts
- navigation
- safety
- secrets
- projects
- automation logic

---

### 6.3 Entry Point

`startup.sh`

Responsibilities:
- detect uninitialized state
- prompt once
- exit cleanly if declined
- source only minimal provisioning code

---

### 6.4 Initialization Marker

`~/.dotfiles/.✓`

Meaning:
- provisioning completed successfully

Rules:
- exists only in persistent modes
- removed by teardown
- absence always means uninitialized

---

### 6.5 Deployment Behavior

#### Mode 1
- no marker
- no disk writes
- no completion claim

#### Mode 2 / 3
- marker created
- dotfiles installed
- configs linked

---

### 6.6 Teardown

`wipezsh`

- removes installed tools
- removes symlinks
- removes marker
- leaves machine clean

---

## 7. Layer 1 — Human Interface Layer

Layer 1 defines how intent is expressed.

---

### 7.1 Scope

Includes:
- functions
- naming grammar
- argument flow
- error behavior
- discoverability

Excludes:
- safety decisions
- persistence
- secrets
- policy

---

### 7.2 Core Rules

- all commands are functions
- arguments always forward
- naming encodes frequency and risk
- errors are local and instructional
- success is quiet

---

### 7.3 Deployment Behavior

Identical in all modes.

If Mode 1 feels different than Mode 3, Layer 1 is wrong.

---

## 8. Layer 2 — Tool Symmetry & Navigation

Layer 2 enforces cross-tool consistency.

---

### 8.1 Navigation Invariant

```
      I = up
J = left   L = right
      K = down
```

Mandatory wherever technically possible.

---

### 8.2 Rules

- movement never executes
- execution is explicit
- defaults do not matter
- consistency matters

---

## 9. Layer 3 — Configuration Portability

Layer 3 defines where configuration lives.

---

### 9.1 Source of Truth

```
~/.dotfiles/
```

Everything else is derived.

---

### 9.2 Rules

- configs are text
- configs are versioned
- configs are explicit
- no hidden state

---

### 9.3 Deployment Behavior

#### Mode 1
- configs in memory
- no disk writes

#### Mode 2 / 3
- configs symlinked
- dotfiles authoritative

---

## 10. Layer 4 — Project Substrate

Layer 4 defines what a project is structurally.

---

### 10.1 Canonical Roles

```
project/
├── src/
├── assets/
├── build/
├── docs/
├── scripts/
└── .ai/
```

Meaning is consistent everywhere.

---

### 10.2 Deployment Behavior

- Mode 1: inspect-only or memory-only mutation
- Mode 2 / 3: full mutation allowed

---

## 11. Layer S — Safety (Execution Gate)

Layer S is an execution gate.

---

### 11.1 Behavior

1. simulate operation
2. evaluate result
3. execute only if clean
4. otherwise block and report

Silence means success.

---

### 11.2 Dry-Run Requirements

Must simulate:
- filesystem changes
- deletions
- irreversibility
- dependency breakage
- scope escalation

Incomplete simulation = failure.

---

### 11.3 Deployment Behavior

Applies in all modes.
In Mode 1, inability to simulate is failure.

---

## 12. Layer 5 — Secrets & Credentials

Layer 5 defines how sensitive material exists.

---

### 12.1 Rules

- encrypted at rest
- explicit access
- explicit scope
- explicit lifetime
- never ambient

---

### 12.2 Deployment Availability

- Mode 1: unavailable
- Mode 2: defined but empty
- Mode 3: active

Projects reference secrets by name only.

---

## 13. Layer 6 — AI Context & Collaboration

Layer 6 defines where AI context lives.

---

### 13.1 Canonical Location

```
project/.ai/
```

---

### 13.2 Structure

```
.ai/
├── CONTEXT.md
├── scratch/
│   ├── claude.md
│   ├── codex.md
│   └── gemini.md
```

---

### 13.3 Rules

- scratch is untrusted
- CONTEXT.md is curated
- promotion is explicit
- no auto-merge

---

### 13.4 Deployment Behavior

- Mode 1: scratch only, no promotion
- Mode 2 / 3: CONTEXT.md persisted

---

## 14. Layer 7 — Workflow Capture & Leverage

Layer 7 captures proven repetition.

---

### 14.1 Rule

```
manual → repeat → stabilize → capture
```

---

### 14.2 Deployment Behavior

- Mode 1: capture disabled
- Mode 2 / 3: capture allowed

---

## 15. Direction (Where This Is Going)

This system is moving toward:

- total machine disposability
- zero trust by default
- frictionless switching between local and remote
- AI collaboration without context collapse
- safety without prompts
- speed without fragility

Not by adding features.
By enforcing boundaries.

---

## 16. Non-Goals

This system does not attempt to:

- be friendly
- be beginner-oriented
- hide complexity
- guess intent
- auto-fix mistakes
- optimize for mass adoption

---

## 17. End State Definition

The system is complete when:

- losing a machine is boring
- SSHing into a random box is usable immediately
- rebuilding takes minutes, not thought
- secrets never surprise you
- safety never nags you
- navigation is unconscious
- context does not rot

---

## End of Document
