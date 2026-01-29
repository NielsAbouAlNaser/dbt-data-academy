### Day 3 The nightmare tests 

I barely slept.

In my nightmare, someone shipped a model where the primary keys were NULL…
and even worse: they were not unique.

If that happens in production, our rebuild is pointless.

Please. We need protection.

Your mission today is to add three safety nets to the final model you built yesterday (the orders-payment result).

1) Test 1: No NULLs in the primary key
2) Test 2: The primary key must be unique

Create a YAML file for your final model and add both tests.

3) Singular test: Paid and refunded should never both be true

I had another dream: an order was marked as paid and refunded at the same time.
That should not happen.

Write a singular test that fails if any row has both flags set to 1.

When you’re done, run:

dbt test --select day_3
