# My phData dbt Project
This is my dbt project connected to my phdata snowflake instance.

## Current usecase - Data Vault 2.0 using Pubs dataset
I started with pulling in [sample relational data](https://relational.fit.cvut.cz/dataset/Pubs) of a book publishing company.

My initial Data Vault 2.0 model using Pubs dataset just includes three main hubs:

 - title
 - author
 - store

Satellites and links were built around those three hubs. There are base models, staging hash models, raw vault and one business vault model.
![pubs_data_vault-Raw Vault.drawio.png](.github/assets/pubs_data_vault-Raw Vault.drawio.png?raw=true)

The dbt project leverages the [AutomateDv package](https://automate-dv.readthedocs.io/en/latest/).
