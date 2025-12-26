## Layer S — Safety (Execution Gate)

Layer S is an execution gate.

Every operation passes through Layer S before execution.

---

### Core Behavior

1. Perform a dry-run of the requested operation.
2. Evaluate the dry-run result.
3. If no errors or risk conditions are detected:
   → Execute the operation.
4. If any error or risk condition is detected:
   → Do not execute.
   → Report the result of the dry-run.

There are no prompts during normal operation.

---

### Dry-Run Definition

A dry-run must simulate the real operation as closely as possible.

This includes, when applicable:
- Filesystem changes
- Deletions or overwrites
- Permission changes
- Dependency breakage
- Irreversibility
- Scope escalation

If a dry-run cannot be reliably performed, that is treated as a failure.

---

### Visibility Rules

Layer S produces **no output** when the dry-run passes.

Layer S produces output **only** when the dry-run fails.

No confirmations.
No warnings for successful operations.
No decorative output.

---

### Failure Output Requirements

When a dry-run fails, Layer S reports:

- What would happen if executed
- Why it failed safety checks
- Whether the operation is irreversible
- What condition caused the failure
- What flags or changes would allow execution

Nothing else.

---

### Ownership

Layer S owns:
- Dry-run execution
- Failure detection
- Execution gating

Layer S does not own:
- Secrets
- Credentials
- Policies
- Workflow logic
- UI styling

---

### Invariants

- No operation executes without a successful dry-run
- No destructive action executes silently
- No interactive prompts unless failure occurs
- No execution if simulation is incomplete

---

### Summary

Layer S is silent when things are safe.

Layer S is visible only when execution is blocked.

Dry-run first.
Execute only if clean.
