# Seed

#### Seed is a small dynamic backend that manages entities, users, and authentications. It uses Neo4j a graph database NoSQL. This repo is just a part of an architecture of a kind of backend as a service like the Firebase.

### Entities

Entities are built dynamically, the user defines a schema and it is stored in the database, and in the run time, the seed gets it and builds the schema modules using metaprogramming and stores it in a GenServer to share with other modules.

### How to test it.

You need to create a node in the database with the label Root and define it in the config file, setting the key app_id with the uuid of it.
