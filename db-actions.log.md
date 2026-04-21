# DB action log

Append-only record of DB-mutating commands initiated from local. The tail of this file is reviewed before any DB work, and a new entry is appended for every mutation.

Entry template:

```
## YYYY-MM-DD HH:MM TZ
**Intent:** one-line description
**Command:** exact command run
**Previous value:** if applicable
**Reverted?** no | yes — reason
```

---
