

--- Day 5: Over Hours ---

A new message hits your inbox.

It’s big. It’s urgent. And it’s definitely going to be over hours.

This is the final push.

Today, you’ll fix the last structural problems in the platform and turn everything into something production-ready.

---

## Your Missions

### 1) Jinja: Control schema generation

Create a macro that defines how schemas are generated.

It should follow these rules:

* If a custom schema name is provided, use it (lowercased)
* Otherwise, fall back to the target schema

This macro will make sure environments stay separated and organized.

---

### 2) Source freshness: trust your data again

One of the sources needs a freshness check.

Add a freshness rule so that:

* dbt throws an **error** if the data is older than **24 hours**
* dbt shows a **warning** if the data is older than **3 hours**

This is how you make sure you’re never building on stale data.

---

### 3) Refactor the hard query

You’ve been given one last piece of difficult legacy SQL.

Split it into proper dbt layers:

* staging
* intermediate
* mart (final)

Clean logic. Clear naming. No hardcoded schemas.

---

When everything is done, run:

```
dbt build
```

If it passes, the platform is restored.

You survived the blackout.

---

If you want, I can also provide a tiny snippet for the freshness config so nobody gets stuck on YAML syntax.
