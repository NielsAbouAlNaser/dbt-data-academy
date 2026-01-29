### Day 1: Getting things organized 

The lights are back on. The coffee machine is working again.

Now it’s time to rebuild.

Before any transformations can happen, you need to reconnect to the raw data. Somewhere in the platform, two databases are still alive:

Customers
Finance

Each contains critical tables used by the business:

Customers -> orders

Finance -> transactions

These are your sources. Your first mission is to formally register them in dbt, so they become part of your project’s lineage.

Once the sources are connected, it’s time to bring structure to the chaos.

You remember there were conventions:
- Staging
- Intermediate
- Marts


Clean folders. Clear naming. Predictable patterns.

Create a proper dbt folder structure and prepare the project for the days ahead.


When you’re done:

- Both sources should be defined in dbt
- The models folder should follow dbt naming conventions using staging and marts