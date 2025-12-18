# Deployment Patterns — Synthesized Summary

This document synthesizes the **deployment and residency patterns** you described across the conversation and notes.  
It does **not** introduce new layers or concepts.  
It only consolidates what you already talked about, made explicit and organized.

---

## Core Idea

The same layered system operates under **different persistence constraints**.

Nothing about the architecture changes.  
Only **where state lives** and **what is allowed to persist** changes.

This is not a new layer.
This is a **deployment axis** that applies across Layers −1 through 7.

---

## The Three Deployment Patterns

You described **three distinct modes** of operation.

They form a progression, not a fork.

---

## Mode 1 — Ephemeral / Memory-Only (Remote, SSH)

### Description

- SSH into a remote machine
- No state is written to disk
- System exists only in memory
- Machine is treated as disposable
- Exit = total loss of system state

### Characteristics

- No dotfiles persisted
- No configs written
- No secrets present
- No machine identity assumed
- Zero trust in host

### What Still Works

- Navigation
- Tool symmetry
- Command ergonomics
- Muscle memory
- Human Interface Layer
- Project inspection
- Read-only work
- Temporary scratch work

### Constraints

- Everything must tolerate:
  - no persistence
  - no cleanup guarantees
- Anything requiring disk writes must be:
  - disabled
  - redirected to memory
  - or explicitly forbidden

### Layer Interaction

- Layer −1: fully hostile, acknowledged
- Layer 0: bootstrap exists conceptually, but does not commit
- Layer 1–2: fully usable
- Layer 3: resolves to memory (tmpfs / RAM)
- Layer 5: unavailable by design
- Layer S: still applies (dry-run still runs)
- Projects: treated as read-only or temporary

### Purpose

This mode exists to allow:

- safe remote work
- inspection without footprint
- zero-trust environments
- machines you do not own

---

## Mode 2 — Persistent System / No Secrets

### Description

- System state is written to disk
- Dotfiles and configs are persisted
- Machine is reproducible
- Secrets are explicitly absent

### Characteristics

- Dotfiles are the source of truth
- Configs are symlinked
- Machine can be rebuilt at any time
- Machine is safe to lose or share
- No credential risk

### What Works

- Full Layer 0 provisioning
- Full Layer 1–4 functionality
- Stable environment
- Project work
- Automation (non-secret)
- AI context files
- Workflow capture

### Constraints

- Anything requiring secrets fails explicitly
- No ambient credentials
- No fallback behavior

### Layer Interaction

- Layer −1: still untrusted, but mitigated
- Layer 0: fully active
- Layer 3: disk-backed
- Layer 5: defined but inactive
- Layer S: fully active
- Projects: fully functional
- AI context: persistent

### Purpose

This mode exists to allow:

- safe daily work
- portable machines
- collaboration
- rebuilding without fear
- “nothing valuable on the box”

---

## Mode 3 — Full System (Persistent + Secrets)

### Description

- System state persisted
- Secrets available under explicit rules
- Full local capability

### Characteristics

- Secrets are encrypted
- Secrets are scoped and time-bound
- Secrets are not ambient
- Escalation is explicit

### What Works

- Everything from Mode 2
- API access
- Deployment
- Publishing
- Authenticated automation

### Constraints

- Secrets remain isolated
- Loss of machine ≠ loss of control
- Secrets are revocable
- Scope is deliberate

### Layer Interaction

- Layer 5 becomes active
- Secrets are injected on request
- No other layer changes

### Purpose

This mode exists to allow:

- production work
- releases
- authenticated operations
- full creative output

---

## Promotion Path (Implicit, Not Automated)

You described a **step-up model**, not automatic escalation.

```
Ephemeral (memory)
    ↓
Persistent (no secrets)
    ↓
Full system (with secrets)
```

Rules:

- Promotion is deliberate
- Nothing auto-persists
- Nothing auto-gains access
- Each step increases responsibility, not convenience

---

## Key Constraints You Repeatedly Emphasized

These appeared across your notes and corrections:

- Nothing should assume persistence
- Nothing should assume secrets
- Nothing should silently escalate
- Disk is optional
- Memory-only execution is valid
- Losing a machine should not matter
- Rebuilding should be boring
- The system should survive hostile hosts

---

## What This Is *Not*

- Not a new layer
- Not a safety feature
- Not a policy engine
- Not a permissions model

It is **deployment discipline** applied to an existing layered system.

---

## Summary

You defined:

- A single layered architecture
- Running under three residency modes
- With explicit, non-automatic promotion
- And strict separation between:
  - system
  - secrets
  - persistence

The missing piece was not invention — it was **articulation**.

This document captures exactly that, and nothing more.
